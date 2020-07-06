//
//  ZYLUnitLabel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import "ZYLUnitLabel.h"

@implementation ZYLUnitLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = COLOR_WITH_HEX(0xA0A0A0);
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14*kRateX];
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

@end
