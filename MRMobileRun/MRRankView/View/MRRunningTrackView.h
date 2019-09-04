//
//  MRRunningTrackView.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/12.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRDataBaseView.h"
#import "MRMapView.h"
@interface MRRunningTrackView : UIView
- (instancetype)init;


@property(nonatomic,strong) UILabel *titleLabel;
//标题
@property(nonatomic,strong) UIButton *backBtu;
//返回按钮
@property (nonatomic,strong) MRDataBaseView *dataBaseView;
//数据底板和上面的ui数据
@property (nonatomic,strong) UIImageView *navImageView;
//导航栏底部视图
@property (nonatomic,strong) MRMapView *mapView;
//地图
@property (nonatomic,strong) NSMutableDictionary *runningDateDic;
//数据

@end
