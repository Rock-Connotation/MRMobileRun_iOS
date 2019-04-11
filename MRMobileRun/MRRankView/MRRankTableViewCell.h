//
//  MRRateTableViewCell.h
//  AnotherDemo
//
//  Created by RainyTunes on 2017/2/24.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRRankInfo.h"

@interface MRRankTableViewCell : UITableViewCell
@property UILabel *rankLabel;
@property UILabel *nameLabel;
@property UILabel *schoolLabel;
@property UILabel *distanceLabel;
@property UIImageView *avatarImageView;
@property UIImageView *rankImageView;
//这个是前三名的图标
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setRankInfo:(MRRankInfo *)rankInfo;
@property BOOL hasImage;

@end
