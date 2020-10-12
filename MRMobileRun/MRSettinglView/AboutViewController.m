//
//  AboutViewController.m
//  MRMobileRun
//
//  Created by 杨远舟 on 2020/8/6.
//

#import "AboutViewController.h"
#import "Masonry.h"
@interface AboutViewController () <UIGestureRecognizerDelegate>

@end

@implementation AboutViewController

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}
-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    //handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; //设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; //禁止系统自带的滑动手势
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

- (void)handleNavigationTransition:(id)sender
{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES; //禁止系统自带的滑动手势
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"关于约跑"];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setImage:[UIImage imageNamed:@"返回箭头4"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(125, 170, 130, 130)];
    imageView.image = [UIImage imageNamed:@"约跑"];
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOffset= CGSizeMake(0,0);//偏移距离
    imageView.layer.shadowOpacity=0.03;//不透明度
    imageView.layer.shadowRadius=10.0;//半径
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(170*kRateY);
        make.width.equalTo(@(130*kRateY));
        make.height.equalTo(@(130*kRateY));
    }];
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(145, 305,100, 50)];
    lable2.text = @"重邮约跑";
    lable2.textAlignment = NSTextAlignmentCenter;
    [lable2 setFont:[UIFont fontWithName:@"Helvetica-Bold"size:23]];
    [self.view addSubview:lable2];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(305*kRateY);
        make.width.equalTo(@(100*kRateX));
        make.height.equalTo(@(50*kRateY));
    }];
    
    UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(147, 330, 100, 50)];
    lable3.text = @"Version 2.0.1";
    lable3.textAlignment = NSTextAlignmentCenter;
    lable3.textColor = [UIColor lightGrayColor];
    lable3.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lable3];
    [lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(330*kRateY);
        make.width.equalTo(@(100*kRateX));
        make.height.equalTo(@(50*kRateY));
    }];
    
    UILabel *lable4 = [[UILabel alloc]initWithFrame:CGRectMake(70, 655, 280, 50)];
    lable4.text = @"CopyRight@2013-2020 All Reserved";
    lable4.textAlignment = NSTextAlignmentCenter;
    lable4.textColor = [UIColor lightGrayColor];
    lable4.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lable4];
    [lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(665*kRateY);
        make.width.equalTo(@(280*kRateX));
        make.height.equalTo(@(50*kRateY));
    }];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(110, 630, 80, 30)];
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 setTitle:@"检查更新" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(actionAlert1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(110*kRateX);
        make.top.equalTo(self.view).offset(630*kRateY);
        make.width.equalTo(@(80*kRateX));
        make.height.equalTo(@(30*kRateY));
    }];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(185, 630, 90, 30)];
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 setTitle:@"| 使用条款" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(actionAlert2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(185*kRateX);
        make.top.equalTo(self.view).offset(630*kRateY);
        make.width.equalTo(@(90*kRateX));
        make.height.equalTo(@(30*kRateY));
    }];
    
      [self changeStyle];
    }

    - (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
    {
        [super traitCollectionDidChange:previousTraitCollection];
        [self changeStyle];
    }

    - (void)changeStyle {
        if (@available(iOS 13.0, *)) {
            if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                self.view.backgroundColor = [UIColor whiteColor];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:UIColor.blackColor forKey:NSForegroundColorAttributeName];
                   self.navigationController.navigationBar.titleTextAttributes = dict;
                   self.navigationController.navigationBar.tintColor = [UIColor blackColor];
            } else { //深色模式
                
                UIColor *color = [UIColor whiteColor];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
                self.navigationController.navigationBar.titleTextAttributes = dict;
                self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

                self.view.backgroundColor = [UIColor colorWithRed:60/255.0 green:63/255.0 blue:67/255.0 alpha:1];
            } //根据当前模式(光明\暗黑)-展示相应颜色 关键是这一句
        }
    }
- (void) back {
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
