//
//  GHUImageCache.h
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/2/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHUImageCache : NSObject

- (void)startLoadingImageWithUrl:(NSString*)url
               completionHandler:(void(^)(UIImage*))completionHandler;

@end
