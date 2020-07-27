//
//  MGDDataViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/27.
//

#import "MGDDataViewController.h"



@interface MGDDataViewController ()

@end

@implementation MGDDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _backScrollView = [[UIScrollView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = bottomColor;
        _backScrollView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        // Fallback on earlier versions
    }
    if (kIs_iPhoneX) {
        _backScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeigth - 100);
        _twoBtnView = [[MGDButtonsView alloc] initWithFrame:CGRectMake(0, 712, screenWidth, 100)];
        _dataView = [[MGDDataView alloc] initWithFrame:CGRectMake(0, 722, screenWidth, 710)];
    }else {
        _backScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeigth - 66);
         _twoBtnView = [[MGDButtonsView alloc] initWithFrame:CGRectMake(0, 601, screenWidth, 66)];
        _dataView = [[MGDDataView alloc] initWithFrame:CGRectMake(0, 611, screenWidth, 710)];

    }
    
    [_twoBtnView.overBtn addTarget:self action:@selector(showData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_twoBtnView];
    _backScrollView.contentSize = CGSizeMake(screenWidth, 1432);
    [self.view addSubview:_backScrollView];
    
    _overView = [[MGDOverView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeigth)];
    [self.backScrollView addSubview:_overView];
    
    [self.backScrollView addSubview:_dataView];
    
}

- (void)showData {
    
}

@end
