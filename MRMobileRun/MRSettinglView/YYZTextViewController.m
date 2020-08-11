<<<<<<< HEAD
#import "YYZTextViewController.h"

#import "ZYLPersonalViewController.h"



@interface YYZTextViewController ()



@end



@implementation YYZTextViewController



- (void)viewDidLoad {

  [super viewDidLoad];



  [self.navigationItem setTitle:@"个性签名"];

  UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 630, 350, 50)];

  saveBtn.backgroundColor = [UIColor darkGrayColor];

  [saveBtn setTitle:@"保存签名" forState:UIControlStateNormal];

  [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

  [saveBtn addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];

  [saveBtn.layer setMasksToBounds:YES];

  [saveBtn.layer setCornerRadius:10.0];

  [self.view addSubview:saveBtn];

   

  UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(18, 110, 342, 100)];

  tf.borderStyle = UITextBorderStyleRoundedRect;

  tf.placeholder = @"请在此处写下你的个性签名";

  tf.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;

  tf.backgroundColor = [UIColor lightTextColor];

  [self.view addSubview:tf];

}

- (void)actionBack{

  ZYLPersonalViewController *vc1 = [[ZYLPersonalViewController alloc]init];

  [self.navigationController popViewControllerAnimated:YES];



  // Do any additional setup after loading the view.

}



/*

\#pragma mark - Navigation



// In a storyboard-based application, you will often want to do a little preparation before navigation

\- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  // Get the new view controller using [segue destinationViewController].

  // Pass the selected object to the new view controller.

}

*/



=======
//
//  YYZTextViewController.m
//  MRMobileRun
//
//  Created by 杨远舟 on 2020/7/31.
//

#import "YYZTextViewController.h"

@interface YYZTextViewController ()

@end

@implementation YYZTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

>>>>>>> 0de4443aaec289ccce590da323197f5c25aeb520
@end
