//
//  SportSettingViewController.m
//  MRMobileRun
//
//  Created by 杨远舟 on 2020/8/6.
//

#import "SportSettingViewController.h"
#import "Masonry.h"
@interface SportSettingViewController () <UIGestureRecognizerDelegate>
@property(nonatomic, weak) UIButton *saveBtn;

@end

@implementation SportSettingViewController
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
    [self.navigationItem setTitle:@"系统权限设置"];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
       self.navigationController.navigationBar.tintColor = [UIColor blackColor];
       UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
       [backBtn setImage:[UIImage imageNamed:@"返回箭头4"] forState:UIControlStateNormal];
       [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
       [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
       UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
       self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 300, 345, 50)];
    saveBtn.backgroundColor = [UIColor darkGrayColor];
    [saveBtn setTitle:@"快速设置" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(actionSet) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:10.0];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(300*kRateY);
        make.width.equalTo(@(345*kRateX));
        make.height.equalTo(@(50*kRateY));
    }];
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 80, 330, 100)];
    lable1.text = @"由于系统的省电规则与后台限制，会误将约跑正在记录运动的进程杀掉。为了避免运动数据统计不准确请打开以下权限。";
    lable1.numberOfLines = 5;
    [self.view addSubview:lable1];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(25*kRateY);
        make.right.equalTo(self.view).offset(-25*kRateY);
        make.top.equalTo(self.view).offset(80*kRateY);
        //make.width.equalTo(@(330*kRateY));
        make.height.equalTo(@(100*kRateY));
    }];
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(25, 150, 330, 100)];
    lable2.text = @"白名单/自启动设置方法。";
    [lable2 setFont:[UIFont fontWithName:@"Helvetica-Bold"size:18]];
    [self.view addSubview:lable2];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25*kRateY);
        make.right.equalTo(self.view).offset(-25*kRateY);
        make.top.equalTo(self.view).offset(163*kRateY);
        make.height.equalTo(@(100*kRateY));
    }];
    
    UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(25, 190, 330, 100)];
       lable3.text = @"设置->重邮约跑->允许约跑后台刷新";
       lable3.numberOfLines = 1;
       [self.view addSubview:lable3];
    [lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.view).offset(25*kRateY);
         make.right.equalTo(self.view).offset(-25*kRateY);
         make.top.equalTo(self.view).offset(190*kRateY);
         make.height.equalTo(@(100*kRateY));
    }];
     [self changeStyle];
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    [self changeStyle];
}

- (void)changeStyle {
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            self.view.backgroundColor = [UIColor whiteColor];
           // self.tf.textColor = [UIColor blackColor];

           // self.tf.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
            self.saveBtn.backgroundColor = [UIColor darkGrayColor];
            [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:UIColor.blackColor forKey:NSForegroundColorAttributeName];
               self.navigationController.navigationBar.titleTextAttributes = dict;
               self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        } else { //深色模式
           // self.tf.textColor = [UIColor whiteColor];

           // self.tf.backgroundColor = [UIColor colorWithRed:75/255.0 green:76/255.0 blue:82/255.0 alpha:1];
            self.saveBtn.backgroundColor = [UIColor colorWithRed:222/255.0 green:223/255.0 blue:229/255.0 alpha:1];
            [self.saveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            UIColor *color = [UIColor whiteColor];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
            self.navigationController.navigationBar.titleTextAttributes = dict;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

            self.view.backgroundColor = [UIColor colorWithRed:60/255.0 green:63/255.0 blue:67/255.0 alpha:1];
        } //根据当前模式(光明\暗黑)-展示相应颜色 关键是这一句
    } //根据当前模式(光明\暗黑)-展示相应颜色 关键是这一句
}

- (void)back {
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
