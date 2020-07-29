//
//  MGDDataViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/27.
//

#import "MGDDataViewController.h"

@interface MGDDataViewController () <UIGestureRecognizerDelegate,MGDShareViewDelegate>

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
        _twoBtnView = [[MGDButtonsView alloc] initWithFrame:CGRectMake(0,  screenHeigth - 100, screenWidth, 100)];
        _dataView = [[MGDDataView alloc] initWithFrame:CGRectMake(0, screenHeigth - 100 + 10, screenWidth, 710)];
    }else {
        _backScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeigth - 66);
         _twoBtnView = [[MGDButtonsView alloc] initWithFrame:CGRectMake(0, screenHeigth - 66, screenWidth, 66)];
        _dataView = [[MGDDataView alloc] initWithFrame:CGRectMake(0, screenHeigth - 66 + 10, screenWidth, 710)];

    }
    
    [_twoBtnView.overBtn addTarget:self action:@selector(showData) forControlEvents:UIControlEventTouchUpInside];
    [_twoBtnView.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_twoBtnView];
    _backScrollView.contentSize = CGSizeMake(screenWidth, 1432);
    [self.view addSubview:_backScrollView];
    
    _overView = [[MGDOverView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeigth)];
    [self.backScrollView addSubview:_overView];
    [self.backScrollView addSubview:_dataView];
    
    UITapGestureRecognizer *backGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backevent:)];
    backGesture.delegate = self;
    [self.shareView.backView addGestureRecognizer:backGesture];
}

- (void)showData {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)share {
    _shareView = [[MGDShareView alloc] initWithShotImage:@"" logoImage:@"" QRcodeImage:@""];
    [self.view addSubview:_shareView];
    [_shareView.cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backevent:(UIGestureRecognizer *)sender {
    NSLog(@"1111");
}


- (void)back {
    [UIView animateWithDuration:0.3 animations:^{
        [self.shareView removeFromSuperview];
    }];
}

//获取截屏图片
- (UIImage *)getCurrentScreenShot{
 
    UIGraphicsBeginImageContextWithOptions([[[UIApplication sharedApplication] keyWindow] bounds].size, NO, 0.0);
    [[[UIApplication sharedApplication] keyWindow].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    return image;
}

- (NSArray * _Nullable)platformImageArray:(NSString * _Nullable)imageArray {
    return @[@"保存图片",@"QQ",@"QQ空间",@"微信",@"朋友圈"];
}

- (NSArray * _Nullable)platformTitleArray:(NSString * _Nullable)titleArray {
    return @[@"保存图片",@"QQ",@"QQ空间",@"微信",@"朋友圈"];
}


@end
