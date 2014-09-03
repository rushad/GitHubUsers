//
//  GHUImageCache.m
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/2/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import "GHUImageCache.h"

@interface GHUImageCache()

@property (nonatomic, strong) NSOperationQueue* queue;

@end

@implementation GHUImageCache

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)startLoadingImageWithUrl:(NSString*)url
                        userData:(id)userData
               completionHandler:(void(^)(UIImage*, id))completionHandler
{
    NSBlockOperation* loadOperation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(image, userData);
        });
    }];
    [self.queue addOperation:loadOperation];
}

@end
