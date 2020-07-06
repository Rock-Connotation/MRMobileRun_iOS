//
//  ZYLSettingNomalCell.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//

/*
    左边图片，文字，右边箭头普通的一个设置页面的cell
 */

#import "ZYLSettingNomalCell.h"
@implementation ZYLSettingNomalCell


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initIconImage];
        [self initTextLabel];
        [self initArrowImage];
    }
    return self;
}

- (void)initIconImage{
    self.iconImage = [[UIImageView alloc] init];
    self.iconImage.backgroundColor = [UIColor clearColor];
    [self addSubview: self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).mas_offset(15*kRateX);
        make.height.mas_equalTo(28*kRateX);
        make.width.mas_equalTo(28*kRateX);
    }];
}

- (void)initTextLabel{
    self.textLab = [[UILabel alloc] initWithFrame:CGRectMake(55, 18, 140, 25)];
    self.textLab.font = [UIFont fontWithName:@"PingFangSC" size:18];
    self.textLab.textColor = COLOR_WITH_HEX(0x333739);
    self.textLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.textLab];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.left.equalTo(self.iconImage.mas_right).mas_offset(6*kRateX);
        make.height.mas_equalTo(25*kRateY);
        make.width.mas_equalTo(140*kRateX);
    }];
}

- (void)initArrowImage{
    self.arrowImage = [[UIImageView alloc] init];
    self.arrowImage.image = [UIImage imageNamed:@"arraw"];
    self.arrowImage.backgroundColor = [UIColor clearColor];
    [self addSubview: self.arrowImage];
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).mas_offset(-15*kRateX);
        make.height.mas_equalTo(15*kRateX);
        make.width.mas_equalTo(15*kRateX);
    }];
}
@end
