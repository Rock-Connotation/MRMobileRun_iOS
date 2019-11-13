//
//  ZYLSettingDarkModeCell.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//

#import "ZYLSettingDarkModeCell.h"

@implementation ZYLSettingDarkModeCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textLab.text = @"黑夜模式";
        self.iconImage.image = [UIImage imageNamed:@"setting_darkMode"];
        self.arrowImage.hidden = YES;
        self.mySwitch = [[UISwitch alloc] initWithFrame: CGRectMake(screenWidth-70, 17, 52, 30)];
        [self addSubview: self.mySwitch];
//        [self.mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.mas_centerX);
//            make.right.equalTo(self.mas_right).mas_offset(-15);
//            make.width.mas_equalTo(52);
//            make.height.mas_equalTo(30);
//        }];
    }
    return self;
}

@end
