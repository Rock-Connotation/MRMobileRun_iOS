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
@property (strong, nonatomic) ZYLMainViewController *vc1;
@property (strong, nonatomic) ZYLRankViewController *vc2;
@property (strong, nonatomic) ZYLRunningViewController *vc3;
@property (strong, nonatomic) ZYLPersonalViewController *vc4;
@property (strong, nonatomic) MGDMineViewController *vc5;
@property (strong, nonatomic) MGDTabBar *tabBar;


@end

@implementation MGDTabBarViewController

@dynamic tabBar;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.delegate = self;
          self.tabBar = [[MGDTabBar alloc] init];
          [self.tabBar.centerBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
          //设置背景颜色透明
          self.tabBar.translucent = YES;
          //利用KVC,将自定义tabBar,赋给系统tabBar
          [self setValue:self.tabBar forKeyPath:@"tabBar"];
          [self addChildViewControllers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

//添加子控制器
- (void)addChildViewControllers{
    self.vc1 = [[ZYLMainViewController alloc] init];
    self.vc1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);
    self.vc1.tabBarItem.image = [[UIImage imageNamed:@"mainView_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"mainView_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.vc2 = [[ZYLRankViewController alloc] init];
    self.vc2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);
    self.vc2.tabBarItem.image = [[UIImage imageNamed:@"rank_nomal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"rank_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.vc3 = [[ZYLRunningViewController alloc] init];
    
    self.vc4 = [[ZYLPersonalViewController alloc] init];
    self.vc4.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);
    self.vc4.tabBarItem.image = [[UIImage imageNamed:@"setting_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.vc4.tabBarItem.selectedImage = [[UIImage imageNamed:@"setting_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.vc5 = [[MGDMineViewController  alloc] init];
    self.vc5.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);
    self.vc5.tabBarItem.image = [[UIImage imageNamed:@"MyView_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.vc5.tabBarItem.selectedImage = [[UIImage imageNamed:@"MyView_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSArray *itemArrays = @[self.vc1,self.vc2,self.vc3,self.vc4,self.vc5];
    self.viewControllers = itemArrays;
}
- (void)buttonAction{
    //关联中间按钮
    self.selectedIndex = 2;
    
}
//tabbar选择时的代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    [self.tabBar.centerBtn.layer removeAllAnimations];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            // 执行操作
            NSLog(@"改变了模式");
            self.vc1.tabBarItem.image = [[UIImage imageNamed:@"mainView_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"mainView_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.vc2.tabBarItem.image = [[UIImage imageNamed:@"rank_nomal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"rank_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.vc4.tabBarItem.image = [[UIImage imageNamed:@"setting_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.vc4.tabBarItem.selectedImage = [[UIImage imageNamed:@"setting_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.vc5.tabBarItem.image = [[UIImage imageNamed:@"MyView_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.vc5.tabBarItem.selectedImage = [[UIImage imageNamed:@"MyView_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    } else {
        // Fallback on earlier versions
        NSLog(@"未改变模式");
    }

}

@end
