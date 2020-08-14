//
//  ZYLSettingBackgound.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//

#import "ZYLSettingBackgound.h"
#import <Masonry.h>
@interface ZYLSettingBackgound ()
@end

@implementation ZYLSettingBackgound

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initCells];
        [self initLogoutButton];
//        [self initTextField];
    }
    return self;
}
//- (void)initTextField{
//    //输入昵称的文本框
//    
//    self.nicknameTextFiled = [[ZYLNicknameTextField alloc]init];
//    [self addSubview:self.nicknameTextFiled];
//    [self.nicknameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(305.0/1334.0*screenHeigth, 101.0/750*screenWidth, 886.0/1334.0*screenHeigth, 43.0/750.0*screenWidth));
//    }];
//}

- (void)initCells{
    self.iconCell = [[ZYLSettingIconCell alloc] init];
    self.iconCell.frame =  CGRectMake(0, 0, screenWidth, 70*kRateY);
    [self addSubview: self.iconCell];
    
    self.nicknameCell = [[ZYLSettingNameCell alloc] init];
     self.nicknameCell.frame =  CGRectMake(0, 70*kRateY, screenWidth, 70*kRateY);
    self.nicknameCell.userInteractionEnabled = YES;
    [self addSubview: self.nicknameCell];
    
    self.signCell = [[ZYLSettingNomalCell alloc] init];
    self.signCell.frame =  CGRectMake(0, 140*kRateY, screenWidth, 70*kRateY);
    self.signCell.textLab.text = @"个性签名";
    self.signCell.iconImage.image = [UIImage imageNamed:@"setting_sign"];
    [self addSubview:self.signCell];
    
    self.aboutCell = [[ZYLSettingNomalCell alloc] init];
    self.aboutCell.frame = CGRectMake(0, 210*kRateY, screenWidth, 70*kRateY);
    self.aboutCell.textLab.text = @"关于约跑";
    self.aboutCell.iconImage.image = [UIImage imageNamed:@"setting_about"];
    [self addSubview: self.aboutCell];
    
    self.permissionCell = [[ZYLSettingNomalCell alloc] init];
    self.permissionCell.frame = CGRectMake(0, 280*kRateY, screenWidth, 70*kRateY);
    self.permissionCell.textLab.text = @"运动权限设置";
    self.permissionCell.iconImage.image = [UIImage imageNamed: @"setting_authority"];
    [self addSubview: self.permissionCell];
    
    self.suggestionCell = [[ZYLSettingNomalCell alloc] init];
    self.suggestionCell.frame = CGRectMake(0, 350*kRateY, screenWidth, 70*kRateY);
    self.suggestionCell.textLab.text = @"意见反馈";
    self.suggestionCell.iconImage.image = [UIImage imageNamed:@"setting_suggestion"];
    [self addSubview: self.suggestionCell];
    
    self.switchCell = [[ZYLSettingDarkModeCell alloc] init];
    self.switchCell.frame = CGRectMake(0, 420*kRateY, screenWidth, 70*kRateY);
    [self addSubview: self.switchCell];
    
}

- (void)initLogoutButton{
    self.logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(16*kRateX,540*kRateY,screenWidth-32*kRateX,52*kRateY)];
    self.logoutBtn.backgroundColor = COLOR_WITH_HEX(0xFF5C77);
    self.logoutBtn.layer.cornerRadius = 15*kRateX;
    [self.logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.logoutBtn.titleLabel.textColor = [UIColor whiteColor];
    self.logoutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16*kRateX];
    [self addSubview: self.logoutBtn];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
