//
//  YYZCommentViewController.m
//  MRMobileRun
//
//  Created by 杨远舟 on 2020/8/6.
//

#import "YYZCommentViewController.h"
#import "ZYLPersonalViewController.h"
@interface YYZCommentViewController ()

@end

@implementation YYZCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationItem setTitle:@"意见反馈"];

    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 630, 350, 50)];

    saveBtn.backgroundColor = [UIColor darkGrayColor];

    [saveBtn setTitle:@"提交反馈" forState:UIControlStateNormal];

    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [saveBtn addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];

    [saveBtn.layer setMasksToBounds:YES];

    [saveBtn.layer setCornerRadius:10.0];

    [self.view addSubview:saveBtn];

     

    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(18, 110, 342, 100)];

    tf.borderStyle = UITextBorderStyleRoundedRect;

    tf.placeholder = @"请在此处写下你反馈的意见";

    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;

    tf.backgroundColor = [UIColor lightTextColor];

    [self.view addSubview:tf];
    
    if (@available(iOS 13.0, *)) {
        UIColor * rightColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return [UIColor whiteColor];
            } else { //深色模式
                tf.textColor = [UIColor whiteColor];
                tf.backgroundColor = [UIColor darkGrayColor];
                return [UIColor blackColor];
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
