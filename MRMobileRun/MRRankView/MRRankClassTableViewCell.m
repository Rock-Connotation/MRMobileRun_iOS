//
//  MRRankClassTableViewCell.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/20.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRRankClassTableViewCell.h"
#import "Masonry.h"
#import "WeKit.h"

static const NSInteger first_rank_color = 0xFA7F6A;
static const NSInteger second_rank_color = 0xFF9179;
static const NSInteger third_rank_color = 0xFD941C;
static const NSInteger normal_rank_color = 0xABB0CD;
static const NSInteger rank_colors[4] = {first_rank_color, second_rank_color, third_rank_color, normal_rank_color};

static const NSInteger text_name_color = 0x130f56;
static const NSInteger text_school_color = 0xAFB4D0;

@implementation MRRankClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"statu";
    MRRankClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MRRankClassTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.height = 148.0/screenHeigth *1334;
        
        self.rankLabel = [[UILabel alloc] init];
        self.rankLabel.font = self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:29*screenWidth/414.0];
        [self.contentView addSubview:self.rankLabel];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14*screenWidth/414.0];
        self.nameLabel.textColor = UIColorFromRGB(text_name_color);
        [self.contentView addSubview:self.nameLabel];
        
        self.schoolLabel = [[UILabel alloc] init];
        self.schoolLabel.font = self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:12*screenWidth/414.0];
        self.schoolLabel.textColor = UIColorFromRGB(text_school_color);
        [self.contentView addSubview:self.schoolLabel];
        
        self.distanceLabel = [[UILabel alloc] init];
        self.distanceLabel.font = self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:18*screenWidth/414.0];
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.distanceLabel];
        
        self.rankImageView = [[UIImageView alloc]init];
        [self addSubview:self.rankImageView];
    }
    return self;
}

- (void)setRankInfo:(MRRankInfo *)rankInfo {
    NSUInteger index = rankInfo.rankIndex.integerValue;
    
    self.rankLabel.text = rankInfo.rankIndex;
    self.distanceLabel.text = [rankInfo.distance stringByAppendingString:@"KM"];
    self.nameLabel.text = rankInfo.name;
    self.schoolLabel.text = rankInfo.schoolName;
    
    if (index <= 3) {
        self.rankLabel.hidden = YES;
        switch (index) {
            case 1:
                self.rankImageView.image = [UIImage imageNamed:@"第1名"];
                self.distanceLabel.textColor = UIColorFromRGB(rank_colors[0]);
                break;
            case 2:
                self.rankImageView.image = [UIImage imageNamed:@"第2名"];
                self.distanceLabel.textColor = UIColorFromRGB(rank_colors[1]);
                break;
            case 3:
                self.rankImageView.image = [UIImage imageNamed:@"第3名"];
                self.distanceLabel.textColor = UIColorFromRGB(rank_colors[2]);
                break;
        }
    } else {
        self.rankLabel.textColor = UIColorFromRGB(rank_colors[3]);
        self.distanceLabel.textColor = UIColorFromRGB(rank_colors[3]);
    }
    
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    CGFloat rateX = ScreenWidth / 375.0;
    CGFloat rateY = ScreenHeight / 667.0;
    
    UIEdgeInsets padding0 = UIEdgeInsetsMake(20 * rateY, 19.5 * rateX, 20.5 * rateY, 300 * rateX);
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding0);
    }];
    
    UIEdgeInsets padding1 = UIEdgeInsetsMake(26 * rateY, 5 * rateX, 27 * rateY, 19.5 * rateX);
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding1);
    }];
    
    UIEdgeInsets padding3 = UIEdgeInsetsMake(17.5 * rateY, 68.5 * rateX, 40.5 * rateY, 5 * rateX);
    UIEdgeInsets padding4 = UIEdgeInsetsMake(40.5 * rateY, 68 * rateX, 21.5 * rateY, 5 * rateX);
    
    [self.rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake( 52.0 *ScreenHeight/1334.0,41.0 *ScreenHeight/1334.0,53.7 *screenHeigth/1334.0,674.1 *screenHeigth/1334.));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding3);
    }];
    
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding4);
    }];
    
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
