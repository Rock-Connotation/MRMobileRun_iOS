//
//  MRDataBaseView.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/12.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRMapView.h"
@interface MRDataBaseView : UIView

- (instancetype)init;


@property(nonatomic,strong) UIImageView *timeIconImageView;
//用时icon2
@property(nonatomic,strong) UILabel *timeCostLabel;
//用时文字
@property(nonatomic,strong) UILabel *timeLabel;
//数字显示的时间
@property(nonatomic,strong) UILabel *distanceLabel;
//距离
@property(nonatomic,strong) UILabel *kmLabel;
//km
@property(nonatomic,strong) UILabel *dateOne;
//年月日
@property(nonatomic,strong) UILabel *dateTwo;
//时分秒
@property(nonatomic,strong) UIImageView *dataBaseImageView;
//数据底板
@property(nonatomic,strong) UIImageView *line;
//分割线

@end
