//
//  GHUAppDelegate.h
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/3/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationsDocumentsDirectory;

@end
