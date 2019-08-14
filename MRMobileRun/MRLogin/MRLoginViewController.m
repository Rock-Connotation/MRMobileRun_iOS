

//
//  MRLoginViewController.m
//  MobileRun
//
//  Created by 郑沛越 on 2016/11/30.
//  Copyright © 2016年 郑沛越. All rights reserved.
//

#import "MRLoginViewController.h"
#import "HttpClient.h"
#import "ZYLMainViewController.h"
#import "MRLoginModel.h"
#import "LJJInviteRunVC.h"
#import "MBProgressHUD.h"
#import "LJJInviteOk.h"
#import "MRLoginView.h"
#import "LJJInviteCancel.h"
#import "ZYLRunningViewController.h"
#import "MRLoginModel.h"
@interface MRLoginViewController ()
//@property (nonatomic,strong) ZYLMainView *homePageVC;

//登录界面的view
@property (nonatomic,strong) MRLoginModel *loginModel;

@property (nonatomic,strong) MBProgressHUD *loginProgress;
//登陆后跳转的主界面
@property (nonatomic,strong) MRLoginView *loginView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIVisualEffectView *effectview;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, strong) NSThread *thread1;
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
    NSLog(@"登陆成功");
}

- (void)setTheSpringWindow
{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectview.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
    _effectview.userInteractionEnabled = YES;
    _effectview.alpha = 0.777;
    _effectview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [[MRLoginViewController findCurrentViewController].view addSubview:_effectview];
    //设置弹窗
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"弹窗"]];
    _imageView.frame = CGRectMake(screenWidth *68.0/750, screenHeigth *350.0/1334, screenWidth *614.0/750, screenHeigth *408.0/1334);
    _imageView.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    [[MRLoginViewController findCurrentViewController].view addSubview:_imageView];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon"]];
    img.frame = CGRectMake(screenWidth *202.0/750, screenHeigth *69.0/1334, screenWidth *52.0/750, screenWidth *52.0/750);
    [_imageView addSubview:img];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth *272.5/750, screenHeigth *68.0/1334, screenWidth *200.0/750, screenHeigth *50.0/1334)];
    message.text = @"邀约消息";
    message.textColor = [LJJInviteRunVC colorWithHexString:@"#7A5595"];
    [_imageView addSubview:message];
    
    UILabel *inviteMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeigth *162.0/1334, screenWidth *614.0/750, screenHeigth *40.0/1334)];
    inviteMessage.text = [NSString stringWithFormat:@"收到来自%@的邀约",_nickName];
    inviteMessage.textAlignment = NSTextAlignmentCenter;
    inviteMessage.textColor = [LJJInviteRunVC colorWithHexString:@"#B4ABC6"];
    [_imageView addSubview:inviteMessage];
    
    UILabel *acceptInvite = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeigth *220.0/1334, screenWidth *614.0/750, screenHeigth *40.0/1334)];
    acceptInvite.text = [NSString stringWithFormat:@"是否接受邀约"];
    acceptInvite.textAlignment = NSTextAlignmentCenter;
    acceptInvite.textColor = [LJJInviteRunVC colorWithHexString:@"#B4ABC6"];
    [_imageView addSubview:acceptInvite];
    
    UIImageView *line01 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"横分割线"]];
    line01.frame = CGRectMake(0, screenHeigth *297.0/1334, screenWidth *614.0/750, screenHeigth *2.0/1334);
    [_imageView addSubview:line01];
    
    UIImageView *line02 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"束分割线"]];
    line02.frame = CGRectMake(screenWidth *306.0/750, screenHeigth *299.0/1334, screenWidth *2.0/750, screenHeigth *109.0/1334);
    [_imageView addSubview:line02];
    
    //取消按钮
    LJJInviteCancel *cancel = [[LJJInviteCancel alloc] initWithFrame:CGRectMake(0, screenHeigth *329.0/1334, screenWidth *307.0/750, screenHeigth *45.0/1334)];
    cancel.backgroundColor = [UIColor clearColor];
    [_imageView addSubview:cancel];
    [cancel useBlockNameBlock:^{
        [self->_effectview setHidden:YES];
        [self->_imageView setHidden:YES];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        NSLog(@"the invited_id is %@",self->_invitedID);
        NSLog(@"the 被邀请人的学号:%@",[user objectForKey:@"studentID"]);
        NSLog(@"2");
        //拒绝返回2
        //继续轮询
        [[NSNotificationCenter defaultCenter] postNotificationName:@"keepTimer" object:nil];

        
        HttpClient *client = [HttpClient defaultClient];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[user objectForKey:@"studentID"] forKey:@"student_id"];
        [dic setObject:self->_invitedID forKey:@"invited_id"];
        [dic setObject:@"2" forKey:@"result"];
        NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded",@"token":[user objectForKey:@"token"]};
        [client requestWithHead:kWhetherAcceptTheInvite method:HttpRequestPost parameters:dic head:head prepareExecute:^
         {
             //
         } progress:^(NSProgress *progress)
         {
             //
         } success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"不接受邀请:%@",responseObject);
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             //
             NSLog(@"%@",error);
         }];
        
    }];
    UILabel *can = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth *307.0/750, screenHeigth *45.0/1334)];
    can.textColor = [LJJInviteRunVC colorWithHexString:@"#EF6253"];
    can.text = @"取消";
    can.textAlignment = NSTextAlignmentCenter;
    can.userInteractionEnabled = YES;
    [cancel addSubview:can];
    
    //确定按钮
    LJJInviteOk *ok = [[LJJInviteOk alloc] initWithFrame:CGRectMake(screenWidth *308.0/750, screenHeigth *329.0/1334, screenWidth *306.0/750, screenHeigth *45.0/1334)];
    ok.backgroundColor = [UIColor clearColor];
    [_imageView addSubview:ok];
    [ok useBlockNameBlock:^{
        //同意返回1
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        HttpClient *client = [HttpClient defaultClient];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[user objectForKey:@"studentID"] forKey:@"student_id"];
        [dic setObject:self->_invitedID forKey:@"invited_id"];
        [dic setObject:@"1" forKey:@"result"];
        NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded",@"token":[user objectForKey:@"token"]};
        [client requestWithHead:kWhetherAcceptTheInvite method:HttpRequestPost parameters:dic head:head prepareExecute:^
         {
             //
         } progress:^(NSProgress *progress)
         {
             //
         } success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"接受邀请:%@",responseObject);
             //跳转到跑步界面
             ZYLRunningViewController *runVC = [[ZYLRunningViewController alloc] init];
             [[MRLoginViewController findCurrentViewController] presentViewController:runVC animated:YES completion:nil];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             //
             NSLog(@"%@",error);
         }];
    }];
    UILabel *okk = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth *307.0/750, screenHeigth *45.0/1334)];
    okk.textColor = [LJJInviteRunVC colorWithHexString:@"#7A5595"];
    okk.text = @"确定";
    okk.textAlignment = NSTextAlignmentCenter;
    okk.userInteractionEnabled = YES;
    [ok addSubview:okk];
}


+ (UIViewController *)findCurrentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
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
