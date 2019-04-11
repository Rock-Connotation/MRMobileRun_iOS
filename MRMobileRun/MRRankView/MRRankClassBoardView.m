//
//  MRRankClassBoardView.m
//  AnotherDemo
//
//  Created by RainyTunes on 2017/2/24.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import "MRRankClassBoardView.h"
#import "Masonry.h"
#import "WeKit.h"

static const NSInteger text_name_color = 0x2F2C6A;
static const NSInteger text_detail_color = 0xA2A2B9;

@interface MRRankClassBoardView ()
@property UIImageView *boardImageView;
//@property UIImageView *avatarImageView;
//@property UILabel *nameLabel;
//@property UILabel *rankLabel;
//@property UILabel *distanceLabel;
//@property UILabel *gapDistanceLabel;
@end

@implementation MRRankClassBoardView
- (instancetype)init {
    CGRect rect = CGRectMake(0, 114 *screenHeigth/667.0, ScreenWidth, 112.0 * ScreenHeight / 667.0);
    self = [super initWithFrame:rect];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    //背景板
    UIImage *i0 = [UIImage imageNamed:@"我的班级信息底板"];
    self.boardImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.boardImageView.image = i0;
    [self addSubview:self.boardImageView];
    
    //班级图标
    UIImage *i1 = [UIImage imageNamed:@"班级icon"];
    self.classIconImageVIew = [[UIImageView alloc] init];
    self.classIconImageVIew.image = i1;
    [self addSubview:self.classIconImageVIew];
    
    //班级编号
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"";
    self.nameLabel.textColor = UIColorFromRGB(text_name_color);
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:17*screenWidth/414.0];
    [self addSubview:self.nameLabel];
    
    //班级排名
    self.rankLabel = [[UILabel alloc] init];
    self.rankLabel.text = @"排名:";
    self.rankLabel.textColor = UIColorFromRGB(text_detail_color);
    self.rankLabel.font = [UIFont fontWithName:@"Helvetica" size:15*screenWidth/414.0];
    [self addSubview:self.rankLabel];
    
    //班级路程
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.text = @"路程:   km";
    self.distanceLabel.textColor = UIColorFromRGB(text_detail_color);
    self.distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:15*screenWidth/414.0];
    [self addSubview:self.distanceLabel];
    
    //班级差距
    self.gapDistanceLabel = [[UILabel alloc] init];
    self.gapDistanceLabel.text = @"距上一名:   km";
    self.gapDistanceLabel.textColor = UIColorFromRGB(text_detail_color);
    self.gapDistanceLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0*screenWidth/414.0];
    [self addSubview:self.gapDistanceLabel];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    CGFloat rateX = ScreenWidth / 375.0;
    CGFloat rateY = ScreenHeight / 667.0;
    UIEdgeInsets padding0 = UIEdgeInsetsMake(34.5 * rateY, 22 * rateX, 58.5 * rateY, 332 * rateX);
    [self.classIconImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding0);
    }];
    
    UIEdgeInsets padding1 = UIEdgeInsetsMake(29 * rateY, 51 * rateX, 54 * rateY, 242.5 * rateX);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding1);
    }];
    
    UIEdgeInsets padding2 = UIEdgeInsetsMake(55.5 * rateY, 21 * rateX, 31.5 * rateY, 5 * rateX);
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding2);
    }];
    
    UIEdgeInsets padding3 = UIEdgeInsetsMake(32.5 * rateY, 232 * rateX, 54.5 * rateY, 5 * rateX);
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding3);
    }];
    
    UIEdgeInsets padding4 = UIEdgeInsetsMake(55.5 * rateY, 231 * rateX, 31.5 * rateY, 5 * rateX);
    [self.gapDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding4);
    }];
    [super updateConstraints];
}

+ (instancetype)boardView {
    MRRankClassBoardView *boardView = [[MRRankClassBoardView alloc] init];
    return boardView;
}
@end
