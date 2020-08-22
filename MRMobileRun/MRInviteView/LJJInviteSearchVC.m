//
//  LJJInviteSearchVC.m
//  MRMobileRun
//
//  Created by J J on 2019/5/15.
//

#import "LJJInviteSearchVC.h"
#import "LJJInviteSearchView.h"
#import "LJJInviteRunModel.h"
#import "LJJInviteSearchResultViewController.h"
#import "ZYLMainViewController.h"
#import "LJJSearchedVC.h"
#import "LJJInviteRunVC.h"
#import <MGJRouter.h>
@interface LJJInviteSearchVC ()
@property (nonatomic, strong) LJJInviteSearchView *searchView;
@end

@implementation LJJInviteSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchView = [[LJJInviteSearchView alloc] init];
    [self showSearchView:self.searchView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)pressBtn
{
    ZYLMainViewController *mainVC = [[ZYLMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController: mainVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    NSLog(@"succeed");
}

- (void)showSearchView:(LJJInviteSearchView *)VC
{
    //背景修饰图
    VC.roundBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景修饰圆"]];
    VC.roundBack.frame = CGRectMake(0, 0, screenWidth * 0.6717, screenHeigth * 0.5910045);
    [self.view addSubview:VC.roundBack];
    
    //邀约检索底板
    VC.searchBoard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"邀约检索框底板"]];
    VC.searchBoard.userInteractionEnabled = YES;
    VC.searchBoard.frame = CGRectMake(screenWidth * 0.053, screenHeigth * 0.1754, screenWidth * 0.892, screenHeigth * 0.39);

    //设置返回按钮
    VC.whiteBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回箭头_白"]];
    
    [self.view addSubview:VC.whiteBack];
    
    //设置返回按钮手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressBtn)];
    VC.whiteBack.userInteractionEnabled = YES;
    [VC.whiteBack addGestureRecognizer:gesture];
    
    //检索板label
    VC.loading = [[UILabel alloc] init];
    VC.loading.text = @"提示:约跑邀约一次只能邀请1至4位小伙伴哦～";
    VC.loading.frame = CGRectMake(0, screenHeigth * 0.305097, screenWidth * 0.892, screenHeigth * 0.0247376);
    VC.loading.textAlignment = NSTextAlignmentCenter;
    VC.loading.textColor = [UIColor grayColor];
    [VC.searchBoard addSubview:VC.loading];
    
    _inviteTextField = [[UITextField alloc] initWithFrame:CGRectMake(screenWidth * 0.10666, screenHeigth * 0.2248, screenWidth * 0.5, screenHeigth * 0.0375)];
    NSString *holderText = @"请输入学号";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName value:[LJJInviteRunVC colorWithHexString:@"#D4D8EA"] range:NSMakeRange(0, holderText.length)];
    _inviteTextField.textColor = [LJJInviteRunVC colorWithHexString:@"#6F7584"];
    _inviteTextField.attributedPlaceholder = placeholder;
    _inviteTextField.borderStyle = UITextBorderStyleNone;
    _inviteTextField.keyboardType = UIKeyboardTypeNumberPad;
    [VC.searchBoard addSubview:_inviteTextField];
    
    VC.flowBall01 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"输入框填入线"]];
    VC.flowBall01.frame = CGRectMake(screenWidth * 0.10666, screenHeigth * 0.2624, screenWidth * 0.6786666, screenHeigth * 0.00149925);
    [VC.searchBoard addSubview:VC.flowBall01];
    
    VC.inviteTextCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [VC.inviteTextCancel setImage:[UIImage imageNamed:@"取消输入"] forState:UIControlStateNormal];
    [VC.inviteTextCancel addTarget:self action:@selector(pressBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    VC.inviteTextCancel.frame = CGRectMake(screenWidth * 0.7853266 - screenHeigth * 0.03, screenHeigth * 0.2249, screenHeigth * 0.033, screenHeigth * 0.033);
    [VC.searchBoard addSubview:VC.inviteTextCancel];
    [self.view addSubview:VC.searchBoard];
    
    //头像
    VC.loadIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"加载icon"]];
    VC.loadIcon.frame = CGRectMake(screenWidth * 326.0/750, screenHeigth * 314.0/1330.0, screenWidth *118.0/750, screenWidth *118.0/750);
    [self.view addSubview:VC.loadIcon];
    
    [VC.cancel removeFromSuperview];
    VC.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [VC.cancel setImage:[UIImage imageNamed:@"下一步按钮"] forState:UIControlStateNormal];
    VC.cancel.frame = CGRectMake(screenWidth * 0.4, screenHeigth * 0.52248876, screenWidth * 0.233, screenWidth * 0.233);
    [self.view addSubview:VC.cancel];
    
    [VC.cancel addTarget:self action:@selector(invitePeopleToRun) forControlEvents:UIControlEventTouchUpInside];
    
    //历史记录label
    VC.historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.098, screenHeigth * 0.64, screenWidth * 0.37, screenHeigth * 0.02998501)];
    VC.historyLabel.text = @"历史记录";
    VC.historyLabel.textColor = [UIColor grayColor];
    [self.view addSubview:VC.historyLabel];
    
    if (screenHeigth > 800)
    {
        [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, holderText.length)];
        VC.loading.font = [UIFont systemFontOfSize:14];
        VC.historyLabel.font = [UIFont systemFontOfSize:18];
        VC.whiteBack.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.06, screenWidth * 0.034444, screenWidth * 0.0493333);
    }
    else if (screenHeigth > 600 && screenHeigth < 800)
    {
        [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, holderText.length)];
        VC.loading.font = [UIFont systemFontOfSize:12];
        VC.historyLabel.font = [UIFont systemFontOfSize:16];
        VC.whiteBack.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.0455, screenWidth * 0.03, screenWidth * 0.06);
    }
    else if (screenHeigth < 600)
    {
        [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, holderText.length)];
        VC.loading.font = [UIFont systemFontOfSize:10];
        VC.historyLabel.font = [UIFont systemFontOfSize:14];
        VC.whiteBack.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.06, screenWidth * 0.03, screenWidth * 0.06);
    }
    
    UIButton *btnWithImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnWithImage setImage:[UIImage imageNamed:@"下拉查看更多icon"] forState:UIControlStateNormal];
    btnWithImage.frame = CGRectMake(screenWidth *353.3/750, screenHeigth * 1278.1/1330, screenWidth *40.2/750, screenWidth *13.7/750);
    [self.view addSubview:btnWithImage];
    [btnWithImage addTarget:self action:@selector(showTheHistoryView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showTheHistoryView
{
    LJJSearchedVC *searchedVC = [[LJJSearchedVC alloc] init];
    [self presentViewController:searchedVC animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_inviteTextField resignFirstResponder];
}

- (void)invitePeopleToRun
{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    [store setObject:_inviteTextField.text forKey:@"textName"];
    LJJInviteRunModel *model = [[LJJInviteRunModel alloc] init];
    [model invitePeopleToRunURL];
    NSLog(@"%@",_inviteTextField.text);
    [self setNotification];
}

- (void)setNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchSuccessful)  name:@"isSearchSuccessful" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFail)  name:@"isSearchFail" object:nil];
}

- (void)searchSuccessful
{
    LJJInviteSearchResultViewController *resultVC = [[LJJInviteSearchResultViewController alloc] init];
    [self presentViewController:resultVC animated:NO completion:nil];
}

- (void)searchFail
{
    NSLog(@"查询失败查询失败查询失败查询失败查询失败查询失败");
}

- (void)pressBtnCancel
{
    [_inviteTextField setText:nil];
    NSLog(@"按钮已被按下");
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
