//
//  MRStartRunningBtu.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/4.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRStartRunningBtu.h"
//开始跑步按钮
@interface  MRStartRunningBtu()

@end

@implementation MRStartRunningBtu

- (instancetype)init{
    if (self = [super init]) {
        [self drawUI];
        return self;
    }
    return self;
}

- (void)drawUI{
    self.beginRunningBtu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.beginRunningBtuImageView.layer.masksToBounds = YES;
    self.beginRunningBtuImageView.layer.cornerRadius = 50.0;
  
    
    
    
    self.beginRunningBtuImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.beginRunningBtuImageView.image = [UIImage imageNamed:@"开始跑步icon（未按）"];
    [self.beginRunningBtu addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    self.beginRunningBtu.selected = NO;
    // 设置登录按钮位置
    
//    [self.beginRunningBtu setTitle:@"开始\n跑步" forState:UIControlStateNormal];
//
//    
//    self.beginRunningBtu.titleLabel.font = [UIFont boldSystemFontOfSize:18*screenWidth/414.0];
//    [self.beginRunningBtu setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    
//    self.beginRunningBtu.contentHorizontalAlignment= UIControlContentHorizontalAlignmentCenter;
//    self.beginRunningBtu.contentEdgeInsets = UIEdgeInsetsMake(screenHeigth *19 /1334,screenWidth *53/750, screenHeigth *34 /1334, screenWidth *46/750);
    //设置按钮标题和字体大小
    
     self.beginRunningBtu.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.beginRunningBtu setBackgroundImage:[UIImage imageNamed:@"开始跑步"] forState:UIControlStateNormal];
    //220 142 141
}



- (void)click{
}
@end
