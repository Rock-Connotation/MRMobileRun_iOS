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
        
        self.nickNameLab = [[UILabel alloc] init];
        self.nickNameLab.numberOfLines = 0;
        [self addSubview:self.nickNameLab];

//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"小阿giao"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
//
//        self.nickNameLab.attributedText = string;
        self.nickNameLab.textAlignment = NSTextAlignmentRight;
        self.nickNameLab.alpha = 1.0;
        
        [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.right.equalTo(self.mas_right).mas_offset(-35);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(127);
        }];
    }
    return self;
}


@end
