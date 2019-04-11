//
//  MRRankClassBoardView.m
//  AnotherDemo
//
//  Created by RainyTunes on 2017/2/24.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import "MRRankPersonalBoardView.h"
#import <Masonry.h>
#import "WeKit.h"

static const NSInteger text_name_color = 0x2F2C6A;
static const NSInteger text_detail_color = 0xA2A2B9;

@interface MRRankPersonalBoardView ()
@property UIImageView *boardImageView;
@end

@implementation MRRankPersonalBoardView
- (instancetype)init {
    CGRect rect = CGRectMake(0, 114 *screenHeigth/667.0, ScreenWidth, 112 * ScreenHeight / 667);
    self = [super initWithFrame:rect];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    //背景板
    UIImage *i0 = [UIImage imageNamed:@"我的信息板底"];
    self.boardImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.boardImageView.image = i0;
    [self addSubview:self.boardImageView];
    
    //用户头像
    UIImage *i1 = [UIImage imageNamed:@"用户"];
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = i1;
    [self addSubview:self.avatarImageView];
    
    
    self.avatarImageView.clipsToBounds=YES;
    
    self.avatarImageView.layer.cornerRadius=97.0/4.0 *screenWidth /375.0;
    
    //用户名字
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"";
    self.nameLabel.textColor = UIColorFromRGB(text_name_color);
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:17*screenWidth/414.0];
    [self addSubview:self.nameLabel];
    
    //用户排名
    self.rankLabel = [[UILabel alloc] init];
    self.rankLabel.text = @"排名: ";
    self.rankLabel.textColor = UIColorFromRGB(text_detail_color);
    self.rankLabel.font = [UIFont fontWithName:@"Helvetica" size:15*screenWidth/414.0];
    [self addSubview:self.rankLabel];
    
    //用户路程
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.text = @"路程:   km";
    self.distanceLabel.textColor = UIColorFromRGB(text_detail_color);
    self.distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:15*screenWidth/414.0];
    [self addSubview:self.distanceLabel];
    
    //用户差距
    self.gapDistanceLabel = [[UILabel alloc] init];
    self.gapDistanceLabel.text = @"距上一名:   km";
    self.gapDistanceLabel.textColor = UIColorFromRGB(text_detail_color);
    self.gapDistanceLabel.font = [UIFont fontWithName:@"Helvetica" size:15*screenWidth/414.0];
    [self addSubview:self.gapDistanceLabel];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    
    CGFloat rateX = ScreenWidth / 375.0;
    CGFloat rateY = ScreenHeight / 667.0;
    UIEdgeInsets padding0 = UIEdgeInsetsMake(30 * rateY, 24 * rateX, 33.5 * rateY, 302.5 * rateX);
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding0);
    }];
    
    UIEdgeInsets padding1 = UIEdgeInsetsMake(32 * rateY, 90.5 * rateX, 52 * rateY, 130 * rateX);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding1);
    }];
    
    UIEdgeInsets padding2 = UIEdgeInsetsMake(55.5 * rateY, 90 * rateX, 30.5 * rateY, 5 * rateX);
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding2);
    }];
    
    UIEdgeInsets padding3 = UIEdgeInsetsMake(32.5 * rateY, 232 * rateX, 53.5 * rateY, 5 * rateX);
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding3);
    }];
    
    UIEdgeInsets padding4 = UIEdgeInsetsMake(55 * rateY, 231 * rateX, 31 * rateY, 5 * rateX);
    [self.gapDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding4);
    }];
    [super updateConstraints];
}

+ (instancetype)boardView {
    MRRankPersonalBoardView *boardView = [[MRRankPersonalBoardView alloc] init];
    return boardView;
}
@end
