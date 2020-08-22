//
//  GYYRankUnitViewController.m
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/8/21.
//

#import "GYYRankUnitViewController.h"
#import "GYYRankChidlViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"

@interface GYYRankUnitViewController ()<TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate>

@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation GYYRankUnitViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(10, 0, screenWidth - 10, 39);
    _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame), screenWidth, screenHeigth - CGRectGetMaxY(_tabBar.frame) - kTabBarHeight - (55 + (kIs_iPhoneX ? 44 : 20)));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubviews];
}

- (void)createSubviews{
    [self addTabPagerBar];
    [self addPagerController];
    [self reloadData];
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.datas[index];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
//每组标题
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return 42;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return self.datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    GYYRankChidlViewController *rankChildVC = [[GYYRankChidlViewController alloc] init];
    rankChildVC.isFaculty = self.isFaculty;
    rankChildVC.rankType = index;
    return rankChildVC;
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

#pragma mark ======== tab布局 ========
- (void)addTabPagerBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    if (@available(iOS 13.0, *)) {
        UIColor *GYYColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return COLOR_WITH_HEX(0xFCFCFC);
            }
            else {
                return COLOR_WITH_HEX(0x3C3F43);
            }
        }];
        tabBar.backgroundColor = GYYColor;
    } else {
        tabBar.backgroundColor = COLOR_WITH_HEX(0xFCFCFC);
    }
    tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    tabBar.layout.progressWidth = 42;
    tabBar.layout.progressHeight = 4;
    tabBar.layout.progressColor = COLOR_WITH_HEX(0x55D5E2);
    tabBar.progressView.layer.cornerRadius = 2.0;
    tabBar.layout.progressVerEdging = 0;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.cellEdging = 7.5;
    tabBar.layout.cellSpacing = 10;
    tabBar.layout.adjustContentCellsCenter = NO;
    tabBar.layout.selectedTextFont = [UIFont boldSystemFontOfSize:18];
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:16];
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc] init];
    pagerController.layout.prefetchItemCount = 1;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    if (@available(iOS 13.0, *)) {
        UIColor *GYYColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return COLOR_WITH_HEX(0xFCFCFC);
            }
            else {
                return COLOR_WITH_HEX(0x3C3F43);
            }
        }];
        pagerController.scrollView.backgroundColor = GYYColor;
    } else {
        pagerController.scrollView.backgroundColor = COLOR_WITH_HEX(0xFCFCFC);
    }
    
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

#pragma mark ======== 懒加载 ========
- (NSArray *)datas {
    if (!_datas) {
        _datas = @[@"日榜", @"周榜", @"月榜"];
    }
    return _datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
