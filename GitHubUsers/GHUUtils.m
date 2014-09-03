//
//  GhuUtils.m
//  GitHubUsers
//
//  Created by Rushad on 5/30/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "GhuUtils.h"

@implementation GhuUtils

+ (UIActivityIndicatorView*)startSpinnerAtView:(UIView*)view
{
  CGRect viewRect = view.frame;
  CGRect spinnerRect = CGRectMake((viewRect.size.width - 50)/2, (viewRect.size.height-50)/2, 50, 50);
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:spinnerRect];
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
