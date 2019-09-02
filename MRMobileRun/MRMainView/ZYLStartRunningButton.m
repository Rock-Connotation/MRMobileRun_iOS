//
//  ZYLStartRunningButton.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/8/20.
//

#import "ZYLStartRunningButton.h"

@implementation ZYLStartRunningButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setImage: [UIImage imageNamed: @"开始跑步icon（未按）"] forState: UIControlStateNormal];
        [self setImage: [UIImage imageNamed: @"开始跑步icon（按）2"] forState: UIControlStateHighlighted];
    }
    return self;
}

@end
