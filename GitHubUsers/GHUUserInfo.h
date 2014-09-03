//
//  GHUUserInfo.h
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/3/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHUUserInfo : NSObject

@property NSUInteger userId;
@property (strong) NSString* name;
@property (strong) NSNumber* score;
@property (strong) NSString* url;
@property (strong) NSString* avatarUrl;
@property (strong) UIImage* avatar;

@end
