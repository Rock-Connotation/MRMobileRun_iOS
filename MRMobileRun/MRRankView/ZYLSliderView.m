//
//  ZYLSliderView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/29.
//

#import "ZYLSliderView.h"

@implementation ZYLSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:85/255.0 green:213/255.0 blue:226/255.0 alpha:1.0];
        self.layer.cornerRadius = self.bounds.size.height/2;
    }
    return self;
}

@end
