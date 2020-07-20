//
//  RunMainPageCV.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/10.
//

#import "RunMainPageCV.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Masonry.h>
#import <UIKit/UIKit.h>
#import "RunningMainPageView.h"

@interface RunMainPageCV ()<MAMapViewDelegate>
@property (nonatomic, strong) RunningMainPageView *Mainview;
@property (nonatomic, assign) CGFloat yyy;
@end

@implementation RunMainPageCV

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Mainview = [[RunningMainPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.Mainview];
    [self.Mainview mainRunView];
    [self btnFunction];
    self.Mainview.mapView.delegate = self;
    
    //拖拽底部视图的高度
    UIGestureRecognizer *pan = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    [self.Mainview.dragLabel addGestureRecognizer:pan];
    self.Mainview.dragLabel.userInteractionEnabled = YES;
}

//拖拽方法：
- (void)dragAction:(UIGestureRecognizer *)pan{
    //
    if (pan.state == UIGestureRecognizerStateBegan) {
           
           // 用来保存初始高度
        _yyy = CGRectGetMaxY(self.Mainview.topView.frame);
    }else if (pan.state == UIGestureRecognizerStateChanged){
        CGPoint point = [pan locationInView:self.view];
                CGFloat y = point.y + _yyy;
        
    }else if (pan.state == UIGestureRecognizerStateEnded){

        
        
    }
}

#pragma mark- 按钮的方法
//按钮方法
- (void)btnFunction{
    //暂停按钮
    [self.Mainview.pauseBtn addTarget:self action:@selector(pauseMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //锁屏按钮
    [self.Mainview.lockBtn addTarget:self action:@selector(lockMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //解锁按钮
    [self.Mainview.unlockBtn addTarget:self action:@selector(unlockMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //继续按钮
    [self.Mainview.continueBtn addTarget:self action:@selector(continueMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //结束按钮
    [self.Mainview.endtBtn addTarget:self action:@selector(endMethod) forControlEvents:UIControlEventTouchUpInside];
}

//点击暂停按钮的方法
- (void)pauseMethod{
    self.Mainview.pauseBtn.hidden = YES;
    self.Mainview.lockBtn.hidden = YES;
    self.Mainview.endtBtn.hidden = NO;
     self.Mainview.continueBtn.hidden = NO;
}

//点击锁屏按钮方法
- (void)lockMethod{
    self.Mainview.pauseBtn.hidden = YES;
    self.Mainview.lockBtn.hidden = YES;
    self.Mainview.unlockBtn.hidden = NO;
}
//长按解锁按钮方法
- (void)unlockMethod{
    //
}
//点击继续按钮方法
- (void)continueMethod{
    self.Mainview.unlockBtn.hidden = YES;
    self.Mainview.endtBtn.hidden = YES;
    self.Mainview.continueBtn.hidden = YES;
    self.Mainview.pauseBtn.hidden = NO;
    self.Mainview.lockBtn.hidden = NO;
    
}

//长按结束按钮方法
- (void)endMethod{
    //
}


@end
