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
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 28, 28)];
    self.iconImage.backgroundColor = [UIColor clearColor];
    [self addSubview: self.iconImage];
}

- (void)initTextLabel{
    self.textLab = [[UILabel alloc] initWithFrame:CGRectMake(55, 18, 140, 25)];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"运动权限设置" attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC" size: 18],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:55/255.0 blue:57/255.0 alpha:1.0]}];
//    self.textLab.attributedText = string;
    self.textLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.textLab];
}

- (void)initArrowImage{
    self.arrowImage = [[UIImageView alloc] init];
//    self.arrowImage.image = [UIImage imageNamed:<#(nonnull NSString *)#>];
    self.arrowImage.backgroundColor = [UIColor clearColor];
    [self addSubview: self.arrowImage];
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.mas_right).mas_offset(-15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
    }];
}
@end
