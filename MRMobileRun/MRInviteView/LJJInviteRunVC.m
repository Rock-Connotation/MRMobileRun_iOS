//
//  LJJInviteRunVC.m
//  MRMobileRun
//
//  Created by J J on 2019/3/31.
//

#import "LJJInviteRunVC.h"
#import "LJJInviteRunView.h"
#import "LJJInviteRunModel.h"
#import "LJJInviteViewModel.h"
#import "LJJInviteSearchResultViewController.h"
#import <MGJRouter.h>
@interface LJJInviteRunVC ()

@end

@implementation LJJInviteRunVC
- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBar" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    LJJInviteRunView *Invite = [[LJJInviteRunView alloc] init];
    
    Invite.backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景色"]];
    Invite.backImage.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
    [self.view addSubview:Invite.backImage];
    
    Invite.roundBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景修饰圆"]];
    Invite.roundBack.frame = CGRectMake(0, 0, screenWidth * 0.6717, screenHeigth * 0.5910045);
    [self.view addSubview:Invite.roundBack];
    
    //*********设置head***********
    if (screenHeigth > 800)
    {
        Invite.head = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeigth * 0.04422, screenWidth, 45)];
    }
    else
    {
        Invite.head = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 45)];
    }
    Invite.head.textAlignment = NSTextAlignmentCenter;
    Invite.head.text = @"邀约";
    Invite.head.textColor = [UIColor whiteColor];
    [self.view addSubview:Invite.head];
    
    [self setTheFlowBallsAndBoard:Invite];
    
}

- (void)pressBtn
{
    [MGJRouter openURL:kMainVCPageURL
          withUserInfo:@{@"navigationVC" : self.navigationController,
                         }
            completion:nil];
}

- (void)setTheFlowBallsAndBoard:(LJJInviteRunView *)VC
{
    //ImageView
    VC.flowBall01 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"球1"]];
    VC.flowBall02 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"球2"]];
    VC.flowBall03 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"球3"]];
    VC.searchBoard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"邀约检索框底板"]];
    VC.searchBoard.userInteractionEnabled = YES;
    VC.loadIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"加载icon"]];
    VC.flowBall01.frame = CGRectMake(screenWidth * 0.841, screenHeigth * 0.5, screenWidth * 0.1, screenWidth * 0.1);
    VC.flowBall02.frame = CGRectMake(screenWidth * 0.137, screenHeigth * 0.9, screenWidth * 0.055, screenWidth * 0.055);
    VC.flowBall03.frame = CGRectMake(screenWidth * 0.54, screenHeigth + 7, screenWidth * 0.055, screenWidth * 0.055);
    VC.searchBoard.frame = CGRectMake(screenWidth * 0.053, screenHeigth * 0.4872, screenWidth * 0.892, screenHeigth * 0.39);
    VC.loadIcon.frame = CGRectMake(screenWidth * 0.3813333, screenHeigth * 0.0592203, screenWidth * 0.157333, screenWidth * 0.157333);
    
    //波浪
    VC.imageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"水波纹后"]];
    VC.imageBack.frame = CGRectMake(screenWidth * -0.5904, screenHeigth * 0.93478, screenWidth * 2.3616, screenHeigth * 0.1035);
    VC.imageFront = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"水波纹前"]];
    VC.imageFront.frame = CGRectMake(0, screenHeigth * 0.93478, screenWidth * 2.3616, screenHeigth * 0.1035);
    //Label
    VC.loading = [[UILabel alloc] init];
    VC.loading.textColor = [self colorWithHexString:@"#FF599F"];
    VC.loading.text = @"邀约跑步加载中...";
    VC.loading.backgroundColor = [UIColor clearColor];
    VC.loading.textAlignment = NSTextAlignmentCenter;
    VC.loading.frame = CGRectMake(0, screenHeigth * 0.2248, screenWidth * 0.892, screenHeigth * 0.0375);
    
    //Button
    VC.cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [VC.cancel setTitle:@"取消" forState:UIControlStateNormal];
    VC.cancel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [VC.cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    VC.cancel.frame = CGRectMake(screenWidth * 0.01, screenHeigth * 0.3238, screenWidth * 0.892, screenHeigth * 0.0375);
    [VC.cancel addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.999 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:17.f options:UIViewAnimationOptionTransitionNone animations:^{
        VC.searchBoard.frame = CGRectMake(screenWidth * 0.053, screenHeigth * 0.2436, screenWidth * 0.892, screenHeigth * 0.39);
        //历史记录网络请求
        LJJInviteRunModel *model = [[LJJInviteRunModel alloc] init];
        [model catchTheLoginToken];
    } completion:^(BOOL finished) {
        [self Begin:VC];
    }];
    
    [self.view addSubview:VC.flowBall01];
    [self.view addSubview:VC.flowBall02];
    [self.view addSubview:VC.flowBall03];
    [self.view addSubview:VC.searchBoard];
    [VC.searchBoard addSubview:VC.loadIcon];
    [VC.searchBoard addSubview:VC.loading];
    [VC.searchBoard addSubview:VC.cancel];
    [self.view addSubview:VC.imageBack];
    [self.view addSubview:VC.imageFront];
}

- (void)Begin:(LJJInviteRunView *)VC
{
    [UIView animateWithDuration:3.7 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
    {
        VC.flowBall01.frame = CGRectMake(screenWidth * 0.841, screenHeigth * 0.178, screenWidth * 0.1, screenWidth * 0.1);
        VC.flowBall02.frame = CGRectMake(screenWidth * 0.137, screenHeigth * 0.706, screenWidth * 0.055, screenWidth * 0.055);
        VC.flowBall03.frame = CGRectMake(screenWidth * 0.54, screenHeigth * 0.836, screenWidth * 0.055, screenWidth * 0.055);
        VC.imageBack.frame = CGRectMake(screenWidth * -1.7712, screenHeigth * 0.93478, screenWidth * 2.3616, screenHeigth * 0.1035);
        VC.imageFront.frame = CGRectMake(screenWidth * -0.9344, screenHeigth * 0.93478, screenWidth * 2.3616, screenHeigth * 0.1035);
    }completion:^(BOOL finished)
    {
        [self showSearchView:VC];
    }];
}

- (void)showSearchView:(LJJInviteRunView *)VC
{
    //设置返回按钮
    VC.whiteBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回箭头_白"]];
    if (screenHeigth > 800)
    {
        //Invite.head = [[UILabel alloc] initWithFrame:
        VC.whiteBack.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.06, screenWidth * 0.034444, screenWidth * 0.0493333);
    }
    else if (screenHeigth > 600 && screenHeigth < 800)
    {
        VC.whiteBack.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.0455, screenWidth * 0.03, screenWidth * 0.06);
    }
    else if (screenHeigth < 600)
    {
        VC.whiteBack.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.06, screenWidth * 0.03, screenWidth * 0.06);
    }
    [self.view addSubview:VC.whiteBack];
    
    //设置手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressBtn)];
    VC.whiteBack.userInteractionEnabled = YES;
    [VC.whiteBack addGestureRecognizer:gesture];

    
    [UIView animateWithDuration:0.999 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:17.f options:UIViewAnimationOptionTransitionNone animations:^{
        VC.searchBoard.frame = CGRectMake(screenWidth * 0.053, screenHeigth * 0.1754, screenWidth * 0.892, screenHeigth * 0.39);
        [VC.flowBall01 removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
    
    VC.loading.text = @"提示:约跑邀约一次只能邀请1至4位小伙伴哦～";
    VC.loading.frame = CGRectMake(0, screenHeigth * 0.305097, screenWidth * 0.892, screenHeigth * 0.0247376);
    VC.loading.textColor = [UIColor grayColor];
    _inviteTextField = [[UITextField alloc] initWithFrame:CGRectMake(screenWidth * 0.10666, screenHeigth * 0.2248, screenWidth * 0.5, screenHeigth * 0.0375)];
    NSString *holderText = @"请输入学号";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#D4D8EA"] range:NSMakeRange(0, holderText.length)];
    _inviteTextField.textColor = [self colorWithHexString:@"#6F7584"];
    _inviteTextField.attributedPlaceholder = placeholder;
    _inviteTextField.borderStyle = UITextBorderStyleNone;
    _inviteTextField.keyboardType = UIKeyboardTypeNumberPad;

    
    [VC.searchBoard addSubview:_inviteTextField];
    VC.flowBall01.image = [UIImage imageNamed:@"输入框填入线"];
    VC.flowBall01.frame = CGRectMake(screenWidth * 0.10666, screenHeigth * 0.2624, screenWidth * 0.6786666, screenHeigth * 0.00149925);
    [VC.searchBoard addSubview:VC.flowBall01];
    
    VC.inviteTextCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [VC.inviteTextCancel setImage:[UIImage imageNamed:@"取消输入"] forState:UIControlStateNormal];
    [VC.inviteTextCancel addTarget:self action:@selector(pressBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
    VC.inviteTextCancel.frame = CGRectMake(screenWidth * 0.7853266 - screenHeigth * 0.03, screenHeigth * 0.2249, screenHeigth * 0.033, screenHeigth * 0.033);
    [VC.searchBoard addSubview:VC.inviteTextCancel];
    
    [VC.cancel removeFromSuperview];
    VC.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [VC.cancel setImage:[UIImage imageNamed:@"下一步按钮"] forState:UIControlStateNormal];
    VC.cancel.frame = CGRectMake(screenWidth * 0.4, screenHeigth * 0.52248876, screenWidth * 0.233, screenWidth * 0.233);
    [self.view addSubview:VC.cancel];
    
    [VC.cancel addTarget:self action:@selector(invitePeopleToRun) forControlEvents:UIControlEventTouchUpInside];
    
    //历史记录label
    VC.historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.098, screenHeigth * 0.64, screenWidth * 0.37, screenHeigth * 0.02998501)];
    VC.historyLabel.text = @"历史记录";
    VC.historyLabel.textColor = [UIColor grayColor];
    [self.view addSubview:VC.historyLabel];
    
    //添加历史记录底板
//    LJJInviteViewModel *VM = [[LJJInviteViewModel alloc] init];
//    [VM setHisrotyViewWhenNoHistoryWithViewController:self andView:VC];
    
    if (screenHeigth > 800)
    {
        [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, holderText.length)];
        VC.loading.font = [UIFont systemFontOfSize:14];
        VC.historyLabel.font = [UIFont systemFontOfSize:18];
    }
    else if (screenHeigth > 600 && screenHeigth < 800)
    {
        [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, holderText.length)];
        VC.loading.font = [UIFont systemFontOfSize:12];
        VC.historyLabel.font = [UIFont systemFontOfSize:16];
    }
    else if (screenHeigth <  600)
    {
        [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, holderText.length)];
        VC.loading.font = [UIFont systemFontOfSize:10];
        VC.historyLabel.font = [UIFont systemFontOfSize:14];
    }
    
    //头像
    [VC.flowBall02 removeFromSuperview];
    [VC.flowBall03 removeFromSuperview];
    [VC.imageBack removeFromSuperview];
    [VC.imageFront removeFromSuperview];
}

- (void)invitePeopleToRun
{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    [store setObject:_inviteTextField.text forKey:@"textName"];
    LJJInviteRunModel *model = [[LJJInviteRunModel alloc] init];
    [model invitePeopleToRunURL];
    NSLog(@"%@",_inviteTextField.text);
    [self setNotification];
}

- (void)setNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchSuccessful)  name:@"isSearchSuccessful" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFail)  name:@"isSearchFail" object:nil];
}

- (void)searchSuccessful
{
    LJJInviteSearchResultViewController *resultVC = [[LJJInviteSearchResultViewController alloc] init];
    [self presentViewController:resultVC animated:NO completion:nil];
}

- (void)searchFail
{
    NSLog(@"查询失败查询失败查询失败查询失败查询失败查询失败");
}

- (void)pressBtnCancel:(LJJInviteRunView *)VC
{
    [_inviteTextField setText:nil];
    NSLog(@"按钮已被按下");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_inviteTextField resignFirstResponder];
}

//十六进制转color
- (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet     whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
