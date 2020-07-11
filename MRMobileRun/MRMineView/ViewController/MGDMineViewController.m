//
//  MGDMineViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/10.
//

#import "MGDMineViewController.h"
#import "MGDTopView.h"
#import "MGDBaseInfoView.h"

@interface MGDMineViewController ()

@end

@implementation MGDMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0];
    MGDTopView *topview = [[MGDTopView alloc] init];
    topview.frame = CGRectMake(0,0,screenWidth,136);
    [self.view addSubview:topview];
    
    MGDBaseInfoView *baseView = [[MGDBaseInfoView alloc] init];
    baseView.frame = CGRectMake(0,136,screenWidth,117);

    [self.view addSubview:baseView];
}



@end

