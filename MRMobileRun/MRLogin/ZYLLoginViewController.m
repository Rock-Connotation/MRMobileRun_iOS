//
//  ZYLLoginViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/13.
//

#import "ZYLLoginViewController.h"
#import "ZYLLoginView.h"
#import "MRTabBarController.h"
#import "MRLoginModel.h"
#import "MBProgressHUD.h"

@interface ZYLLoginViewController ()
@property (nonatomic, strong) ZYLLoginView *loginView;
@property (nonatomic,strong) MRLoginModel *loginModel;
@property (nonatomic,strong) MBProgressHUD *loginProgress;
@end

@implementation ZYLLoginViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Notification];
    [self.view addSubview: self.loginView];
}
#pragma mark - notifications
- (void)Notification{
    //登录的广播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:)  name:@"isLoginSuccess" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail:)  name:@"isLoginFail" object:nil];
}

- (void)loginFail:(NSNotification*)notification{
    self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //登录失败后
    [self.loginView.loginBtn setEnabled:YES];
    self.loginProgress.mode = MBProgressHUDModeText;
    self.loginProgress.label.text = @" 登录失败 ";
    [self.loginProgress hideAnimated:YES afterDelay:1];
}

- (void)loginSuccess:(NSNotification*)notification{

    [self.loginProgress hideAnimated:YES];
    MRTabBarController *mainVC = [[MRTabBarController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController: mainVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    //登录成功后进入主界面
    NSLog(@"登陆成功");
}

#pragma mark - click event

- (void)clickLoginButton{
    self.loginModel = [[MRLoginModel alloc]init];

    [self.loginModel postRequestWithStudentID:self.loginView.usernameField.text   andPassword:self.loginView.passwordField.text];
    //传入登录的数据

    if (!([self.loginView.usernameField.text length] != 10 || [self.loginView.passwordField.text length] != 6))
    {
        self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.loginProgress.mode = MBProgressHUDModeIndeterminate;
        self.loginProgress.label.text = @" 正在登录 ";
        self.loginProgress.bezelView.alpha = 0.8;
        [self.loginProgress hideAnimated:YES afterDelay:0.5];
    }
}

#pragma mark - lazyload
- (ZYLLoginView *)loginView{
    if (!_loginView) {
        _loginView = [[ZYLLoginView alloc] init];
        _loginView.frame = self.view.frame;
        [_loginView.loginBtn addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginView;
}

@end
