//
//  MRHomeViewController.m
//  MRMobileRun
//
//  Created by liangxiao on 2019/3/5.
//
#import <MGJRouter.h>
#import "MRRouterPublic.h"

#import "MRHomeViewController.h"

@interface MRHomeViewController ()

@end

@implementation MRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"button" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 100, 70);
    [btn addTarget:self action:@selector(tapBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)tapBtn {
    
    //不同 Module 不需要再相互 import 各自的viewcontroller 。
    //所有 module 引入"MRRouterPublic.h" 通过 URL 来跳转，实现解耦，可以每人负责一个module
//    [MGJRouter openURL:kTestViewControllerPageURL withUserInfo:nil completion:^(id result) {
//        NSLog(@"打开了 testVC");
//    }];
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
