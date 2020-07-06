//
//  ZYLRankViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/29.
//

#import "ZYLRankViewController.h"
#import "XIGSegementView.h"
#import "ZYLAcademyRankViewController.h"
#import "ZYLSchoolRankViewController.h"
#import "YYkit.h"
@interface ZYLRankViewController ()

@end

@implementation ZYLRankViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZYLSchoolRankViewController *view1 = [[ZYLSchoolRankViewController  alloc]init];
    view1.title = @"校园排行";
    ZYLAcademyRankViewController *view2 = [[ZYLAcademyRankViewController alloc]init];
    view2.title = @"学院排行";
    NSArray *viewArray = @[view1,view2];
  
    XIGSegementView *segementView = [[XIGSegementView alloc]initWithFrame:CGRectMake(0, 50, screenWidth, self.view.height - NVGBARHEIGHT - STATUSBARHEIGHT) andControllers:viewArray WithStyle:@"systom"];
    segementView.titleTextFocusColor = [UIColor colorWithHexString:@"#333739"];
    segementView.titleTextNormalColor = [UIColor colorWithHexString:@"#B2B2B2"];
    [self.view addSubview:segementView];

    // Do any additional setup after loading the view.
}



@end
