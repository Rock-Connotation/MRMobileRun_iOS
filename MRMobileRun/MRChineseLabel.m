
//
//  MRLabel.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/12.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRChineseLabel.h"

@interface MRChineseLabel()

@end

@implementation MRChineseLabel

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
    self.font = [UIFont systemFontOfSize:size];

    self.text = title;
    
}

@end
