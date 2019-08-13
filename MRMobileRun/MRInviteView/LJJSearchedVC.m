//
//  LJJSearchedVC.m
//  MRMobileRun
//
//  Created by J J on 2019/7/31.
//

#import "LJJSearchedVC.h"
#import "LJJSearchedView.h"
#import "ZYLMainViewController.h"
#import "LJJInviteRunVC.h"
#import "LJJInviteSearchResultViewController.h"
#import "LJJInviteViewModel.h"
@interface LJJSearchedVC ()
@property (strong, nonatomic) LJJSearchedView *searchedView;

@end

@implementation LJJSearchedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchedView = [[LJJSearchedView alloc] init];
    
    _searchedView.imageViewBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景色"]];
    _searchedView.imageViewBack.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
    [self.view addSubview:_searchedView.imageViewBack];
    
    _searchedView.labelInvite = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeigth * 59.0/1334, screenWidth, screenHeigth *50.0/1334)];
    _searchedView.labelInvite.text = @"邀约";
    _searchedView.labelInvite.textColor = [UIColor blackColor];
    _searchedView.labelInvite.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_searchedView.labelInvite];
    
    _searchedView.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchedView.btnBack setImage:[UIImage imageNamed:@"返回箭头_黑"] forState:UIControlStateNormal];
    _searchedView.btnBack.frame = CGRectMake(screenWidth *44.0/750, screenHeigth *69.0/1330, screenWidth *17.3/750, screenHeigth *35.6/1330);
    [_searchedView.btnBack addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchedView.btnBack];
    
    _searchedView.idInfoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"查看底板"]];
    _searchedView.idInfoView.frame = CGRectMake(0, screenHeigth *90.0/1334, screenWidth, screenHeigth *1150.0/1334);
    [self.view addSubview:_searchedView.idInfoView];
    
    //滑动
    _searchedView.idInfoScroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, screenHeigth *204.0/1334, screenWidth, screenHeigth *987.0/1334)];
    _searchedView.idInfoScroView.contentSize = CGSizeMake(screenWidth, screenHeigth);
    _searchedView.idInfoScroView.pagingEnabled = YES;
    _searchedView.idInfoScroView.bounces = YES;
    [self.view addSubview:_searchedView.idInfoScroView];
    
    //
    _searchedView.labelInvite = [[UILabel alloc] initWithFrame:CGRectMake(screenHeigth * 42.0/1334, screenHeigth * 163.0/1334, screenWidth *500.0/750, screenHeigth *40.0/1334)];
    _searchedView.labelInvite.text = @"历史记录";
    _searchedView.labelInvite.textColor = [LJJInviteRunVC colorWithHexString:@"#9F9FB7"];
    [self.view addSubview:_searchedView.labelInvite];
    
    LJJInviteViewModel *model = [[LJJInviteViewModel alloc] init];
    [model setHisrotyViewWithViewControllerAndView:_searchedView];
}

- (void)pressBtn
{
    ZYLMainViewController *mainVC = [[ZYLMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController: mainVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [LJJInviteSearchResultViewController removeChildVc:self];
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
