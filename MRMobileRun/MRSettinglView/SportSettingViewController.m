//
//  SportSettingViewController.m
//  MRMobileRun
//
//  Created by 杨远舟 on 2020/8/6.
//

#import "SportSettingViewController.h"

@interface SportSettingViewController ()

@end

@implementation SportSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"系统权限设置"];

    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 300, 345, 50)];
    saveBtn.backgroundColor = [UIColor darkGrayColor];
    [saveBtn setTitle:@"快速设置" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(actionSet) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:10.0];
    [self.view addSubview:saveBtn];
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 80, 330, 100)];
    lable1.text = @"由于系统的省电规则与后台限制，会误将约跑正在记录运动的进程杀掉。为了避免运动数据统计不准确请打开以下权限。";
    lable1.numberOfLines = 5;
    [self.view addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(25, 150, 330, 100)];
    lable2.text = @"白名单/自启动设置方法。";
    [lable2 setFont:[UIFont fontWithName:@"Helvetica-Bold"size:18]];
    [self.view addSubview:lable2];
    
    UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(25, 190, 330, 100)];
       lable3.text = @"设置->重邮约跑->允许约跑后台刷新";
       lable3.numberOfLines = 1;
       [self.view addSubview:lable3];
}

- (void)actionSet{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {

        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {

        }];

    }else{

      //[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]] 应用标识

        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]]];

        [[UIApplication sharedApplication]openURL:url];

    }
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
