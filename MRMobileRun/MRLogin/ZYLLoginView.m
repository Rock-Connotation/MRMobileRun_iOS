//
//  ZYLLoginView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/13.
//

#import "ZYLLoginView.h"
#import <Masonry.h>

@interface ZYLLoginView ()
@property (nonatomic, strong) UIImageView *usernameIcon;
@property (nonatomic, strong) UIImageView *passwordIcon;
@property (nonatomic, strong) UILabel *noticeLab;
@end

@implementation ZYLLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initWelcomeLabel];
        [self initImageViews];
        [self initTextFileds];
        [self initNoticeLabel];
        [self initLoginButton];
    }
    return self;
}

- (void)initWelcomeLabel{
    self.welcomeLab  = [[ZYLWelcomeLabel alloc] init];
    self.welcomeLab.text = @"欢迎您加入 重邮约跑";
    [self addSubview: self.welcomeLab];
    [self.welcomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(88*kRateY);
        make.left.mas_equalTo(28);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(70);
    }];
}

- (void)initImageViews{
    self.usernameIcon = [[UIImageView alloc] init];
    self.usernameIcon.image = [UIImage imageNamed:@"login_username"];
    [self addSubview: self.usernameIcon];
    [self.usernameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.welcomeLab.mas_bottom).mas_offset(28);
        make.left.mas_equalTo(28);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    self.passwordIcon = [[UIImageView alloc] init];
    self.passwordIcon.image = [UIImage imageNamed:@"login_password"];
    [self addSubview: self.passwordIcon];
    [self.passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameIcon.mas_bottom).mas_offset(28);
        make.left.mas_equalTo(28);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
}

- (void)initTextFileds{
    self.usernameField = [[ZYLLoginField alloc] init];
    self.usernameField.placeholder = @"请输入您的学号";
    [self addSubview: self.usernameField];
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameIcon.mas_top);
        make.left.equalTo(self.usernameIcon.mas_right).mas_offset(14);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(28);
    }];
    
    self.passwordField = [[ZYLLoginField alloc] init];
    self.passwordField.placeholder = @"请输入身份证后六位";
    self.passwordField.secureTextEntry = YES;
    [self addSubview: self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordIcon.mas_top);
        make.left.equalTo(self.passwordIcon.mas_right).mas_offset(14);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(28);
    }];
}

- (void)initNoticeLabel{
    self.noticeLab = [[UILabel alloc] init];
    self.noticeLab.numberOfLines = 1;
    self.noticeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.noticeLab.textColor = COLOR_WITH_HEX(0xB9BCBE);
    self.noticeLab.text = @"身份证号中X为大写";
    self.noticeLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview: self.noticeLab];
    [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordIcon.mas_bottom).mas_offset(12);
        make.left.equalTo(self.passwordIcon.mas_right).mas_offset(24);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(14);
    }];
}

- (void)initLoginButton{
    self.loginBtn = [[ZYLLoginButton alloc] init];
    [self.loginBtn setTitle:@"登陆" forState: UIControlStateNormal];
    [self addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.noticeLab.mas_bottom).mas_offset(81);
        make.left.mas_equalTo(14);
        make.width.equalTo(self.mas_width).mas_offset(-28);
        make.height.mas_equalTo(52);
    }];
}
@end
