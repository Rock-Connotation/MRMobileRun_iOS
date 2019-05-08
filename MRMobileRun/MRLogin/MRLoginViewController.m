

//
//  MRLoginViewController.m
//  MobileRun
//
//  Created by 郑沛越 on 2016/11/30.
//  Copyright © 2016年 郑沛越. All rights reserved.
//

#import "MRLoginViewController.h"
#import "MRLoginView.h"
#import "ZYLMainViewController.h"
#import "MRLoginModel.h"
#import "MBProgressHUD.h"
@interface MRLoginViewController ()
//@property (nonatomic,strong) ZYLMainView *homePageVC;
//登陆后跳转的主界面
@property (nonatomic,strong) MRLoginView *loginView;
//登录界面的view
@property (nonatomic,strong) MRLoginModel *loginModel;

@property (nonatomic,strong) MBProgressHUD *loginProgress;

@end

@implementation MRLoginViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [self.loginView.loginBtu.loginBtu setEnabled:YES];
    self.loginView.idTextfield.text = @"";
    self.loginView.passWordTextfield.text = @"";

    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self Notification];
    //广播
    
    self.loginView = [[MRLoginView alloc]init];
    
    
    [self.loginView.loginBtu.loginBtu addTarget:self action:@selector(clickLoginBtu) forControlEvents:UIControlEventTouchUpInside];
    //为登录按钮添加点击事件
    
    self.view = self.loginView;
    //设置登录界面的view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



- (void)clickLoginBtu{
    
    //[self.loginView.loginBtu.loginBtu setEnabled:NO];
    //防止多次点击按钮

    self.loginModel = [[MRLoginModel alloc]init];

    [self.loginModel postRequestWithStudentID:self.loginView.idTextfield.text   andPassword:self.loginView.passWordTextfield.text];
    //传入登录的数据

    if (!([self.loginView.idTextfield.text length] != 10 || [self.loginView.passWordTextfield.text length] != 6))
    {
        self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.loginProgress.mode = MBProgressHUDModeIndeterminate;
        self.loginProgress.label.text = @" 正在登录 ";
        self.loginProgress.bezelView.alpha = 0.8;
        [self.loginProgress hideAnimated:YES afterDelay:0.5];
    }
}


- (void)Notification{
    //登录的广播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:)  name:@"isLoginSuccess" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail:)  name:@"isLoginFail" object:nil];
}

- (void)loginSuccess:(NSNotification*)notification{

    [self.loginProgress hideAnimated:YES];
    ZYLMainViewController *mainVC = [[ZYLMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController: mainVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    //登录成功后进入主界面

}

- (void)loginFail:(NSNotification*)notification{
    self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //登录失败后
    [self.loginView.loginBtu.loginBtu setEnabled:YES];
    self.loginProgress.mode = MBProgressHUDModeText;
    self.loginProgress.label.text = @" 登录失败 ";
    [self.loginProgress hideAnimated:YES afterDelay:1];
}

@end
