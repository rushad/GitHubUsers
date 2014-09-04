//
//  GHUMainViewController.m
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/2/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import "GHUMainViewController.h"

#import "GHUImageCache.h"
#import "GHUUserCell.h"
#import "GHUUserInfo.h"
#import "GHUUserViewController.h"
#import "GHUUtils.h"

#import <RestKit/RestKit.h>

@interface GHUMainViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSString* currentSearchString;
@property (nonatomic) NSNumber* searchId;
@property (nonatomic, strong) NSArray* users;
@property (nonatomic, strong) GHUImageCache* imageCache;
@property (nonatomic, weak) UITableView* tableView;

@end

@implementation GHUMainViewController

static NSString* const userCellNibName = @"UserCell";
static NSString* const userNibName = @"User_iPhone";
static NSString* const userCellId = @"UserCell";

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.imageCache = [[GHUImageCache alloc] init];
        self.searchId = [NSNumber numberWithInt:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureRestKit];

    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:self.navigationItem.titleView.frame];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;

    UITableView* tableView = (UITableView*)self.view;
    [tableView registerNib:[UINib nibWithNibName:userCellNibName bundle:nil] forCellReuseIdentifier:userCellId];
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.github.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[GHUUserInfo class]];
    [userMapping addAttributeMappingsFromDictionary:@{
                                                       @"id" : @"userId",
                                                       @"login" : @"name",
                                                       @"score" : @"score",
                                                       @"html_url" : @"url",
                                                       @"avatar_url" : @"avatarUrl"
                                                     }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/search/users"
                                                keyPath:@"items"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)loadUsers
{
    UIActivityIndicatorView* spinner = [GHUUtils startSpinnerAtView:self.view];
    
    NSDictionary *queryParams = @{@"q" : self.currentSearchString};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/search/users"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                                       {
                                                           [GHUUtils stopSpinner:spinner];
                                                           _users = mappingResult.array;
                                                           [self.tableView reloadData];
                                                       }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error)
                                                       {
                                                           NSLog(@"Error loading users: %@", error);
                                                       }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    self.currentSearchString = searchBar.text;
    self.searchId = [NSNumber numberWithInt:self.searchId.intValue + 1];
    
    self.users = [[NSArray alloc] init];
    UITableView* tableView = (UITableView*)self.view;
    [tableView reloadData];
    
    [self loadUsers];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = self.currentSearchString;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GHUUserCell* cell = [tableView dequeueReusableCellWithIdentifier:userCellId];
    cell.avatarView.image = nil;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(GHUUserCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GHUUserInfo* userInfo = self.users[indexPath.row];
    cell.nameView.text = userInfo.name;
    cell.urlView.text = userInfo.url;
    if (userInfo.avatar)
    {
        cell.avatarView.image = userInfo.avatar;
    }
    else
    {
        UIActivityIndicatorView* spinner = [GHUUtils startSpinnerAtView:cell.avatarView];
        
        [self.imageCache startLoadingImageWithUrl:userInfo.avatarUrl
                                         userData:self.searchId
                                completionHandler:^(UIImage* image, NSNumber* searchId)
                                                   {
                                                       if ([searchId isEqualToNumber:self.searchId])
                                                       {
                                                           [GHUUtils stopSpinner:spinner];
                                                           userInfo.avatar = image;
                                                           [tableView beginUpdates];
                                                           [tableView reloadRowsAtIndexPaths:@[indexPath]
                                                                            withRowAnimation:UITableViewRowAnimationFade];
                                                           [tableView endUpdates];
                                                       }
                                                   }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GHUUserViewController* userViewController = [[GHUUserViewController alloc] initWithNibName:userNibName bundle:nil];
    userViewController.userInfo = self.users[indexPath.row];
    [self.navigationController pushViewController:userViewController animated:YES];
}

@end
