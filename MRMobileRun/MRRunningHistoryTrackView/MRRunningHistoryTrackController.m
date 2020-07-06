//
//  MRRunningHistoryTrackController.m
//  MRMobileRun
//
//  Created by J J on 2019/9/3.
//

#import "MRRunningHistoryTrackController.h"
#import "ZYLMainViewController.h"
#import "MRRunningHistoryTrackModel.h"
#import "LJJInviteRunVC.h"
@interface MRRunningHistoryTrackController ()
@end

@implementation MRRunningHistoryTrackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"开始跑步nav+状态栏底"]];
    view.frame = CGRectMake(0, 0, screenWidth, screenHeigth *128.0/1334);
    [self.view addSubview:view];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"返回箭头2"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(screenWidth *44.0/750, screenHeigth *69.0/1330, screenWidth *17.3/750, screenHeigth *35.6/1330);
    [self.view addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeigth * 59.0/1334, screenWidth, screenHeigth *50.0/1334)];
    label.text = @"我的足迹";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    MRRunningHistoryTrackModel *model = [[MRRunningHistoryTrackModel alloc] init];
    [model loadData];
    [self setCell];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noMessage) name:@"NoTrack" object:nil];
}

- (void)noMessage
{
    UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeigth * 0.45, screenWidth, screenHeigth * 0.1)];
    labelDate.text = @"暂时还没有历史足迹哦";
    labelDate.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelDate];
}

- (void)setCell
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    int columeNum = [[user valueForKey:@"colume"] intValue];
    NSLog(@"the colume is %d",columeNum);
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, screenHeigth *128.0/1334, screenWidth, screenHeigth * 1206.0/1334)];
    view.bounces = YES;
    view.userInteractionEnabled = YES;
    view.contentSize = CGSizeMake(screenWidth, columeNum * screenHeigth *160.0/1334);
    [self.view addSubview:view];

    for (int i = 0; i < [[user valueForKey:@"colume"] intValue]; i ++)
    {
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.1, screenHeigth *0.007 + i * screenHeigth * 160.0/1334, screenWidth * 0.77, screenHeigth *0.033)];
        labelDate.text = [user valueForKey:@"dateArray"][i];
        labelDate.textColor = [LJJInviteRunVC colorWithHexString:@"#9F9FB7"];
        [view addSubview:labelDate];
        
        UILabel *labelDistance = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.1, screenHeigth *0.04 + i * screenHeigth * 160.0/1334, screenWidth * 0.5, screenHeigth * 0.072)];
        labelDistance.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"distanceArray"][i]];
        labelDistance.textColor = [UIColor blackColor];
        [view addSubview:labelDistance];
        
        UILabel *labelKm = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.77, screenHeigth *0.06 + i * screenHeigth * 160.0/1334, screenWidth * 0.1, screenHeigth *0.04)];
        labelKm.text = @"KM";
        labelKm.textColor = [LJJInviteRunVC colorWithHexString:@"#9F9FB7"];
        [view addSubview:labelKm];
        
        if (screenHeigth > 800)
        {
            labelDistance.font = [UIFont boldSystemFontOfSize:38];
        }
        else if (screenHeigth > 600 && screenHeigth < 800)
        {
            labelDistance.font = [UIFont boldSystemFontOfSize:35];
        }
        else if (screenHeigth < 600)
        {
            labelDistance.font = [UIFont boldSystemFontOfSize:30];
        }
        
        UIImageView *imageLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"横分割线"]];
        imageLine.frame = CGRectMake(0, screenHeigth *147.0/1334 + i * screenHeigth * 160.0/1334, screenWidth, screenHeigth *0.003);
        [view addSubview:imageLine];
    }
}

- (void)back
{
    ZYLMainViewController *mainVC = [[ZYLMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController: mainVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
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
