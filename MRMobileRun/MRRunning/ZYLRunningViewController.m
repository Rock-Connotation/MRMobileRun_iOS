//
//  ZYLRunningViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/2.
//

/*
 *定位不是很准
 *后面再改个sdk
 */

#import "RunMainPageCV.h"
#import "ZYLRunningViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Masonry.h>
#import "HttpClient.h"
@interface ZYLRunningViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
{ NSTimer *timer;
 NSInteger totalSeconds;
}
@property (nonatomic, strong) UILabel *NumberLabel; //数字倒数框
@property (nonatomic, strong) UIButton *BeginBtn;  //直接开始
@property (nonatomic, strong) UIView *btnView;
@end

@implementation ZYLRunningViewController
- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor colorWithRed:100/255.0 green:104/255.0 blue:111/255.0 alpha:1.0];
    [self Add];
    
    //定时器
    totalSeconds = 3;
if (!timer) {
       timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeLabelStr) userInfo:nil repeats:YES];
       [timer fire];
   }
}

//添加控件
- (void)Add{
    //数字倒数框
    self.NumberLabel = [[UILabel alloc] init];
    [self.view addSubview:self.NumberLabel];
    [self.NumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(92, 195));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(195);
        
    }];

//    self.NumberLabel.font = [UIFont fontWithName:@"PingFangSC" size: 160];
    [self.NumberLabel setFont:[UIFont systemFontOfSize:160]];
    self.NumberLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.NumberLabel.textAlignment = NSTextAlignmentCenter;
     self.NumberLabel.text = @"0";
    
    
    
    //直接开始那一块儿不同颜色的view
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.NumberLabel);
            make.top.equalTo(self.NumberLabel.mas_bottom).offset(91);
            make.size.mas_equalTo(CGSizeMake(168, 52));
        }];
    self.btnView = view;
    
    self.BeginBtn = [[UIButton alloc] init];
    [self.view addSubview:self.BeginBtn];
    [self.BeginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.size.equalTo(view);
    }];
    [self.BeginBtn setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    self.BeginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC" size: 16];
    [self.BeginBtn setTitle:@"直接开始" forState:UIControlStateNormal];
    [self.BeginBtn addTarget:self action:@selector(Begin) forControlEvents:UIControlEventTouchUpInside];

}
//随计时器改变label里面的数字
-(void)changeLabelStr
{  // int seconds = totalSeconds - 1;
    self.NumberLabel.text =[NSString stringWithFormat:@"%ld",(long)totalSeconds--];
//    totalSeconds --;
    if (totalSeconds == -1) {
        [timer invalidate];
        self.NumberLabel.text = @"Go";
        [self.BeginBtn removeFromSuperview];
        [self.btnView removeFromSuperview];
        RunMainPageCV *cv = [[RunMainPageCV alloc] init];
        [self.navigationController pushViewController:cv animated:YES];
    }

}

//直接开始功能
- (void)Begin{
    //切换到Go图片，并且跳转到基础界面
    [timer invalidate];
    self.NumberLabel.text = @"Go";
            RunMainPageCV *cv = [[RunMainPageCV alloc] init];
            [self.navigationController pushViewController:cv animated:YES];
    
}

@end
