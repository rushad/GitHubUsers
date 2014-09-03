//
//  GhuUtils.m
//  GitHubUsers
//
//  Created by Rushad on 5/30/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "GhuUtils.h"

@implementation GHUUtils

+ (UIActivityIndicatorView*)startSpinnerAtView:(UIView*)view
{
    CGPoint center = view.center;
    center.x += view.bounds.origin.x;
    center.y += view.bounds.origin.y;
    CGRect spinnerRect = CGRectMake(center.x - 10, center.y - 10, 20, 20);
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:spinnerRect];
    spinner.color = [UIColor blueColor];
    [spinner startAnimating];
    [view addSubview:spinner];
    return spinner;
}

+ (void)stopSpinner:(UIActivityIndicatorView*)spinner
{
    [spinner removeFromSuperview];
}

@end
