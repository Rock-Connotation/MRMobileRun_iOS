//
//  ZYLSchoolRankViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/29.
//

#import "ZYLSchoolRankViewController.h"
#import "ZYLRankTableViewCell.h"
#import "ZYLSelfRankView.h"
#import "ZYLSliderView.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <YYkit.h>

@interface ZYLSchoolRankViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tab;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSArray<UIButton *> *btnArray;
@property (nonatomic, strong) ZYLSliderView *slidingView;
@property (nonatomic, strong) ZYLSelfRankView *selfrankView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UILabel *errorLab;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *time;

@end

@implementation ZYLSchoolRankViewController

/*
 初始化各个控件
 加载数据
 一个界面有两个数据源，可能存在一个数据源生效，另一个没有的情况
 所以以一个数据源为主(BeforeYouView)，所以tableview的数据在YouView之后
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    //数据
    self.page = @"1";
    self.time = @"days";
    self.array = [NSMutableArray array];
    self.view.backgroundColor = [UIColor clearColor];
    //MODEL
//    [ZYLStudentRankViewModel ZYLGetStudentRankWithPages: self.page andtime:self.time];
    //hud菊花
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.mode = MBProgressHUDModeText;
//    _hud.label.text = @"正在加载数据";
//    [self.view addSubview:_hud];
//    _errorLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.centerX - 50, self.view.centerY - 10 , 100, 20)];
//    _errorLab.textAlignment = NSTextAlignmentCenter;
    //顶部按钮
    [self addTitleBtn];
    [self setTableView];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTableView:) name:@"StuRankCatched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateYouView:) name:@"MyStuRankCatched" object:nil];
    //请求_you的数据，有数据加载，没有不加载
//    [ZYLStudentRankViewModel ZYLGetMyStudentRankWithdtime: self.time];
}
#pragma mark 几个view的初始化

//tableview的初始化
- (void)setTableView{
    _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, _btnArray[1].bottom, screenWidth, self.view.bottom - _btnArray[1].bottom) style:UITableViewStyleGrouped];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tab.backgroundColor = [UIColor clearColor];
    //刷新器
    [self setupRefresh];
    [self setupSelfRankView];
    [self.view addSubview:_tab];
    [self.tab reloadData];
}

//tableview的刷新器
- (void)setupRefresh
{
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了哦" forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    self.tab.mj_footer = footer;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle]; // 箭头向下时文字
    [header setTitle:@"放开刷新" forState:MJRefreshStatePulling]; // 箭头向上时文字
    [header setTitle:@"加载..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置刷新控件
    self.tab.mj_header = header;
}

- (void)setupSelfRankView{
    self.selfrankView = [[ZYLSelfRankView alloc] init];
    self.selfrankView.frame = CGRectMake(0, 0, screenWidth, 88);
    self.selfrankView.avatar.image = [UIImage imageNamed:@"avatar"];
    self.selfrankView.rank = 12;
    self.selfrankView.rangeLab.text = @"14.00";
    self.selfrankView.nicknameLab.text = @"youyou";
    self.selfrankView.rankLab.text = @"13";
    self.tab.tableHeaderView = self.selfrankView;
}

//顶部按钮
-(void)addTitleBtn{
    UIButton *dayStyle = [self setUpBtn:@"日榜"];
    UIButton *monthStyle = [self setUpBtn:@"月榜"];
    UIButton *weekStyle = [self setUpBtn:@"周榜"];
    _btnArray = @[dayStyle, weekStyle, monthStyle];
    for (int i = 0; i < _btnArray.count; i ++) {
        UIButton *btn = _btnArray[i];
        btn.frame = CGRectMake(screenWidth * i / 3, 0, screenWidth/3, 30 * screenWidth /375);
        [self.view addSubview: btn];
    }
    _slidingView = [[ZYLSliderView alloc]initWithFrame:CGRectMake(dayStyle.centerX - 21, dayStyle.bottom - 2, 42, 2)];
    _btnArray[0].selected = YES;
    [self.view addSubview:_slidingView];
}

- (UIButton *)setUpBtn:(NSString *)style{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:style forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333739"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorWithHexString:@"#B2B2B2"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(changeTheView:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)changeTheView:(UIButton *)btn{
    for (int i = 0; i < _btnArray.count; i ++) {
        _btnArray[i].selected = NO;
    }
    btn.selected = YES;
    self.page = @"1";
    if ([btn.currentTitle isEqualToString:@"日"]){
        self.time = @"days";
    }
    else if ([btn.currentTitle isEqualToString:@"月"]){
        self.time = @"months";
    }
    else{
        self.time = @"weekends";
    }
    [self loadDate:self.time];
     _slidingView.frame = CGRectMake(btn.centerX - 21, btn.bottom - 2, 42, 2);
}
#pragma mark 数据的交互
- (void)loadDate:(NSString *)style{
//    [ZYLStudentRankViewModel ZYLGetStudentRankWithPages:self.page andtime: self.time];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.label.text = @"正在加载数据";
    [self.view addSubview:_hud];
    [_tab removeFromSuperview];
    [_errorLab removeFromSuperview];
}
//tableview的数据
- (void)UpdateTableView:(NSNotification *)notification{
    NSMutableArray *notArry = notification.object;
    if ([self.page isEqualToString:@"1"]) {
        [_tab removeFromSuperview];
        [_hud hideAnimated:YES];
        self.array = notArry;
        if (_array != nil && ![_array isKindOfClass:[NSNull class]] && _array.count != 0)  {
            [self setTableView];
        }
        else{
            _errorLab.text = @"暂无数据";
            NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            [self.view addSubview:_errorLab];
        }
    }
    else{
        if (notArry.count <= 1) {
            NSInteger num = [[self.page numberValue]integerValue];
            num--;
            self.page = [[NSNumber numberWithInteger:num] stringValue];
        //判断刷新情况
            if (_tab.mj_header.state == MJRefreshStateRefreshing){
                [_tab.mj_header endRefreshing];
            }
            else{
                [_tab.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else{
            [_array addObjectsFromArray: notArry];
            if (_tab.mj_header.state == MJRefreshStateRefreshing){
                [_tab.mj_header endRefreshing];
            }
            else{
                [_tab.mj_footer endRefreshing];
            }
        }
    }
    
}
//Before的数据
//-(void)UpdateYouView:(NSNotification *)notification{
//    ZYLRankModel *rankModel = notification.object;
//    [_you removeFromSuperview];
//    if (rankModel.college) {
//        [self setBeforeView: rankModel];
//        [ZYLStudentRankViewModel ZYLGetMyStudentRankWithdtime:self.time];
//    }
//    else{
//        [_hud hideAnimated:YES];
//        _errorLab.text = @"暂无数据";
//        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//        [self.view addSubview:_errorLab];
//    }
//}


- (void)timerAction:(NSTimer *)timer{
    [self.errorLab removeFromSuperview];
    [timer invalidate];
    timer = nil;
}
//下拉加载数据
- (void)reloadData{
    NSInteger num = [[self.page numberValue] integerValue];
    num++;
    self.page = [[NSNumber numberWithInteger:num] stringValue];
//    [ZYLStudentRankViewModel ZYLGetStudentRankWithPages:self.page andtime:self.time];
}

#pragma mark tableview协议
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYLRankTableViewCell *cell = [ZYLRankTableViewCell cellWithTableView: tableView];
    cell.rank = indexPath.row;
    cell.avatar.image = [UIImage imageNamed:@"avatar"];
    cell.nicknameLab.text = @"www";
    cell.signLab.text = @"hhh";
    cell.rangeLab.text = @"15.00";
    return cell;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _array.count;
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

@end
