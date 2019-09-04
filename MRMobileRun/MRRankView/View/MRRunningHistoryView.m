
//
//  MRRunningHistoryView.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/8.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRRunningHistoryView.h"
#import "MASonry.h"
#import "MRBackBtu.h"
//这个是我的足迹除了tableview以外的视图部分
@interface MRRunningHistoryView()

@property (nonatomic,strong) UIImageView *navBackgroundImageView;
//导航栏底部图片
@property (nonatomic,strong) UILabel *titleLabel;
//该页面标题
@end

@implementation MRRunningHistoryView

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
        return self;
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    [self initNavBackgroundImageView];
    [self initBackBtu];
    [self initTitleLabel];

    
    
    

    
}
- (void)initNavBackgroundImageView{
    self.navBackgroundImageView = [[UIImageView alloc]init];
    self.navBackgroundImageView.image = [UIImage imageNamed:@"数据底板"];
    [self addSubview:self.navBackgroundImageView];
    [self.navBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(0/1334.0*screenHeigth, 0/750.0*screenWidth, 1206/1334.0*screenHeigth, 0/750.0*screenWidth));
    }];

}

- (void)initBackBtu{
    
    self.backBtu = [[UIButton alloc]init];
    [self addSubview:self.backBtu];
    [self.backBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(57.0/1334.0*screenHeigth, 31.0/750*screenWidth, 1212.0/1334.0*screenHeigth, 663.0/750.0*screenWidth));
    }];
    
    UIImageView * backLabel = [[UIImageView alloc]init];
    
    backLabel.image = [UIImage imageNamed:@"返回箭头2"];
    
    [self addSubview:backLabel];
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(69.0/1334.0*screenHeigth, 44.0/750*screenWidth, 1229.0/1334.0*screenHeigth, 689.0/750.0*screenWidth));
    }];
    

}


- (void)initTitleLabel{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"我的足迹";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19 *screenWidth/414];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self.navBackgroundImageView).with.insets(UIEdgeInsetsMake(59/1334.0*screenHeigth, 304/750.0*screenWidth, 19/1334.0*screenHeigth, 305/750.0*screenWidth));
    }];
}
@end
