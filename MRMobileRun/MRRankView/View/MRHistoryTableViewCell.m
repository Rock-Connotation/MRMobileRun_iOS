//
//  MRHistoryTableViewCell.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/8.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRHistoryTableViewCell.h"
#import "MASonry.h"
@implementation MRHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
         // NSLog(@"cellForRowAtIndexPath");
         static NSString *identifier = @"history";
         // 1.缓存中取
         MRHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        // 2.创建
         if (cell == nil) {
                 cell = [[MRHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
             }
         return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateLabel =  [[UILabel alloc]init];
        self.dateLabel.text = @"2016-2-1   20:13";
        self.dateLabel.font = [UIFont  boldSystemFontOfSize: 13*screenWidth/414.0];
        self.dateLabel.textColor = [UIColor colorWithRed:141.0/255.0 green:140.0/255.0 blue:168.0/255.0 alpha:1];
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self.contentView).with.insets(UIEdgeInsetsMake(35.0/1334.0*screenHeigth, 40.0/750.0*screenWidth, 126.0/1334.0*screenHeigth, 0/750.0*screenWidth));
        }];
        
        
        
        self.timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.text = @"00:27:23";
        self.timeLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:22*screenWidth/414.0];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self.contentView).with.insets(UIEdgeInsetsMake(118.0/1334.0*screenHeigth, 291.0/750.0*screenWidth, 29.0/1334.0*screenHeigth, 323.0/750.0*screenWidth));
        }];
        
        
        
        
        self.distanceLabel = [[UILabel alloc]init];
        self.distanceLabel.text = @"12";
        self.distanceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:44*screenWidth/414.0];
        self.distanceLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:16.0/255.0 blue:86.0/255.0 alpha:1];
        
        [self.contentView addSubview:self.distanceLabel];
        [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self.contentView).with.insets(UIEdgeInsetsMake(96.0/1334.0*screenHeigth, 33.0/750.0*screenWidth, 36.0/1334.0*screenHeigth, 578.0/750.0*screenWidth));

        }];
        
        self.kmLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.kmLabel];
        self.kmLabel.text = @"KM";
        
        [self.kmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self.distanceLabel).with.insets(UIEdgeInsetsMake(32/1334.0*screenHeigth, 147/750.0*screenWidth, -1/1334.0*screenHeigth, - 104/750.0*screenWidth));
        }];
        
        self.kmLabel.textColor =  [UIColor colorWithRed:141.0/255.0 green:140.0/255.0 blue:168.0/255.0 alpha:1];
        self.kmLabel.font = [UIFont boldSystemFontOfSize:13 *screenWidth/375.0];

        
        
   
        
        self.line = [[UIImageView alloc]init];
        self.line.image =[UIImage imageNamed:@"分割线4"];
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self.contentView).with.insets(UIEdgeInsetsMake(191.0/1334.0*screenHeigth, 0/750*screenWidth, 0/1334.0*screenHeigth, 0/750.0*screenWidth));
        }];

        
        self.viewFootprintsBtu = [[UIButton alloc]init];
        [self.viewFootprintsBtu setTitle:@"查看足迹" forState:UIControlStateNormal];
        self.viewFootprintsBtu.titleLabel.font = [UIFont boldSystemFontOfSize:15*screenWidth/414.0];
        [self.viewFootprintsBtu setTitleColor:[UIColor colorWithRed:251.0/255.0 green:98.0/255.0 blue:105.0/255 alpha:1] forState:UIControlStateNormal];
        [self.viewFootprintsBtu bringSubviewToFront:self.contentView];
        [self.contentView addSubview:self.viewFootprintsBtu];
        [self.viewFootprintsBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self.contentView).with.insets(UIEdgeInsetsMake(120.0/1334.0*screenHeigth, 587.0/750*screenWidth, 41.0/1334.0*screenHeigth, 32.0/750.0*screenWidth));
        }];

    }
    return self;
}


@end
