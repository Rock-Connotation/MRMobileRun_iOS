//
//  MRBackBtu.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRBackBtu.h"

@implementation MRBackBtu
//所有的返回箭头的父类
- (instancetype)init{
    if (self = [super init]) {
        [self initBtu];
        return self;
    }
    return self;
}


- (void)initBtu{
    
    
    [self setBackgroundImage:[UIImage imageNamed:@"返回箭头4"] forState:UIControlStateNormal];
    
}





@end
