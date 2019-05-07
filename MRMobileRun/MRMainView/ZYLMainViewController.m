//
//  ZYLMainViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLMainViewController.h"
#import "ZYLMainView.h"

@interface ZYLMainViewController ()
@property (strong, nonatomic) ZYLMainView *mainView;
@property (strong, nonatomic) WeProgressCircle *progressCircle;
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
    // Do any additional setup after loading the view.
}
//隐藏navigationBar

- (ZYLMainView *)mainView{
    if (!_mainView) {
        _mainView = [[ZYLMainView alloc] init];
        _mainView.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
    }
    return _mainView;
}

@end
