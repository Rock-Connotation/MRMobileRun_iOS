
//
//  MRNumLabel.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRNumLabel.h"
//这个是所有黑色显示统计数字的label的父类(不包含显示时长的)

@interface  MRNumLabel ()



@end


@implementation MRNumLabel

- (instancetype)init{
    if (self = [super init]) {
        [self initLabel];
        return self;
    }
    return self;
}

- (void)initLabel{
    
}



- (void)setFontWithSize:(float)size andFloatTitle:(double)title{
//这个是涉及到浮点数的时候使用
    self.font = [UIFont fontWithName:@"DINAlternate-Bold" size:size];
    self.textColor = [UIColor blackColor];
    
    if (title < 10) {
        self.text = [NSString stringWithFormat:@"%.3lf",title];
        
    }
    
    if (title < 100 && title>= 10) {
        self.text = [NSString stringWithFormat:@"%.2lf",title];
        
    }
    
    if (title < 1000 && title>= 100) {
        self.text = [NSString stringWithFormat:@"%.1lf",title];
        
    }
    
    if (title  >= 1000) {
        self.text = [NSString stringWithFormat:@"%d",(int)title];
        
    }
    self.adjustsFontSizeToFitWidth = YES;


}


- (void)setFontWithSize:(float)size andIntTitle:(int)title{
//这个是涉及到整数的时候使用
    self.font = [UIFont fontWithName:@"DINAlternate-Bold" size:size];
    self.textColor = [UIColor blackColor];
    self.text = [NSString stringWithFormat:@"%d",title];
    self.adjustsFontSizeToFitWidth = YES;
}
@end
