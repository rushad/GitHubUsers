//
//  GHUImageCache.m
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/2/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import "GHUImageCache.h"

#import <CoreData/CoreData.h>

@interface GHUImageCache()

@property (readonly, nonatomic, strong) NSOperationQueue* queue;
@property (readonly, nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end

@implementation GHUImageCache

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _queue = [[NSOperationQueue alloc] init];
        id delegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

- (void)startLoadingImageWithUrl:(NSString*)url
                        userData:(id)userData
               completionHandler:(void(^)(UIImage*, id))completionHandler
{
    UIImage* image = [self loadFromCacheImageWithUrl:url];
    NSBlockOperation* loadOperation;
    if (image)
    {
        loadOperation = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(image, userData);
            });
        }];
    }
    else
    {
        loadOperation = [NSBlockOperation blockOperationWithBlock:^{
            UIImage* image = [self loadFromWebImageWithUrl:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveImage:image withUrl:url];
                completionHandler(image, userData);
            });
        }];
    }
    [self.queue addOperation:loadOperation];
}

- (UIImage*)loadFromCacheImageWithUrl:(NSString*)url
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Image"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
    [fetchRequest setPredicate:predicate];
    NSError* error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSManagedObject* imageObject = results.firstObject;
    NSData* imageBits = [imageObject valueForKey:@"image"];
    return [UIImage imageWithData:imageBits];
}

- (UIImage*)loadFromWebImageWithUrl:(NSString*)url
{
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    return image;
}

- (void)saveImage:(UIImage*)image withUrl:(NSString*)url
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
    [object setValue:url forKey:@"url"];
    [object setValue:UIImagePNGRepresentation(image) forKey:@"image"];
    NSError* error = nil;
    [self.managedObjectContext save:&error];
}

@end
