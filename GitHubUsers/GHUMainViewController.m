//
//  GHUMainViewController.m
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/2/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import "GHUMainViewController.h"

#import "GHUUserCell.h"
#import "GHUUserInfo.h"
#import "GHUUtils.h"

#import <RestKit/RestKit.h>

@interface GHUMainViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSString* currentSearchString;
@property (nonatomic, strong) NSArray* users;
@property (nonatomic, weak) UITableView* tableView;

@end

@implementation GHUMainViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    [tableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellReuseIdentifier:@"UserCell"];
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
    [userMapping addAttributeMappingsFromArray:@[@"login"]];
    
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
    NSString* login = @"Rushad";
    
    NSDictionary *queryParams = @{@"q" : login};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/search/users"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _users = mappingResult.array;
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no users?': %@", error);
                                              }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    self.currentSearchString = searchBar.text;
    
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
    return [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(GHUUserCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GHUUserInfo* userInfo = self.users[indexPath.row];
    cell.login.text = userInfo.login;
}

@end
