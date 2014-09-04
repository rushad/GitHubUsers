//
//  GHUUserViewController.m
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/4/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import "GHUUserViewController.h"

#import "GHUUtils.h"
#import "GHUWebViewController.h"

@interface GHUUserViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UIButton *urlView;
@property (weak, nonatomic) IBOutlet UILabel *idView;
@property (weak, nonatomic) IBOutlet UILabel *scoreView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (nonatomic, strong) UIActivityIndicatorView* spinner;

@end

@implementation GHUUserViewController

static NSString* const avatarKeyPath = @"avatar";
static NSString* const webNibName = @"Web_iPhone";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.userInfo.name;
    self.nameView.text = self.userInfo.name;
    self.avatarView.image = self.userInfo.avatar;
    [self.urlView setTitle:self.userInfo.url forState:UIControlStateNormal];
    self.idView.text = [NSString stringWithFormat:@"ID: %d", self.userInfo.userId];
    self.scoreView.text = [NSString stringWithFormat:@"Score: %.2f", self.userInfo.score.floatValue];
    if (!self.userInfo.avatar)
    {
        [self.userInfo addObserver:self forKeyPath:avatarKeyPath options:NSKeyValueObservingOptionNew context:nil];
        self.spinner = [GHUUtils startSpinnerAtView:self.view];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:avatarKeyPath])
    {
        UIImage* avatar = [change objectForKey:NSKeyValueChangeNewKey];
        [GHUUtils stopSpinner:self.spinner];
        self.avatarView.image = avatar;
        [self.userInfo removeObserver:self forKeyPath:avatarKeyPath];
    }
}

- (IBAction)urlPressed:(id)sender
{
    GHUWebViewController* webViewController = [[GHUWebViewController alloc] initWithNibName:webNibName bundle:nil];
    webViewController.url = self.userInfo.url;
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
