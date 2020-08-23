//
//  YYZCommentViewController.m
//  MRMobileRun
//
//  Created by 杨远舟 on 2020/8/6.
//
#import "Masonry.h"
#import "YYZCommentViewController.h"
#import "ZYLPersonalViewController.h"
@interface YYZCommentViewController ()

@end

@implementation YYZCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationItem setTitle:@"意见反馈"];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 630, 350, 50)];
    saveBtn.backgroundColor = [UIColor darkGrayColor];
    [saveBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:10.0];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(self.view);
    make.left.equalTo(self.view).offset(18*kRateY);
    make.right.equalTo(self.view).offset(-18*kRateY);
    make.bottom.equalTo(self.view).offset(-160*kRateY);
    make.height.greaterThanOrEqualTo(@(50*kRateY));
    }];

    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(18, 110, 342, 100)];
    tf.borderStyle = UITextBorderStyleNone;
    tf.placeholder = @"请在此处写下你反馈的意见";
    //[tf setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
    tf.layer.cornerRadius = 13;
    tf.layer.masksToBounds = YES;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    tf.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    UIView *paddingLeftView = [[UIView alloc] init];
    CGRect frame = tf.frame;
    frame.size.width = 12;
    paddingLeftView.frame = frame;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.leftView = paddingLeftView;
    [self.view addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(self.view);
    make.left.equalTo(self.view).offset(18*kRateY);
    make.right.equalTo(self.view).offset(-18*kRateY);
    make.top.equalTo(self.view).offset(100*kRateY);
    make.height.greaterThanOrEqualTo(@(100*kRateY));
    }];

    if (@available(iOS 13.0, *)) {
        UIColor * rightColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return [UIColor whiteColor];
            } else { //深色模式
                tf.textColor = [UIColor whiteColor];
                tf.backgroundColor = [UIColor colorWithRed:75/255.0 green:76/255.0 blue:82/255.0 alpha:1];
                saveBtn.backgroundColor = [UIColor colorWithRed:222/255.0 green:223/255.0 blue:229/255.0 alpha:1];
                [saveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                UIColor *color = [UIColor whiteColor];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
                self.navigationController.navigationBar.titleTextAttributes = dict;
                
                return [UIColor colorWithRed:60/255.0 green:63/255.0 blue:67/255.0 alpha:1];
            }
        }];
        self.view.backgroundColor = rightColor; //根据当前模式(光明\暗黑)-展示相应颜色 关键是这一句
    }
}
- (void)actionBack{

  ZYLPersonalViewController *vc1 = [[ZYLPersonalViewController alloc]init];

  [self.navigationController popViewControllerAnimated:YES];



  // Do any additional setup after loading the view.

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
