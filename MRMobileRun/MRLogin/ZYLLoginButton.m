//
//  ZYLLoginButton.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/13.
//

#import "ZYLLoginButton.h"

@implementation ZYLLoginButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_WITH_HEX(0x55D5E2);
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 15;
        self.layer.shadowColor = [UIColor colorWithRed:85/255.0 green:213/255.0 blue:226/255.0 alpha:0.1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 6;
        
        self.titleLabel.textColor = [UIColor whiteColor];
//        self.titleLabel.text = @"登陆";
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    }
    return self;
}
@end
