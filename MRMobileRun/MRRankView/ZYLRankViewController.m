
//
//  ZYLRankViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/29.
//

#import "ZYLRankViewController.h"
#import "GYYRankUnitViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"

@interface ZYLRankViewController ()<TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate>

@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation ZYLRankViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, 10 + (kIs_iPhoneX ? 44 : 20), screenWidth, 45);
    _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame), screenWidth, screenHeigth - (55 + (kIs_iPhoneX ? 44 : 20)));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubviews];
}

- (void)createSubviews{
    if (@available(iOS 13.0, *)) {
        UIColor *GYYColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return COLOR_WITH_HEX(0xFCFCFC);
            }
            else {
                return COLOR_WITH_HEX(0x3C3F43);
            }
        }];
        self.view.backgroundColor = GYYColor;
    } else {
        self.view.backgroundColor = COLOR_WITH_HEX(0xFCFCFC);
    }
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
    return 120;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return self.datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    GYYRankUnitViewController *rankUnitVC = [[GYYRankUnitViewController alloc] init];
    rankUnitVC.isFaculty = index;
    return rankUnitVC;
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
    tabBar.layout.barStyle = TYPagerBarStyleNoneView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.cellSpacing = 20;
    tabBar.layout.adjustContentCellsCenter = YES;
    tabBar.layout.selectedTextFont = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    tabBar.layout.normalTextFont = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
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
        _datas = @[@"校园排行", @"学院排行"];
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
