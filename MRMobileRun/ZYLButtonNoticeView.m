
//
//  ZYLButtonNoticeView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/8/20.
//

#import "ZYLButtonNoticeView.h"

@implementation ZYLButtonNoticeView

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        [self initLabelWithText:text];
    }
    return self;
}

- (void) initLabelWithText:(NSString *)text{
    self.noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    self.noticeLab.backgroundColor = [UIColor clearColor];
    self.noticeLab.font = [UIFont systemFontOfSize: 20];
    self.noticeLab.numberOfLines = 2;
    self.noticeLab.textColor = [UIColor whiteColor];
    self.noticeLab.textAlignment = NSTextAlignmentCenter;
    self.noticeLab.text = text;
    [self addSubview: self.noticeLab];
}

+ (instancetype)viewInitWithText:(NSString *)text{
    return [[self alloc] initWithText:text];
}

@end
