//
//  MRTabBarController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//



/*
 学艺不精啊，终于把这部分写完了，把封装性提高了（我觉得）
 后面要改tabBar的item数目和内容直接修改addAllChildViewController方法里的添加方法就行了
 这部分自定义TabBar就是直接把自己写的TabBarView（继承自UIView）把原有TabBar覆盖了
 不要把自定义View加到原有的TabBar上，它始终在底层不会响应button点击方法（迷惑）
 */

#import "MRTabBarController.h"
#import "MRTabBarView.h"
#import "ZYLMainViewController.h"
#import "ZYLPersonalViewController.h"
#import "ZYLRunningViewController.h"
#import "XIGRankViewViewController.h"
#import "LJJInviteRunVC.h"
#import <Masonry.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface MRTabBarController ()<MRTabBarViewDelegate>
@property (strong, nonatomic) ZYLMainViewController *mainVC;
@property (strong, nonatomic) NSMutableArray *btnArr;
@property (strong, nonatomic) NSMutableArray<NSString *> *textArr;
@end

@implementation MRTabBarController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.textArr = [NSMutableArray array];
    self.btnArr = [NSMutableArray array];

    self.tabView = [[MRTabBarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - self.tabBar.bounds.size.height, SCREEN_WIDTH, self.tabBar.bounds.size.height)];
    self.tabView.backgroundColor = [UIColor whiteColor];
    self.tabBar.userInteractionEnabled = NO;
    self.tabBar.hidden = YES;
    [self.view addSubview: self.tabView];
    [self.view bringSubviewToFront:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.equalTo(self.tabBar.mas_height);
    }];
    
    [self addAllChildViewController];
    [self.tabView setArray: self.btnArr];
    [self.tabView setTextArray: self.textArr];
    self.tabView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabView) name:@"hideTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabView) name:@"showTabBar" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置子页面
- (void)addAllChildViewController{
    self.mainVC = [[ZYLMainViewController alloc] init];
    [self addChildViewController:self.mainVC title:@"首页" imageNamed:@"首页icon（未选中）" selectedImageNamed:@"mainView_highlighted" tag:0];

    XIGRankViewViewController *vc2 = [[XIGRankViewViewController alloc] init];
    [self addChildViewController:vc2 title:@"排行" imageNamed:@"rank_nomal" selectedImageNamed:@"rank_highlighted" tag:1];

    ZYLRunningViewController *vc3 = [[ZYLRunningViewController alloc] init];
    [self addChildViewController:vc3 title:@"跑步" imageNamed:@"开始跑步icon（未按）" selectedImageNamed:@"开始跑步icon（按） 2" tag:2];

    LJJInviteRunVC *vc4 = [[LJJInviteRunVC alloc] init];
    [self addChildViewController:vc4 title:@"设置" imageNamed:@"setting_normal" selectedImageNamed:@"setting_highlighted" tag:4];

    ZYLPersonalViewController *vc5 = [[ZYLPersonalViewController alloc] init];
    [self addChildViewController:vc5 title:@"我的" imageNamed:@"MyView_normal" selectedImageNamed:@"MyView_highlighted" tag:5];
}


// 添加某个 childViewController
- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title imageNamed:(NSString *)imageNamed selectedImageNamed:(NSString *)selectedImageName tag:(NSInteger)i
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [vc.navigationController setNavigationBarHidden:YES animated:YES];
    [self.textArr addObject:title];
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed: imageNamed] forState: UIControlStateNormal];
    [btn setImage:[UIImage imageNamed: selectedImageName] forState: UIControlStateDisabled];
    [self.btnArr addObject: btn];
    [self addChildViewController:nav];
}


- (void)hideTabView{
    self.tabView.hidden = YES;
}

- (void)showTabView{
    self.tabView.hidden = NO;
}

#pragma mark -  TabBarViewDelegate
- (void)tabBarView:(MRTabBarView *_Nullable)view didSelectedItemAtIndex:(NSInteger) index
{
//     切换到对应index的viewController
    self.selectedIndex = index;
    
}

@end

