//
//  MRTimeLabel.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRTimeLabel.h"
//这个是所有显示统计时间的label的父类

@interface MRTimeLabel()


@end


@implementation MRTimeLabel

- (instancetype)init{
    if (self = [super init]) {
        [self initLabel];
        return self;
    }
    return self;
}

- (void)initLabel{
    
}



- (void)setFontWithSize:(float)size andTitle:(NSString *)title{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间

    
}




 
@end
