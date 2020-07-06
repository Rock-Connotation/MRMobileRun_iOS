


//
//  MRStopBtu.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/9.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRStopBtu.h"
#import <Masonry.h>

@implementation MRStopBtu

- (instancetype)init{
    if (self =[super init]) {
        [self initStopBtu];
        return self;
    }
    return self;
    
}

- (void)initStopBtu{
    self.frame = CGRectMake(0, 0, 183, 183);
    [self setBackgroundImage:[UIImage imageNamed:@"结束按钮"] forState:UIControlStateNormal];
//    [self addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self setTitle:@"结束" forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18*screenWidth/414.0];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
}
@end
