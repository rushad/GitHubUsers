//
//  GHUWebViewController.m
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/4/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import "GHUWebViewController.h"

@interface GHUWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GHUWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

@end
