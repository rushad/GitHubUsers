//
//  GHUMainViewController.m
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/2/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import "GHUMainViewController.h"
#import "GHUUserCell.h"

@interface GHUMainViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSString* currentSearchString;

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
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:self.navigationItem.titleView.frame];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
/*
    UITableView* tableView = (UITableView*)self.view;

    [tableView registerClass:[GHUUserCell class] forCellReuseIdentifier:@"UserCell"];
//    [tableView registerNib:[UINib nibWithNibName:@"Main_iPhone" bundle:nil] forCellReuseIdentifier:@"UserCell"];
*/ 
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.currentSearchString = searchBar.text;
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
    return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GHUUserCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellReuseIdentifier:@"UserCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(GHUUserCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.login.text = [NSString stringWithFormat:@"User %d", indexPath.row];
}

@end
