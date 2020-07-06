//
//  ZYLSettingNameCell.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//



#import "ZYLSettingNameCell.h"

@implementation ZYLSettingNameCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textLab.text = @"昵称";
        self.iconImage.image = [UIImage imageNamed:@"setting_nickname"];
        
        self.nicknameTextFiled = [[ZYLNicknameTextField alloc] init];
        self.nicknameTextFiled.frame = CGRectMake(screenWidth-171*kRateX, 17*kRateY, 127*kRateX, 20*kRateX);
        self.nicknameTextFiled.font = [UIFont fontWithName:@"PingFangSC" size:14*kRateX];
        self.nicknameTextFiled.textColor = COLOR_WITH_HEX(0x999999);
        self.nicknameTextFiled.textAlignment = NSTextAlignmentRight;
        self.nicknameTextFiled.alpha = 1.0;
        self.nicknameTextFiled.text = @"giao";
        [self addSubview:self.nicknameTextFiled];
        [self.nicknameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).mas_offset(-35*kRateX);
            make.height.mas_equalTo(20*kRateY);
            make.width.mas_equalTo(127*kRateX);
        }];
    }
    return self;
}


@end
