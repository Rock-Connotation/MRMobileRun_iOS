//
//  ZYLMainViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLMainViewController.h"
#import "ZYLMainView.h"
#import "MRTabBar.h"
#import <MGJRouter.h>
@interface ZYLMainViewController () <MRTabBarViewDelegate>
@property (strong, nonatomic) ZYLMainView *mainView;
@property (strong, nonatomic) WeProgressCircle *progressCircle;
@property (strong, nonatomic) MRTabBar *tab;
@property (assign, nonatomic) CGFloat tabBarHeight;
@end

@implementation ZYLMainViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.mainView.backGroundView.progressCircle startAnimation];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.progressCircle stopAnimation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.mainView];
    self.tab = [[MRTabBar alloc] initWithFrame:CGRectMake(0, screenHeigth-kTabBarHeight, screenWidth, kTabBarHeight)];
    [self.view addSubview:self.tab];
    self.tab.tabView.delegate = self;
//    [self.view bringSubviewToFront:self.tab.tabView];
    // Do any additional setup after loading the view.
}
//隐藏navigationBar
- (void)tabBarView:(MRTabBarView *_Nullable)view didSelectedItemAtIndex:(NSInteger) index
{
    // 切换到对应index的viewController
    //    self.selectedIndex = index;
    switch (index) {
        case 1:
            [MGJRouter openURL:kRankVCPageURL
                  withUserInfo:@{@"navigationVC" : self.navigationController,
                                 }
                    completion:nil];
            break;
        case 2:
            [MGJRouter openURL:kRunningVCPageURL
                  withUserInfo:@{@"navigationVC" : self.navigationController,
                                 }
                    completion:nil];
            break;
        case 3:
            [MGJRouter openURL:kInviteVCPageURL
                  withUserInfo:@{@"navigationVC" : self.navigationController,
                                 }
                    completion:nil];
            break;
        case 4:
            [MGJRouter openURL:kPersonnalVCPageURL
                  withUserInfo:@{@"navigationVC" : self.navigationController,
                                 }
                    completion:nil];
        default:
            break;
    }
}


- (ZYLMainView *)mainView{
    if (!_mainView) {
        _mainView = [[ZYLMainView alloc] init];
        _mainView.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
    }
    return _mainView;
}


@end
