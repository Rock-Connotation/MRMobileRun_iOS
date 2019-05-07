//
//  XIGRankViewViewController.m
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "XIGRankViewViewController.h"
#import "XIGSegementView.h"
#import "XIGClassRankViewController.h"
#import "XIGInviteViewController.h"
#import "XIGStudentViewController.h"
#import "YYkit.h"
@interface XIGRankViewViewController ()

@end

@implementation XIGRankViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    XIGStudentViewController *view1 = [[XIGStudentViewController  alloc]init];
    view1.title = @"校园排行";
    XIGClassRankViewController *view2 = [[XIGClassRankViewController alloc]init];
    view2.title = @"班级排行";
    XIGInviteViewController *view3 = [[XIGInviteViewController alloc]init];
    view3.title = @"邀约排行";
    NSArray *viewArray = @[view1,view2,view3];
    //初始化我们需要改变背景色的UIView，并添加在视图上
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, (30 *screenHeigth/667))];
    [self.view addSubview:theView];
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = theView.bounds;

    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [theView.layer addSublayer:gradientLayer];

    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);

    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:133/255.0 green:100/255.0 blue:181/255.0 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:137/255.0 green:104/255.0 blue:183/255.0 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:149/255.0 green:116/255.0 blue:192/255.0 alpha:1.0].CGColor,
       (__bridge id)[UIColor colorWithRed:162/255.0 green:131/255.0 blue:200/255.0 alpha:1.0].CGColor];

    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f),@(0.2f), @(0.58f), @(1.0f)];
    XIGSegementView *segementView = [[XIGSegementView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, self.view.height - NVGBARHEIGHT - STATUSBARHEIGHT) andControllers:viewArray WithStyle:@"systom"];
    segementView.titleTextFocusColor = [UIColor whiteColor];
    segementView.titleTextNormalColor = [UIColor colorWithHexString:@"#DEBDEC"];
    [self.view addSubview:segementView];
    //实现背景渐变
    [self setNavigation];

}

- (void)setNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav+导航栏底板"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"<返回"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
