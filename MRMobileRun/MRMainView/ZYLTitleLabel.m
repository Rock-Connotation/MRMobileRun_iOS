//
//  ZYLTitleLabel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLTitleLabel.h"

@implementation ZYLTitleLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseLabel = [[UILabel alloc]init];
        self.baseLabel.font = [UIFont boldSystemFontOfSize:10*screenWidth/1080.0];
        self.baseLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
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
