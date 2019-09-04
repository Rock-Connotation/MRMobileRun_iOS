//
//  MRHistoryTableViewCell.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/8.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRHistoryTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *distanceLabel;
//显示跑步距离label
@property (nonatomic,strong) UILabel *timeLabel;
//显示每次跑步时间的label
@property (nonatomic,strong) UILabel *dateLabel;
//显示当前日期label
@property (nonatomic,strong) UILabel *kmLabel;
//千米符号label
@property (nonatomic,strong) UIButton *viewFootprintsBtu;
//查看足迹按钮
@property (nonatomic,strong) UIImageView *line;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
