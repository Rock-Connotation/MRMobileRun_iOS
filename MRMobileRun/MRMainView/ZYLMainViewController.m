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
#import <Masonry.h>
@interface ZYLMainViewController () <MRTabBarViewDelegate>
@property (strong, nonatomic) ZYLMainView *mainView;
@property (strong, nonatomic) WeProgressCircle *progressCircle;
@property (strong, nonatomic) MRTabBar *tab;
@property (strong, nonatomic) UIButton *recordBtn;
@property (strong, nonatomic) UIButton *rankBtn;
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
    
    [self initButtons];
//    [self.view bringSubviewToFront:self.tab.tabView];
    // Do any additional setup after loading the view.
}

- (void)initButtons{
    [self.view addSubview: self.recordBtn];
    [self.view addSubview: self.rankBtn];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_offset(375);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_top).mas_offset(488);
    }];
    
    [self.rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordBtn.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(105);
    }];
}

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

#pragma mark - 点击事件
- (void)clickAvatar{
    [MGJRouter openURL:kPersonnalVCPageURL
          withUserInfo:@{@"navigationVC" : self.navigationController,
                         }
            completion:nil];
}

- (void)pushToRankView{
    [MGJRouter openURL:kRankVCPageURL
          withUserInfo:@{@"navigationVC" : self.navigationController,
                         }
            completion:nil];
}

- (void)pushToHistoryView{
    NSLog(@"pushToHistoryView");
}

#pragma mark - 懒加载
- (ZYLMainView *)mainView{
    if (!_mainView) {
        _mainView = [[ZYLMainView alloc] init];
        _mainView.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
        [_mainView.avatarBtu addTarget:self action:@selector(clickAvatar) forControlEvents:UIControlEventTouchUpInside];
        [_mainView.leaderboardBtu addTarget:self action:@selector(pushToRankView) forControlEvents:UIControlEventTouchUpInside];
        [_mainView.runingRecordBtu addTarget:self action:@selector(pushToHistoryView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainView;
}

- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc] init];
        [_recordBtn addTarget:self action:@selector(pushToHistoryView) forControlEvents:UIControlEventTouchUpInside];
        _recordBtn.backgroundColor = [UIColor clearColor];
    }
    return _recordBtn;
}

- (UIButton *)rankBtn{
    if (!_rankBtn) {
        _rankBtn = [[UIButton alloc] init];
        [_rankBtn addTarget:self action:@selector(pushToRankView) forControlEvents:UIControlEventTouchUpInside];
        _rankBtn.backgroundColor = [UIColor clearColor];
    }
    return _rankBtn;
}
@end
