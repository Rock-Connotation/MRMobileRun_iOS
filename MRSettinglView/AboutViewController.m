//
//  AboutViewController.m
//  MRMobileRun
//
//  Created by 杨远舟 on 2020/8/6.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"关于约跑"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(125, 170, 130, 130)];
    imageView.image = [UIImage imageNamed:@"约跑icon"];
    [self.view addSubview:imageView];
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(145, 305,100, 50)];
    lable2.text = @"重邮约跑";
    [lable2 setFont:[UIFont fontWithName:@"Helvetica-Bold"size:23]];
    [self.view addSubview:lable2];
    
    UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(147, 330, 100, 50)];
    lable3.text = @"Version 2.0.1";
    lable3.textColor = [UIColor lightGrayColor];
    lable3.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lable3];
    
    UILabel *lable4 = [[UILabel alloc]initWithFrame:CGRectMake(70, 655, 280, 50)];
    lable4.text = @"CopyRight@2013-2020 All Reserved";
    lable4.textColor = [UIColor lightGrayColor];
    lable4.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lable4];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(110, 630, 80, 30)];
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 setTitle:@"检查更新" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(actionAlert1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(185, 630, 90, 30)];
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 setTitle:@"| 使用条款" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(actionAlert2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    if (@available(iOS 13.0, *)) {
        UIColor * rightColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) { //浅色模式
                return [UIColor whiteColor];
            } else { //深色模式
                return [UIColor blackColor];
            }
        }];
        self.view.backgroundColor = rightColor; //根据当前模式(光明\暗黑)-展示相应颜色 关键是这一句
    }

}
- (void)actionAlert1{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已是最新版本,无需更新"message:@""preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)actionAlert2{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"使用条款"message:@"版权归红岩网校所有,感谢您的使用"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];

    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
