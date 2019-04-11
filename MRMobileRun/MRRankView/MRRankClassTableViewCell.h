//
//  MRRankClassTableViewCell.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/20.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRRankInfo.h"

@interface MRRankClassTableViewCell : UITableViewCell
@property UILabel *rankLabel;
@property UILabel *nameLabel;
@property UILabel *schoolLabel;
@property UILabel *distanceLabel;
@property UIImageView *rankImageView;
//这个是前三名的图标
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setRankInfo:(MRRankInfo *)rankInfo;
@property BOOL hasImage;

@end
