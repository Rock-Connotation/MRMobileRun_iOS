//
//  MRHomePageTabBar.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/11/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRStartRunningBtu.h"

@interface MRHomePageTabBar :UIView
@property (nonatomic) UIButton* homePageJumpBtu;
@property (nonatomic) UIButton* rankJumpBtu;
@property (nonatomic) UIButton* inviteJumpBtu;
@property (nonatomic) UIButton* personalJumpBtu;
@property (nonatomic) UILabel* homePageJumpTitle;
@property (nonatomic) UILabel* rankJumpTitle;
@property (nonatomic) UILabel* inviteJumpTitle;
@property (nonatomic) UILabel* personalJumpTitle;
@property (nonatomic) MRStartRunningBtu* beginRunningBtu;
-(instancetype)initWithFrame:(CGRect)frame;

@end
