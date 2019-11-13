//
//  ZYLSettingIconCell.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//


#import "ZYLSettingIconCell.h"

@implementation ZYLSettingIconCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textLab.text = @"头像";
        self.iconImage.image = [UIImage imageNamed:@"setting_icon"];
        self.arrowImage.hidden = YES;
        self.iconButton = [[UIButton alloc] init];
        self.iconButton.clipsToBounds=YES;
        self.iconButton.layer.cornerRadius=14;
        [self addSubview: self.iconButton];
        [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.right.equalTo(self.mas_right).mas_offset(-15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
    }
    return self;
}


@end
