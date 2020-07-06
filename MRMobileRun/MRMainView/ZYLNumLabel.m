//
//  ZYLNumLabel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import "ZYLNumLabel.h"

@implementation ZYLNumLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = COLOR_WITH_HEX(0x333739);
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 24*kRateX];
        self.textAlignment = NSTextAlignmentLeft;
//        self.text = @"1";
    }
    return self;
}

@end
