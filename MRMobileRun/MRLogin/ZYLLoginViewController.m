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
#import "MGDTabBarViewController.h"

@interface ZYLLoginViewController ()
@property (nonatomic, strong) ZYLLoginView *loginView;
@property (nonatomic,strong) MRLoginModel *loginModel;
@property (nonatomic,strong) MBProgressHUD *loginProgress;
@property (nonatomic,strong) MBProgressHUD *waitProgress;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailNoClient:)  name:@"isLoginFailNoClient" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailErrorData:)  name:@"isLoginFailErrorData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailNoData:)  name:@"isLoginFailNoData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailTimeOut:)  name:@"isLoginFailTimeOut" object:nil];
}

- (void)loginFailNoClient:(NSNotification*)notification{
    [self.waitProgress removeFromSuperview];
    self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginView.loginBtn setEnabled:YES];
    self.loginProgress.mode = MBProgressHUDModeText;
    self.loginProgress.label.text = @" 网络连接错误,请重新连接网络 ";
    [self.loginProgress hideAnimated:YES afterDelay:2.0];
}

- (void)loginFailErrorData:(NSNotification*)notification{
    [self.waitProgress removeFromSuperview];
    self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginView.loginBtn setEnabled:YES];
    self.loginProgress.mode = MBProgressHUDModeText;
    self.loginProgress.label.text = @" 账号密码输入错误 ";
    [self.loginProgress hideAnimated:YES afterDelay:2.0];
}

- (void)loginFailNoData:(NSNotification*)notification{
    //[self.waitProgress removeFromSuperview];
    self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginView.loginBtn setEnabled:YES];
    self.loginProgress.mode = MBProgressHUDModeText;
    self.loginProgress.label.text = @" 账号密码为空 ";
    [self.loginProgress hideAnimated:YES afterDelay:2.0];
}

- (void)loginFailTimeOut:(NSNotification*)notification{
    self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginView.loginBtn setEnabled:YES];
    self.loginProgress.mode = MBProgressHUDModeText;
    self.loginProgress.label.text = @" 连接超时 请检查网络 ";
    [self.loginProgress hideAnimated:YES afterDelay:2.0];
}

- (void)loginSuccess:(NSNotification*)notification{

    [self.loginProgress hideAnimated:YES];
    MGDTabBarViewController *mainVC = [[MGDTabBarViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController: mainVC];
    //点击登录后收起键盘
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    //登录成功后进入主界面
    NSLog(@"登陆成功");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - click event

- (void)clickLoginButton{
    self.loginModel = [[MRLoginModel alloc]init];

    [self.loginModel postRequestWithStudentID:self.loginView.usernameField.text   andPassword:self.loginView.passwordField.text];
    //传入登录的数据
    if (!([self.loginView.usernameField.text length] != 0 && [self.loginView.passwordField.text length] != 0)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFailNoData" object:nil];
    }
    else {
        self.waitProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.waitProgress.mode = MBProgressHUDModeIndeterminate;
        self.waitProgress.label.text = @" 正在登录 ";
        self.waitProgress.bezelView.alpha = 0.8;
        [self.waitProgress hideAnimated:YES afterDelay:30.0];
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
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
