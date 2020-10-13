#import "YYZTextViewController.h"
#import "ZYLPersonalViewController.h"
#import "Masonry.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <AFNetworking.h>
#import "ZYLChangeNickname.h"

@interface YYZTextViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, weak)UITextView *tf;
@property(nonatomic, weak) UIButton *saveBtn;
@property(nonatomic, weak)UILabel *placeHolder;
@end

@implementation YYZTextViewController
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}
-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
        //设置右滑返回的手势
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    //handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; //设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; //禁止系统自带的滑动手势
}

- (void)handleNavigationTransition:(id)sender
{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}
- (void)viewDidLoad {
  [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
       self.navigationController.navigationBar.tintColor = [UIColor blackColor];
       UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
       [backBtn setImage:[UIImage imageNamed:@"返回箭头4"] forState:UIControlStateNormal];
       [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
       [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
       UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
       self.navigationItem.leftBarButtonItem = backItem;
    
  UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 630, 350, 50)];
  //UIButton *saveBtn = [[UIButton alloc]init];
  saveBtn.backgroundColor = [UIColor darkGrayColor];

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
    self.saveBtn = saveBtn;
//输入框
    
    unsigned int count = 0;
       Ivar *ivars = class_copyIvarList([UITextView class], &count);
       
       for (int i = 0; i < count; i++) {
           Ivar ivar = ivars[i];
           const char *name = ivar_getName(ivar);
           NSString *objcName = [NSString stringWithUTF8String:name];
           NSLog(@"%d : %@",i,objcName);
       }
  UITextView *tf = [[UITextView alloc]initWithFrame:CGRectMake(18, 110, 342, 100)];
  tf.layer.cornerRadius = 13;//设置边框圆角
  tf.layer.masksToBounds = YES;
  tf.textContainerInset = UIEdgeInsetsMake(15, 10, 10, 10);//设置边界间距
    
    if (self.changeNickname) {
        [self.navigationItem setTitle:@"修改昵称"];
       [saveBtn setTitle:@"保存昵称" forState:UIControlStateNormal];
        NSUserDefaults  *user = [NSUserDefaults standardUserDefaults];
        NSString *signature = [user objectForKey:@"nickname"];
        tf.text=signature;
    } else {
        [self.navigationItem setTitle:@"个性签名"];
        [saveBtn setTitle:@"保存签名" forState:UIControlStateNormal];
        NSUserDefaults  *user = [NSUserDefaults standardUserDefaults];
        NSString *signature = [user objectForKey:@"signature"];
        tf.text=signature;
    }
  tf.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
  [self.view addSubview:tf];
    self.tf=tf;
    
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
       [topView setBarStyle:UIBarStyleDefault];
       UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
       UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
       NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];

       [topView setItems:buttonsArray];
       [tf setInputAccessoryView:topView];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    if (self.changeNickname) {
        placeHolderLabel.text = @"请在此处写下你的昵称";
    } else {
        placeHolderLabel.text = @"请在此处写下你的个性签名";
    }
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [tf addSubview:placeHolderLabel];
    // same font
    tf.font = [UIFont systemFontOfSize:16.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:16.f];
    [tf setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
  [tf mas_makeConstraints:^(MASConstraintMaker *make) {
      //make.centerX.equalTo(self.view);
  make.left.equalTo(self.view).offset(18*kRateY);
  make.right.equalTo(self.view).offset(-18*kRateY);
  make.top.equalTo(self.mas_topLayoutGuideBottom).offset(20*kRateY);
  make.height.greaterThanOrEqualTo(@(100*kRateY));
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
            self.tf.textColor = [UIColor blackColor];

            self.tf.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
            self.saveBtn.backgroundColor = [UIColor darkGrayColor];
            [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:UIColor.blackColor forKey:NSForegroundColorAttributeName];
               self.navigationController.navigationBar.titleTextAttributes = dict;
               self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        } else { //深色模式
            self.tf.textColor = [UIColor whiteColor];

            self.tf.backgroundColor = [UIColor colorWithRed:75/255.0 green:76/255.0 blue:82/255.0 alpha:1];
            self.saveBtn.backgroundColor = [UIColor colorWithRed:222/255.0 green:223/255.0 blue:229/255.0 alpha:1];
            [self.saveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            UIColor *color = [UIColor whiteColor];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
            self.navigationController.navigationBar.titleTextAttributes = dict;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

            self.view.backgroundColor = [UIColor colorWithRed:60/255.0 green:63/255.0 blue:67/255.0 alpha:1];
        } //根据当前模式(光明\暗黑)-展示相应颜色 关键是这一句
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}


- (void) back {
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)actionBack{

    if (self.changeNickname) {
        [self changeNicknameReq];
    } else {
        [self saveSignature];
    }

  // Do any additional setup after loading the view.

}

- (void)changeNicknameReq
{
    [ZYLChangeNickname uploadChangedNickname:self.tf.text];
}

- (void)saveSignature
{
    NSUserDefaults *user2 = [NSUserDefaults standardUserDefaults];
    NSString *token = [user2 objectForKey:@"token"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue: token forHTTPHeaderField: @"token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
      NSDictionary *param = @{@"token": token , @"signature": self.tf.text};
    //NSDictionary *param = @{@"token": token, @"nickname": nickname};
    

    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/modify/signature" parameters: param constructingBodyWithBlock:nil success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"success");
          NSUserDefaults  *user = [NSUserDefaults standardUserDefaults];
          [user setObject:self.tf.text forKey:@"signature"];
          [user synchronize];
          [self.navigationController popViewControllerAnimated:YES];

        }  failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"=====%@", error); // 404  500
              //MBProgressHUD  服务器异常 请稍后重试
          }];
}

-(void) dismissKeyBoard{
    [self.tf resignFirstResponder];
}

/*

\#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

\- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  // Get the new view controller using [segue destinationViewController].

  // Pass the selected object to the new view controller.

}

*/



@end
