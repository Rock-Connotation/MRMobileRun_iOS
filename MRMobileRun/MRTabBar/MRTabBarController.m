


//
//  MRTabBarController.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/11/20.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRTabBarController.h"

@interface MRTabBarController ()<UITabBarDelegate>
//@property(nonatomic) MRHomePageViewController *homePageVC;
//@property(nonatomic) MRPersonaInformationViewController *personalInformationVC;
//@property(nonatomic) MRRankViewController *rankVC;
//@property(nonatomic) MRRunningViewController *runningVC;
@end

@implementation MRTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    //隐藏分割线
    self.tabBar.hidden = YES; //隐藏原先的tabBar
//    self.homePageTabBar = [[MRHomePageTabBar alloc]initWithFrame:CGRectMake(0, screenHeigth/1334.0 *123.0, 0, 0)];

//    self.homePageVC = [[MRHomePageViewController alloc]init];
//    self.personalInformationVC = [[MRPersonaInformationViewController alloc] init];
//    self.runningVC = [[MRRunningViewController alloc]init];
//    self.rankVC = [[MRRankViewController alloc]init];
//
//    UINavigationController *homePageNav =[[UINavigationController alloc]initWithRootViewController:self.homePageVC];
//    UINavigationController *personalInformationNav =[[UINavigationController alloc]initWithRootViewController:self.personalInformationVC];
//    UINavigationController *runningNav =[[UINavigationController alloc]initWithRootViewController:self.runningVC];
//    UINavigationController *rankNav =[[UINavigationController alloc]initWithRootViewController:self.rankVC];
//    UINavigationController *rankNav1 =[[UINavigationController alloc]initWithRootViewController:self.rankVC];
//
//    [self addChildViewController:homePageNav];
//    [self addChildViewController:rankNav];
//    [self addChildViewController:runningNav];
//    [self addChildViewController:personalInformationNav];
//    [self addChildViewController:rankNav1];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.tabBar.frame;
//    frame.size.height = screenHeigth/1334.0 *123.0;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    self.tabBar.frame = frame;
    self.tabBar.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1];
}

- (void)addButtonAction{
   
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    NSLog(@"\n\n\n\n\n%s\n\n\n\n\n","click");
    
    self.homePageTabBar.hidden = YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

@end
