//
//  ZYLPersonalInformationView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/12.
//

#import "ZYLPersonalInformationView.h"
#import "ZYLPersonalBackGroud.h"
#import <Masonry.h>

@interface ZYLPersonalInformationView ()
@property (nonatomic,strong) ZYLPersonalBackGroud *backgroundView;
@property (strong, nonatomic) NSUserDefaults *defaults;
@end
@implementation ZYLPersonalInformationView
- (instancetype)init{
    if (self = [super init]) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        [self initUI];
        return self;
    }
    return  self;
}


- (void)initUI{
    [self initBackground];
    
    [self initTextField];
    [self initlogoutBtu];
    [self initAvatarBtu];
    [self initBackBtu];
}


- (void)initBackground{
    //所有与交互无关的UI部分
    self.backgroundView = [[ZYLPersonalBackGroud alloc]init];
    [self addSubview:self.backgroundView];
}


- (void)initTextField{
    //输入昵称的文本框
    
    self.nickameTextField = [[ZYLNicknameTextField alloc]init];
    [self addSubview:self.nickameTextField];
    [self.nickameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(305.0/1334.0*screenHeigth, 101.0/750*screenWidth, 886.0/1334.0*screenHeigth, 43.0/750.0*screenWidth));
    }];
}


- (void)initlogoutBtu{
    //退出登录按钮
    
    self.logoutBtu = [[ZYLLogoutBtn alloc]init];
    [self addSubview:self.logoutBtu];
    [self.logoutBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(826.0/1334.0*screenHeigth, 41.0/750*screenWidth, 401.0/1334.0*screenHeigth, 43.0/750.0*screenWidth));
    }];
}

- (void)initAvatarBtu{
    //设置头像按钮
    self.avatarBtu = [[ZYLSetAvatarBtn alloc]init];
    NSData *data = [self.defaults objectForKey:@"myAvatar"];
    [self.avatarBtu setImage: [UIImage imageWithData:data scale:1] forState: UIControlStateNormal];
    [self addSubview:self.avatarBtu];
    if (kIs_iPhoneX) {
        [self.avatarBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(155.0/1334.0*screenHeigth);
            make.left.mas_equalTo(584.0/750*screenWidth);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
    }else{
        [self.avatarBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(155.0/1334.0*screenHeigth, 584.0/750*screenWidth, 1056.0/1334.0*screenHeigth, 43.0/750.0*screenWidth));
        }];
    }
}

- (void)initBackBtu
{
    //返回按钮
    self.backBtu = [[UIButton alloc]init];
    [self addSubview:self.backBtu];
    [self.backBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(57.0/1334.0*screenHeigth, 31.0/750*screenWidth, 1212.0/1334.0*screenHeigth, 663.0/750.0*screenWidth));
//        make.top.equalTo(self.mas_top).mas_offset(20);
//        make.left.equalTo(self.mas_left).mas_offset(20);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(10);
    }];
    
    UIImageView * backLabel = [[UIImageView alloc]init];
    
    backLabel.image = [UIImage imageNamed:@"返回箭头4"];
    
    [self addSubview:backLabel];
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.titleLabel.mas_top).mas_offset(5);
        make.left.equalTo(self.mas_left).mas_offset(15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(10);
    }];
    [self bringSubviewToFront:self.backBtu];
    
}


@end
