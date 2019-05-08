
//
//  MRLoginBtu.m
//  MobileRun
//
//  Created by 郑沛越 on 2016/12/3.
//  Copyright © 2016年 郑沛越. All rights reserved.
//

#import "MRLoginBtu.h"
@interface MRLoginBtu()



@end
@implementation MRLoginBtu

-(instancetype)initBtuWithFrame:(CGRect )frame
{
    self = [super  init];

    if (self) {
        [self initButtonWithFrame:frame];
    }
    return self;
}

- (void)initButtonWithFrame:(CGRect )frame{

    self.loginBtu = [[UIButton alloc] initWithFrame:CGRectMake( screenWidth *68/750 , screenHeigth *922 /1334, screenWidth *602/750, screenHeigth *112 /1334)];
    // 设置登录按钮位置
    
    [self.loginBtu setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtu.titleLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    self.loginBtu.contentHorizontalAlignment= UIControlContentHorizontalAlignmentCenter;
    self.loginBtu.contentEdgeInsets = UIEdgeInsetsMake(screenHeigth *32 /1334,screenWidth *265/750, screenHeigth *34 /1334, screenWidth *245/750);
    //设置按钮标题和字体大小
    
    [self.loginBtu setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    //设置按钮背景图片
    
    [self.loginBtu addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
 
    
}
- (void)click
{
    
}

@end
