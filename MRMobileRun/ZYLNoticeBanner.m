
//
//  ZYLNoticeBanner.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/8/20.
//

#import "ZYLNoticeBanner.h"

@implementation ZYLNoticeBanner

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initNoticeLabel];
    }
    return self;
}

- (void)initNoticeLabel{
    self.noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    self.noticeLab.backgroundColor = [UIColor clearColor];
    self.noticeLab.font = [UIFont systemFontOfSize: 15];
    self.noticeLab.numberOfLines = 1;
    self.noticeLab.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    self.noticeLab.textAlignment = NSTextAlignmentCenter;
    self.noticeLab.text = @"网络不给力，请检查网络连接";
    [self addSubview: self.noticeLab];
}

@end
