//
//  ZYLSettingBackgound.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/11.
//

#import "ZYLSettingBackgound.h"
#import "ZYLSettingNomalCell.h"
#import "ZYLSettingIconCell.h"
#import "ZYLSettingNameCell.h"
#import "ZYLSettingDarkModeCell.h"
#import <Masonry.h>
@interface ZYLSettingBackgound ()
@end

@implementation ZYLSettingBackgound

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initCells];
        [self initLogoutButton];
    }
    return self;
}

- (void)initCells{
    self.iconCell = [[ZYLSettingIconCell alloc] init];
    self.iconCell.frame =  CGRectMake(0, 0, screenWidth, 70);
    [self addSubview: self.iconCell];
    
    self.nicknameCell = [[ZYLSettingNameCell alloc] init];
     self.nicknameCell.frame =  CGRectMake(0, 70, screenWidth, 70);
    [self addSubview: self.nicknameCell];
    
    self.signCell = [[ZYLSettingNomalCell alloc] init];
    self.signCell.frame =  CGRectMake(0, 140, screenWidth, 70);
    self.signCell.textLab.text = @"个性签名";
    self.signCell.iconImage.image = [UIImage imageNamed:@"setting_sign"];
    [self addSubview:self.signCell];
    
    self.aboutCell = [[ZYLSettingNomalCell alloc] init];
    self.aboutCell.frame = CGRectMake(0, 210, screenWidth, 70);
    self.aboutCell.textLab.text = @"关于跑酷";
    self.aboutCell.iconImage.image = [UIImage imageNamed:@"setting_about"];
    [self addSubview: self.aboutCell];
    
    self.permissionCell = [[ZYLSettingNomalCell alloc] init];
    self.permissionCell.frame = CGRectMake(0, 280, screenWidth, 70);
    self.permissionCell.textLab.text = @"运动权限设置";
    self.permissionCell.iconImage.image = [UIImage imageNamed: @"setting_authority"];
    [self addSubview: self.permissionCell];
    
    self.suggestionCell = [[ZYLSettingNomalCell alloc] init];
    self.suggestionCell.frame = CGRectMake(0, 350, screenWidth, 70);
    self.suggestionCell.textLab.text = @"意见反馈";
    self.suggestionCell.iconImage.image = [UIImage imageNamed:@"setting_suggestion"];
    [self addSubview: self.suggestionCell];
    
    self.switchCell = [[ZYLSettingDarkModeCell alloc] init];
    self.switchCell.frame = CGRectMake(0, 420, screenWidth, 70);
    [self addSubview: self.switchCell];
    
}

- (void)initLogoutButton{
    self.logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(16,540,screenWidth-32,52)];
    self.logoutBtn.backgroundColor = COLOR_WITH_HEX(0xFF5C77);
    self.logoutBtn.layer.cornerRadius = 15;
    [self.logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.logoutBtn.titleLabel.textColor = [UIColor whiteColor];
    self.logoutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
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
