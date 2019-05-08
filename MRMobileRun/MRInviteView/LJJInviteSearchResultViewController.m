//
//  LJJInviteSearchResultViewController.m
//  MRMobileRun
//
//  Created by J J on 2019/4/6.
//

#import "LJJInviteSearchResultViewController.h"
#import "LJJInviteSearchResultView.h"
#import "LJJInviteRunVC.h"
#import "LJJInviteViewModel.h"

@interface LJJInviteSearchResultViewController ()

@property (nonatomic,strong) LJJInviteSearchResultView *resultView;

@end

@implementation LJJInviteSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.777];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:249/255.0 blue:250/255.0 alpha:1/1.0];
    _resultView = [[LJJInviteSearchResultView alloc] init];
    
    //邀约导航栏
    _resultView.imageNavigation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav导航栏底"]];
    _resultView.imageNavigation.frame = CGRectMake(0, 0, screenWidth, screenHeigth * 0.0959502);
    [self.view addSubview:_resultView.imageNavigation];
    NSLog(@"导航栏界面");
    
    //邀约label
    if (screenHeigth > 800)
    {
        _resultView.labelInvite = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeigth * 0.04422, screenWidth, 45)];
    }
    else
    {
       _resultView.labelInvite = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 45)];
    }
    
    _resultView.labelInvite.textAlignment = NSTextAlignmentCenter;
    _resultView.labelInvite.text = @"邀约";
    [self.view addSubview:_resultView.labelInvite];
    
    //返回按钮
    _resultView.back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回箭头_黑"]];
    if (screenHeigth > 800)
    {
        _resultView.back.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.06, screenWidth * 0.034444, screenWidth * 0.0493333);
    }
    else if (screenHeigth > 600 && screenHeigth < 800)
    {
        _resultView.back.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.0455, screenWidth * 0.03, screenWidth * 0.06);
    }
    else if (screenHeigth < 600)
    {
        _resultView.back.frame = CGRectMake(screenWidth * 0.058, screenHeigth * 0.06, screenWidth * 0.03, screenWidth * 0.06);
    }
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBtn)];
    _resultView.back.userInteractionEnabled = YES;
    [_resultView.back addGestureRecognizer:gesture];
    [self.view addSubview:_resultView.back];
    
    //搜索结果label
    _resultView.labelResult = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.06, screenHeigth * 0.1222, screenWidth * 0.5, screenHeigth * 0.03)];
    _resultView.labelResult.text = @"搜索结果";
    _resultView.labelResult.textColor = [UIColor grayColor];
    [self.view addSubview:_resultView.labelResult];
    // Do any additional setup after loading the view.
    
    //个人信息底板
    _resultView.cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"个人信息卡片底板"]];
    _resultView.cellImage.frame = CGRectMake(screenWidth * 0.012, screenHeigth * 0.1746626, screenWidth * 0.976, screenHeigth * 0.15);
    [self.view addSubview:_resultView.cellImage];
    
    
    //添加按钮
    _resultView.btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resultView.btnAdd setImage:[UIImage imageNamed:@"添加icon"] forState:UIControlStateNormal];
    _resultView.btnAdd.frame = CGRectMake(screenWidth * 0.845, screenHeigth * 0.224887, screenWidth * 0.03866666, screenWidth * 0.03866666);
    [_resultView.btnAdd addTarget:self action:@selector(addPerson) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resultView.btnAdd];
    
    //竖分割线
    _resultView.imageCut = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"竖分割线"]];
    _resultView.imageCut.frame = CGRectMake(screenWidth * 0.78, screenHeigth * 0.20914543, screenWidth * 0.001333, screenHeigth * 0.050974);
    [self.view addSubview:_resultView.imageCut];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLabelInformation)  name:@"information" object:nil];
}

- (void)setLabelInformation
{
    NSUserDefaults *personData = [NSUserDefaults standardUserDefaults];
//    NSLog(@"学院 = %@",[personData valueForKey:@"personCollege"]);
//    NSLog(@"姓名 = %@",[personData valueForKey:@"personNickname"]);
//    NSLog(@"学号 = %@",[personData valueForKey:@"personStuID"]);
    
    //昵称
    _resultView.labelName = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.123, screenHeigth * 0.20764618, screenWidth * 0.5, screenHeigth * 0.023)];
    _resultView.labelName.textColor = [UIColor darkGrayColor];
    _resultView.labelName.text = [personData valueForKey:@"personNickname"];
    [self.view addSubview:_resultView.labelName];
    
    //学院
    _resultView.labelCollege = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.123, screenHeigth * 0.24333, screenWidth * 0.2573333, screenHeigth * 0.02473333)];
    _resultView.labelCollege.text = [personData valueForKey:@"personCollege"];
    _resultView.labelCollege.textColor = [UIColor grayColor];
    
    [self.view addSubview:_resultView.labelCollege];
    
    //学号
    _resultView.labelStuID = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.5, screenHeigth * 0.24333, screenWidth * 0.2573333, screenHeigth * 0.02473333)];
    _resultView.labelStuID.textColor = [UIColor grayColor];
    _resultView.labelStuID.text = [personData valueForKey:@"personStuID"];
    [self.view addSubview:_resultView.labelStuID];
    if (screenHeigth > 700)
    {
        _resultView.labelName.font = [UIFont systemFontOfSize:19];
        _resultView.labelCollege.font = [UIFont systemFontOfSize:16];
        _resultView.labelStuID.font = [UIFont systemFontOfSize:16];
    }
    else if (screenHeigth > 600 && screenHeigth < 700)
    {
        _resultView.labelName.font = [UIFont systemFontOfSize:16];
        _resultView.labelCollege.font = [UIFont systemFontOfSize:13];
        _resultView.labelStuID.font = [UIFont systemFontOfSize:13];
    }
    else if (screenHeigth < 600)
    {
        _resultView.labelName.font = [UIFont systemFontOfSize:14];
        _resultView.labelCollege.font = [UIFont systemFontOfSize:11];
        _resultView.labelStuID.font = [UIFont systemFontOfSize:11];
    }
}

- (void)addPerson
{
    _resultView.labelResult.text = @"已邀约";
    _resultView.labelStuID.frame = CGRectMake(screenWidth * 0.66, screenHeigth * 0.24333, screenWidth * 0.2573333, screenHeigth * 0.02473333);

    [_resultView.btnAdd setImage:[UIImage imageNamed:@"继续添加icon"] forState:UIControlStateNormal];
    _resultView.btnAdd.frame = CGRectMake(screenWidth * 0.877, screenHeigth * 0.1222, screenHeigth * 0.03, screenHeigth * 0.03);
    [_resultView.btnAdd addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_resultView.imageCut removeFromSuperview];
    NSLog(@"按钮");
    
    //为cellImage添加手势
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(LeftSwipe:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [_resultView.cellImage addGestureRecognizer:left];
}

- (void)LeftSwipe:(UISwipeGestureRecognizer *)swipe
{
//    NSLog(@"左滑");
////    CGRectMake(screenWidth * 0.012, screenHeigth * 0.1746626, screenWidth * 0.976, screenHeigth * 0.15)
//    _resultView.cellImage.frame = CGRectMake(screenWidth * 0.0001, screenHeigth * 0.1746626, screenWidth * 0.976, screenHeigth * 0.15);
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"左");
    }
}

- (void)backBtn
{
    LJJInviteRunVC *vc = [[LJJInviteRunVC alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
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
