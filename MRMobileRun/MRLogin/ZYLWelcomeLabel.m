//
//  ZYLWelcomeLabel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/13.
//

#import "ZYLWelcomeLabel.h"

@implementation ZYLWelcomeLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
        self.numberOfLines = 2;
        self.textColor = COLOR_WITH_HEX(0x333739);
    }
    return self;
}

@end
