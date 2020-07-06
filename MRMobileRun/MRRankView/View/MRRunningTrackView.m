

//
//  MRRunningTrackView.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/12.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRRunningTrackView.h"
#import "MAsonry.h"
@implementation MRRunningTrackView


- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
        [self initMapView];

        return self;
    }
    return self;
}

- (void)initUI{
    self.dataBaseView = [[MRDataBaseView alloc]init];
    [self addSubview:self.dataBaseView];
    [self.dataBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1040.0/1334.0*screenHeigth, 0/750.0*screenWidth, 0/1334.0*screenHeigth, 0/750.0*screenWidth));
        
    }];
    
    self.navImageView =[[UIImageView alloc]init];
    self.navImageView.image = [UIImage imageNamed:@"数据底板"];
    [self addSubview:self.navImageView];
    [self.navImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(0/1334.0*screenHeigth, 0/750.0*screenWidth, 1206.0/1334.0*screenHeigth, 0/750.0*screenWidth));
        
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"我的足迹";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18 *screenWidth/414];
    [self  addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self.navImageView).with.insets(UIEdgeInsetsMake(59.0/1334.0*screenHeigth, 304.0/750.0*screenWidth, 19.0/1334.0*screenHeigth, 305.0/750.0*screenWidth));
        
    }];
    
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


- (void)initMapView{
    self.mapView = [[MRMapView alloc]init];
    [self addSubview:self.mapView.mapView];
    [self.mapView.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(128.0/1334.0*screenHeigth, 0/750.0*screenWidth, 294.0/1334.0*screenHeigth, 0/750.0*screenWidth));
    }];
}
@end
