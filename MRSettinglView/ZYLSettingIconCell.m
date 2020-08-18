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
        self.iconButton = [[UIButton alloc] initWithFrame: CGRectMake(screenWidth-57*kRateX, 10*kRateY, 42*kRateX, 42*kRateY)];
        self.iconButton.clipsToBounds=YES;
        self.iconButton.layer.cornerRadius=21*kRateX;
        self.iconButton.layer.shadowColor = [UIColor blackColor].CGColor;
        self.iconButton.layer.shadowOffset = CGSizeMake(5*kRateX, 5*kRateX);
        self.iconButton.layer.shadowOpacity = 0.8f;
        self.iconButton.layer.shadowRadius = 5.f;
//        self.iconButton.backgroundColor = COLOR_WITH_HEX(0x64686F);
        [self addSubview: self.iconButton];
        [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).mas_offset(-15*kRateX);
            make.height.mas_equalTo(42*kRateX);
            make.width.mas_equalTo(42*kRateX);
        }];
    }
    return self;
}


@end
