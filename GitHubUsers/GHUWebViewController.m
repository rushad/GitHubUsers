//
//  GHUWebViewController.m
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/4/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import "GHUWebViewController.h"

#import "GHUUtils.h"

@interface GHUWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView* spinner;

@end

@implementation GHUWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.spinner = [GHUUtils startSpinnerAtView:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [GHUUtils stopSpinner:self.spinner];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [GHUUtils stopSpinner:self.spinner];
}

@end
