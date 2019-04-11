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
 不要把自定义View加到原有的TabBar上，它始终在底层不会响应button点击方法
 */

#import "MRTabBarController.h"
#import "MRTabBarView.h"
#import "ZYLMainViewController.h"
#import "ZYLRankViewController.h"
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
    self.textArr = [NSMutableArray array];
    self.btnArr = [NSMutableArray array];

    self.tabView = [[MRTabBarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - self.tabBar.bounds.size.height, SCREEN_WIDTH, self.tabBar.bounds.size.height)];
    self.tabBar.backgroundColor = [UIColor whiteColor];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置子页面
- (void)addAllChildViewController{
    self.mainVC = [[ZYLMainViewController alloc] init];
    [self addChildViewController:self.mainVC title:@"首页" imageNamed:@"首页icon（未选中）" selectedImageNamed:@"首页icon（未许选中）" tag:0];
    
    ZYLRankViewController *vc2 = [[ZYLRankViewController alloc] init];
    vc2.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:vc2 title:@"排行" imageNamed:@"排行榜icon （未选中）" selectedImageNamed:@"排行榜icon（选中）" tag:1];
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor blackColor];
    [self addChildViewController:vc3 title:@"跑步" imageNamed:@"开始跑步icon（未按）" selectedImageNamed:@"开始跑步icon（按） 2" tag:2];
    
    UIViewController *vc4 = [[UIViewController alloc] init];
    vc4.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:vc4 title:@"邀约" imageNamed:@"邀约icon（未选中）" selectedImageNamed:@"邀约icon（选中）" tag:4];
    
    UIViewController *vc5 = [[UIViewController alloc] init];
    [self addChildViewController:vc5 title:@"我的" imageNamed:@"我的icon(未选中）" selectedImageNamed:@"我的icon（选中）" tag:5];
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


#pragma mark -  TabBarViewDelegate
-(void)tabBarView:(MRTabBarView *)view didSelectedItemAtIndex:(NSInteger)index
{
    // 切换到对应index的viewController
    self.selectedIndex = index;
    
    //隐藏Tabbar
//    if (index == 1) {
//        self.tabView.hidden = YES;
//    }
}

@end

