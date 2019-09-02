//
//  ZYLMainViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLMainViewController.h"
#import "ZYLMainView.h"
#import "ZYLStartRunningButton.h"
#import <MGJRouter.h>
#import <Masonry.h>
@interface ZYLMainViewController ()
@property (strong, nonatomic) ZYLMainView *mainView;
@property (strong, nonatomic) WeProgressCircle *progressCircle;
@property (strong, nonatomic) ZYLStartRunningButton *runningBtn;
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

    
    [self initButtons];
//    [self.view bringSubviewToFront:self.tab.tabView];
    // Do any additional setup after loading the view.
    
}

- (void)initButtons{
    [self.view addSubview: self.recordBtn];
    [self.view addSubview: self.rankBtn];
    [self.view addSubview: self.runningBtn];
    

    
    if (kIs_iPhoneX) {
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
        [self.runningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(-40);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
    }else{
        [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo (self.view).with.insets(UIEdgeInsetsMake(750.0/1334.0*screenHeigth, 0, 479.0/1334.0*screenHeigth, 0));
        }];
        
        [self.rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo (self.view).with.insets(UIEdgeInsetsMake(914.0/1334.0*screenHeigth, 0, 266.0/1334.0*screenHeigth, 0));
        }];
        [self.runningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(-15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
        }];
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

- (void)didClickRunningButton{
    [MGJRouter openURL:kRunningVCPageURL
          withUserInfo:@{@"navigationVC" : self.navigationController,
                         }
            completion:nil];
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

- (ZYLStartRunningButton *)runningBtn{
    if (!_runningBtn) {
        _runningBtn = [[ZYLStartRunningButton alloc] init];
        [_runningBtn addTarget: self action:@selector(didClickRunningButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _runningBtn;
}
@end
