//
//  MRRankTitleView.m
//  AnotherDemo
//
//  Created by RainyTunes on 2017/2/24.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import "MRRankTitleView.h"
#import "Masonry.h"
#import "WeKit.h"

static const NSInteger text_normal_color = 0xF2F6F7;
static const NSInteger text_inactive_color = 0xDEBDEC;

@interface MRRankTitleView ()
@property UIImageView *titleBackGroundImageView;
@property UILabel *navigationBarTitle;

@end

@implementation MRRankTitleView
- (instancetype)init {
    CGRect rect = CGRectMake(0, 0, ScreenWidth, 118 *screenHeigth/667.0);
    self = [super initWithFrame:rect];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    //导航栏上下的背景
    UIImage *i0 = [UIImage imageNamed:@"nav+导航栏底板"];
    self.titleBackGroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.titleBackGroundImageView.image = i0;
    [self addSubview:self.titleBackGroundImageView];
    //导航栏的回退箭头
    UIImage *i1 = [UIImage imageNamed:@"<返回"];
    self.arrowImageView = [[UIImageView alloc] init];
    self.arrowImageView.image = i1;
    [self addSubview:self.arrowImageView];
    
    self.backButton = [[UIButton alloc]init];
    [self addSubview:self.backButton];
    
    //导航栏标题
    self.navigationBarTitle = [[UILabel alloc] init];
    self.navigationBarTitle.text = @"排行榜";
    self.navigationBarTitle.textColor = UIColorFromRGB(text_normal_color);
    self.navigationBarTitle.font = [UIFont fontWithName:@"Helvetica" size:18*screenWidth/414.0];
    [self addSubview:self.navigationBarTitle];
    //顶tab1按钮
    self.firstTabButton = [[UIButton alloc] init];
    [self addSubview:self.firstTabButton];
    //顶tab2按钮
    self.secondTabButton = [[UIButton alloc] init];
    [self addSubview:self.secondTabButton];
    //顶tab1标签
    self.firstTabLabel = [[UILabel alloc] init];
    self.firstTabLabel.text = @"校园排行";
    self.firstTabLabel.textColor = UIColorFromRGB(text_normal_color);
    self.firstTabLabel.font = [UIFont fontWithName:@"Helvetica" size:16*screenWidth/414.0];
    [self addSubview:self.firstTabLabel];
    //顶tab2标签
    self.secondTabLabel = [[UILabel alloc] init];
    self.secondTabLabel.text = @"班级排行";
    self.secondTabLabel.textColor = UIColorFromRGB(text_inactive_color);
    self.secondTabLabel.font = [UIFont fontWithName:@"Helvetica" size:16*screenWidth/414.0];
    [self addSubview:self.secondTabLabel];

}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    CGFloat rateX = ScreenWidth / 375.0;
    UIEdgeInsets padding0 = UIEdgeInsetsMake(34.5 *screenHeigth/667.0, 22.0 * screenWidth/375.0, 65.5 *screenHeigth/667.0, 344.5 * screenWidth/375.0);
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding0);
    }];
    UIEdgeInsets padding1 = UIEdgeInsetsMake(29.5, 161 * rateX, 63.5, 159.5 * rateX);
    [self.navigationBarTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding1);
    }];
    UIEdgeInsets padding2 = UIEdgeInsetsMake(64, 0, 0, ScreenWidth / 2);
    [self.firstTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding2);
    }];
    UIEdgeInsets padding3 = UIEdgeInsetsMake(64, ScreenWidth / 2, 0, 0);
    [self.secondTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding3);
    }];
    UIEdgeInsets padding4 = UIEdgeInsetsMake(81.5* screenHeigth/ 667, 74 *screenWidth/375, 14*screenHeigth/667, 200 *screenWidth/375);
    [self.firstTabLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding4);
    }];
    UIEdgeInsets padding5 = UIEdgeInsetsMake(81.5*screenHeigth/ 667, 241.5* screenWidth/375, 14*screenHeigth/ 667, 0*screenWidth/375);
    [self.secondTabLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding5);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(57.0/1334.0*screenHeigth, 31.0/750*screenWidth, 114.0/1334.0*screenHeigth, 663.0/750.0*screenWidth));
    }];
    
    
    [super updateConstraints];
}

+ (instancetype)titleView {
    MRRankTitleView *titleView = [[MRRankTitleView alloc] init];
    return titleView;
}

@end
