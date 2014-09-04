//
//  GHUUserCell.h
//  GitHubUsers
//
//  Created by Rushad Nabiullin on 9/2/14.
//  Copyright (c) 2014 rushad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHUUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *urlView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@end
