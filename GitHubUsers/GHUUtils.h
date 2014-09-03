//
//  GhuUtils.h
//  GitHubUsers
//
//  Created by Rushad on 5/30/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GhuUtils : NSObject

+ (UIActivityIndicatorView*)startSpinnerAtView:(UIView*)view;
+ (void)stopSpinner:(UIActivityIndicatorView*)spinner;

@end
