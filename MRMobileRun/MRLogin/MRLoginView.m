


//
//  MRLoginView.m
//  MobileRun
//
//  Created by 郑沛越 on 2016/11/30.
//  Copyright © 2016年 郑沛越. All rights reserved.
//

#import "MRLoginView.h"
//登录界面

@interface MRLoginView ()
@property(nonatomic,strong) UIImageView *avatarImageView;
//约跑标题
@property(nonatomic,strong) UIImageView *logoFaviconImageView;
//logo图标
@property(nonatomic,strong) UIImageView *backgroundImageView;
//背景图片


@property(nonatomic,strong) UIImageView *titileImageView;
//标题图片
@property(nonatomic,strong) UIImageView *titileTextImageView;
//标题文字
@property(nonatomic,strong) UIImageView* point;
//背景上的三个小圆圈

@end
@implementation MRLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    [self initLogo];
    [self initBackground];
    [self initTextField];
    [self initBtu];
    [self iniTitle];
    
    

}


- (void)initLogo{
    self.avatarImageView = [[UIImageView alloc]init];
//    self.avatarImageView.frame = CGRectMake
}

-(void)initBackground{
    self.backgroundImageView = [[UIImageView alloc]init];
    self.backgroundImageView.frame =CGRectMake
    (0, 0, screenWidth, screenHeigth);
    self.backgroundImageView.image = [UIImage imageNamed:@"背景"];
    [self addSubview:self.backgroundImageView];
    //设置界面背景
    
    self.point = [[UIImageView alloc]init];
    self.point.frame = CGRectMake
    (screenWidth *190/750, screenHeigth *165/1334, screenWidth *350/750, screenHeigth *90/1334);
    self.point.image = [UIImage imageNamed:@"Group 4"];
    [self addSubview:self.point];

    
    
}

- (void)initTextField{
    
    self.idTextfieldView = [[MRLoginTextField alloc]initTextFieldWithFrame:CGRectMake(70 ,572 , 604, 102)];
    //设置账号文本框视图位置
    
    self.idTextfieldView.textImage.image = [UIImage imageNamed:@"学号输入框"];
    //设置账号文本框图片
    
    self.idTextfieldView.iconImage.image = [UIImage imageNamed:@"个人"];
    //设置账号文本框icon
    
    self.idTextfieldView.textField.placeholder = @"请输入您的学号";
    //设置学号输入框提示文字
    
    self.idTextfield = self.idTextfieldView.textField;
    
    self.idTextfield.delegate = self;
    [self addSubview:self.idTextfield];
    [self addSubview:self.idTextfieldView];
    
    self.passWordTextFieldView = [[MRLoginTextField alloc]initTextFieldWithFrame:CGRectMake(70 ,717 , 604, 102)];
    //设置密码文本框视图位置
    
    self.passWordTextFieldView.textImage.image = [UIImage imageNamed:@"密码输入框"];
    //设置密码文本框图片
    self.passWordTextFieldView.textField.secureTextEntry = YES;
    

    self.passWordTextFieldView.iconImage.image = [UIImage imageNamed:@"密码"];
    //设置密码文本框icon
    
    self.passWordTextFieldView.textField.placeholder = @"请输身份证后六位";
    //设置密码文本框提示文字
    
    self.passWordTextFieldView.textField.returnKeyType = UIReturnKeyDone;
    //更改密码框输入时键盘return键为完成
    
    self.passWordTextfield = self.passWordTextFieldView.textField;
    
    [self bringSubviewToFront:self.passWordTextfield];
    //将文本框置顶显示
    
    self.passWordTextfield.delegate = self;
    //设置密码文本框为代理
    
    [self addSubview:self.passWordTextFieldView];

    [self addSubview:self.passWordTextfield];
    

}

- (void)initBtu{
    self.loginBtu = [[MRLoginBtu alloc]initBtuWithFrame:CGRectMake
                     (70, 912, 604, 102)];
    [self addSubview:self.loginBtu.btuBackgroundImage];
    [self addSubview:self.loginBtu.loginBtu];
    [self bringSubviewToFront:self.loginBtu.loginBtu];

    

}

- (void)iniTitle{
//    self.titileImageView = [[UIImageView alloc]initWithFrame:CGRectMake
//                            (screenWidth *264/750, screenHeigth *208/1334, screenWidth *227/750, screenHeigth *226/1334)];
    self.titileImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                            (screenWidth * 1.0/3, screenHeigth *208/1334, screenWidth *1.0/3, screenWidth *1.0/3)];
    self.titileImageView.image = [UIImage imageNamed:@"logo头像"];
    [self addSubview:self.titileImageView];
    
    //设置约跑logo图标
    
    
    self.titileTextImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                            (screenWidth *3.0/7, screenHeigth *450/1334, screenWidth *1.0/7, screenHeigth *50/1334)];
    self.titileTextImageView.image = [UIImage imageNamed:@"约跑logo"];
    [self addSubview:    self.titileTextImageView];
    
    //设置约跑logo标题
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}



@end
