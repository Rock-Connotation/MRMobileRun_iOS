//
//  ZYLPlateChinieseLabel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import "ZYLPlateChinieseLabel.h"

@implementation ZYLPlateChinieseLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = COLOR_WITH_HEX(0x333739);
        self.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18*kRateX];
        self.textAlignment = NSTextAlignmentLeft;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
