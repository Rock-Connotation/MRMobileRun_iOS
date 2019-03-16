//
//  MRMainTabBarController.m
//  MRMobileRun
//
//  Created by liangxiao on 2019/3/5.
//

#import "MRMainTabBarController.h"
#import "MRHomeViewController.h"

@interface MRMainTabBarController ()

@end

@implementation MRMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructTabItems];
    // Do any additional setup after loading the view.
}

- (void)constructTabItems
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    NSMutableArray *vcs = [NSMutableArray array];

    MRHomeViewController *homeVC = [[MRHomeViewController alloc] init];
    homeVC.title = @"home";
    [vcs addObject:homeVC];

    self.viewControllers = vcs;
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
