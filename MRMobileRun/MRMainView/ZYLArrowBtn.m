//
//  ZYLArrowBtn.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLArrowBtn.h"

@implementation ZYLArrowBtn

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setImage:[UIImage imageNamed:@">查看更多箭头"] forState:UIControlStateNormal];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
