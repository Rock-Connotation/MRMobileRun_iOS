//
//  ZYLGrayNoticeLabel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import "ZYLGrayNoticeLabel.h"

@implementation ZYLGrayNoticeLabel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = COLOR_WITH_HEX(0xE1E4E5);
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14*kRateX];
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}
@end
