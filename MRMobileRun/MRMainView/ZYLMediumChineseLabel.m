//
//  ZYLMediumChineseLabel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import "ZYLMediumChineseLabel.h"

@implementation ZYLMediumChineseLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = COLOR_WITH_HEX(0x64686F);
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 12*kRateX];
        self.textAlignment = NSTextAlignmentLeft;

    }
    return self;
}

@end
