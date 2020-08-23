//
//  MGDTabBarViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/8/21.
//

#import "MGDTabBarViewController.h"
#import "MGDTabBar.h"
#import "ZYLMainViewController.h"
#import "ZYLPersonalViewController.h"
#import "ZYLRunningViewController.h"
#import "ZYLRankViewController.h"
#import "LJJInviteRunVC.h"
#import "MGDMineViewController.h"
#import "ZYLMainViewController.h"

@interface MGDTabBarViewController ()<UITabBarControllerDelegate>
@property (strong, nonatomic) NSMutableArray *btnArr;
@property (strong, nonatomic) NSMutableArray<NSString *> *textArr;
@property (strong, nonatomic) ZYLMainViewController *mainVC;

@property (nonatomic,strong)MGDTabBar *tabBar;


@end

@implementation MGDTabBarViewController

@dynamic tabBar;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.tabBar = [[MGDTabBar alloc] init];
    [self.tabBar.centerBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    //设置背景颜色透明
    self.tabBar.translucent = YES;
    //利用KVC,将自定义tabBar,赋给系统tabBar
    [self setValue:self.tabBar forKeyPath:@"tabBar"];
    [self addChildViewControllers];
}

//添加子控制器
- (void)addChildViewControllers{
    self.mainVC = [[ZYLMainViewController alloc] init];
    //self.mainVC.tabBarItem.title = @"首页";
    self.mainVC.tabBarItem.imageInsets = UIEdgeInsetsMake(9, 0,-9, 0);
    self.mainVC.tabBarItem.image = [[UIImage imageNamed:@"mainView_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.mainVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"mainView_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ZYLRankViewController *vc2 = [[ZYLRankViewController alloc] init];
    
    vc2.tabBarItem.imageInsets = UIEdgeInsetsMake(9, 0,-9, 0);
    vc2.tabBarItem.image = [[UIImage imageNamed:@"rank_nomal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"rank_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ZYLRunningViewController *vc3 = [[ZYLRunningViewController alloc] init];
    //vc3.tabBarItem.title = @"跑步";
    
    ZYLPersonalViewController *vc4 = [[ZYLPersonalViewController alloc] init];
    //vc4.tabBarItem.title = @"设置";
    vc4.tabBarItem.imageInsets = UIEdgeInsetsMake(9, 0,-9, 0);
    vc4.tabBarItem.image = [[UIImage imageNamed:@"setting_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc4.tabBarItem.selectedImage = [[UIImage imageNamed:@"setting_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MGDMineViewController *vc5 = [[MGDMineViewController  alloc] init];
    //vc5.tabBarItem.title = @"我的";
    vc5.tabBarItem.imageInsets = UIEdgeInsetsMake(9, 0,-9, 0);
    vc5.tabBarItem.image = [[UIImage imageNamed:@"MyView_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc5.tabBarItem.selectedImage = [[UIImage imageNamed:@"MyView_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSArray *itemArrays = @[self.mainVC,vc2,vc3,vc4,vc5];
    self.viewControllers = itemArrays;
    self.tabBar.tintColor = [UIColor blackColor];
}
- (void)buttonAction{
    //关联中间按钮
    self.selectedIndex = 2;
    
}
//tabbar选择时的代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    [self.tabBar.centerBtn.layer removeAllAnimations];
}

@end
