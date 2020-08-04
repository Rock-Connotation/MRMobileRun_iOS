//
//  ZYLMainViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLMainViewController.h"
#import "ZYLMainView.h"
#import "ZYLStartRunningButton.h"
#import "ZYLHostView.h"
#import "ZYLGetTimeScale.h"
#import "ZYLHealthManager.h"
#import "MRTabBarController.h"
#import <MGJRouter.h>
#import <Masonry.h>
@interface ZYLMainViewController ()
{
    NSInteger todaySteps;
    NSInteger yesterdaySteps;
    NSInteger todayStairs;
    NSInteger yesterdayStairs;
}
@property (strong, nonatomic) ZYLHostView *hostView;
@property (nonatomic, strong) NSUserDefaults *user;
@property (nonatomic, strong) ZYLHealthManager *healthManager;
@end

@implementation ZYLMainViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [NSUserDefaults standardUserDefaults];
    self.healthManager = [ZYLHealthManager shareInstance];
    [self.view addSubview: self.hostView];
    [self getDataFromHealth];
    [self.hostView setTextOfStepLab:[NSString stringWithFormat:@"%ld",(long)todaySteps]  andStairLab:[NSString stringWithFormat:@"%ld",(long)todayStairs]];
}

- (void) getDataFromHealth{
    todaySteps = [self.healthManager getTodayStepCount];
    yesterdaySteps = [self.healthManager getYesterdayStepCount];
    todayStairs = [self.healthManager getTodayFlightsClimbedCount];
    yesterdayStairs = [self.healthManager getYesterdayFlightsClimbedCount];
}

#pragma mark - 懒加载
- (ZYLHostView *)hostView{
    if (!_hostView) {
        _hostView = [[ZYLHostView alloc] init];
        _hostView.frame = CGRectMake(0, -kStatusBarHeigh*kRateX, screenWidth, screenHeigth);
        _hostView.scrollEnabled = YES;
        _hostView.contentSize = CGSizeMake(screenWidth, screenHeigth+100*kRateY);
        [_hostView.greetLab setText:[NSString stringWithFormat:@"%@%@", [ZYLGetTimeScale getTimeScaleString], [_user valueForKey:@"nickname"]]];

    }
    return _hostView;
}


@end
