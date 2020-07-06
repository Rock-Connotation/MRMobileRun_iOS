//
//  MRLoginBtu.h
//  MobileRun
//
//  Created by 郑沛越 on 2016/12/3.
//  Copyright © 2016年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRLoginBtu : UIButton
-(instancetype)initBtuWithFrame:(CGRect )frame;

@property(nonatomic,strong) UIButton *loginBtu;
//登录按钮
@property(nonatomic,strong) UIImageView *btuBackgroundImage;
//登录按钮背景
@end
