//
//  LJJInviteRunVC.m
//  MRMobileRun
//
//  Created by J J on 2019/3/31.
//

#import "LJJInviteRunVC.h"
#import "LJJInviteRunView.h"
#import "LJJInviteSearchVC.h"
#import <MGJRouter.h>
@interface LJJInviteRunVC ()
@property NSUInteger flag;
@end

@implementation LJJInviteRunVC
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
    //[self.colorWithHexString:@"#FF599F"];

    VC.loading.textColor = [LJJInviteRunVC colorWithHexString:@"FF599F"];
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
    
    _flag = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)pressBtn
{
    [MGJRouter openURL:kMainVCPageURL
          withUserInfo:@{@"navigationVC" : self.navigationController,
                         }
            completion:nil];
    _flag = 0;
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
        NSLog(@"animationed");
        if (self->_flag != 0) {
            LJJInviteSearchVC *vc = [[LJJInviteSearchVC alloc] init];
            [self presentViewController:vc animated:NO completion:nil];
        }
    }];
}

//十六进制转color
+ (UIColor *)colorWithHexString:(NSString *)color{
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
