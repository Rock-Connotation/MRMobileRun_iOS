//
//  XIGClassRankViewController.m
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "XIGClassRankViewController.h"
#import "XIGClass.h"
#import "XIGClassTableViewCell.h"
#import "ZYLClassRankModel.h"
#import "ZYLClassRankViewModel.h"
#import "ZYLRankModel.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import <YYkit.h>
#import "UIFont+AdjustAuto.h"
@interface XIGClassRankViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong)XIGClass *classView;
@property (nonatomic,strong)NSArray<UIButton *> *btnArray;
@property (nonatomic,strong)UIImageView *slidingView;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)UITableView *tab;
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)UILabel *errorLab;
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *time;
@end

@implementation XIGClassRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time = @"days";
    self.page = @"1";
    self.array = [NSMutableArray array];
     self.view.backgroundColor = [UIColor colorWithHexString:@"F2F6F7"];
//    _model = [[XIGClassModel alloc]init];
    [ZYLClassRankViewModel ZYLGetClassRankWithPages: self.page andtime: self.time];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.label.text = @"正在加载数据";
    _errorLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.centerX - 50, self.view.centerY - 10 , 100, 20)];
    _errorLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_hud];
    [self addTitleBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTableView:) name:@"ClassRankCatched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateClassView:) name:@"MyClassRankCatched" object:nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F2F6F7"];
     [ZYLClassRankViewModel ZYLGetMyClassRankWithdtime: self.time];
}
-(void)setUpClassView:(ZYLRankModel *)model{
    _classView = [[XIGClass alloc]init];
    _classView.frame = CGRectMake(0, _btnArray[1].bottom + 1, screenWidth, 130);
//    _classView.stuNumLabel.text = model.class_id;
    _classView.stuNumLabel.font = [UIFont adjustFontSize:16];
    double diff = [model.prev_difference doubleValue];
    _classView.recordNumLabel.text = [NSString stringWithFormat:@"%.2f",diff];
    double ranking = [model.rank doubleValue];
    _classView.randkingLabel.text = [NSString stringWithFormat:@"%.0f",ranking];
    double total = [model.total doubleValue];
    _classView.diffNumLabel.text = [NSString stringWithFormat:@"%.1f",total];
}
-(void)setView{
    _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, _btnArray[1].bottom, screenWidth, self.view.bottom - _btnArray[1].bottom) style:UITableViewStyleGrouped];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.tableHeaderView = _classView;
    _tab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tab.backgroundColor = [UIColor clearColor];
    //刷新器
    [self setupRefresh];
    [self.view addSubview:_tab];
    [self.tab reloadData];
}
-(void)addTitleBtn{
    UIButton * dayStyle = [self setUpBtn:@"日"];
    UIButton * monthStyle = [self setUpBtn:@"月"];
    UIButton * weekStyle = [self setUpBtn:@"周"];
    UIButton * totalStyle = [self setUpBtn:@"总榜"];
    _btnArray = @[dayStyle, monthStyle, weekStyle, totalStyle];
    for (int i = 0; i < _btnArray.count; i ++) {
        UIButton *btn = _btnArray[i];
        btn.frame = CGRectMake(screenWidth * i / 4, 0, screenWidth/4, 30 * screenWidth /375);
        [self.view addSubview: btn];
    }
    _slidingView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"按钮底2"]];
    _btnArray[0].selected = YES;
    _slidingView.frame = CGRectMake(dayStyle.centerX - 7, dayStyle.bottom - 2, 14, 2);
    [self.view addSubview:_slidingView];
}
- (UIButton *)setUpBtn:(NSString *)style{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:style forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorWithHexString:@"#9A9A9A"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
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
//    _page = 0;
    if ([btn.currentTitle isEqualToString:@"日"]){
        self.time = @"days";
        
    }
    else if ([btn.currentTitle isEqualToString:@"月"]){
        self.time = @"months";
    }
    else if([btn.currentTitle isEqualToString:@"总榜"]){
        self.time = @"all";
    }
    else{
        self.time = @"weekends";
    }
//    [self loadDate:_style];
    [self loadDate: self.time];
    if ([btn.currentTitle isEqualToString:@"总榜"]) {
        _slidingView.frame = CGRectMake(btn.centerX - 14, btn.bottom - 2, 28, 2);
    }
    else{
        _slidingView.frame = CGRectMake(btn.centerX - 7, btn.bottom - 2, 14, 2);
    }
    
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

- (void)loadDate:(NSString *)style{
    [ZYLClassRankViewModel ZYLGetClassRankWithPages:self.page andtime: self.time];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.label.text = @"正在加载数据";
    [self.view addSubview:_hud];
    [_tab removeFromSuperview];
    [_classView removeFromSuperview];
    [_errorLab removeFromSuperview];
}

//数据通知
- (void)UpdateTableView:(NSNotification *)notification{
    NSMutableArray *notArry = notification.object;
    if ([self.page isEqualToString:@"1"]) {
        [_tab removeFromSuperview];
        [_hud hideAnimated:YES];
        self.array = notArry;
        if (_array != nil && ![_array isKindOfClass:[NSNull class]] && _array.count != 0)  {
            [self setView];
        }
        else{
            _errorLab.text = @"暂无数据";
            NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            [self.view addSubview:_errorLab];
        }
    }
    else{
        NSInteger page = [[self.page numberValue] integerValue];
        page--;
        self.page = [[NSNumber numberWithInteger:page] stringValue];
        //判断刷新情况
        if (notArry.count <= 1) {
            if (_tab.mj_header.state == MJRefreshStateRefreshing){
                [_tab.mj_header endRefreshing];
            }
            else{
                [_tab.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else{
            [_array addObjectsFromArray:notArry];
            if (_tab.mj_header.state == MJRefreshStateRefreshing){
                [_tab.mj_header endRefreshing];
            }
            else{
                [_tab.mj_footer endRefreshing];
            }
        }
    }
    
}

-(void)UpdateClassView:(NSNotification *)notification{
    ZYLRankModel *model = notification.object;
    [_classView removeFromSuperview];
    if (model.distance) {
        [self setUpClassView: model];
        [ZYLClassRankViewModel ZYLGetMyClassRankWithdtime: self.time];
    }
    else{
        [_hud hideAnimated:YES];
        _errorLab.text = @"暂无数据";
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [self.view addSubview:_errorLab];
    }
    
}

- (void)timerAction:(NSTimer *)timer{
    [self.errorLab removeFromSuperview];
    [timer invalidate];
    timer = nil;
}

- (void)reloadData{
    NSInteger page = [[self.page numberValue] integerValue];
    page++;
    self.page = [[NSNumber numberWithInteger: page] stringValue];
    [ZYLClassRankViewModel ZYLGetClassRankWithPages:self.page andtime:self.time];
}

#pragma mark tableview协议
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     XIGClassTableViewCell *cell = [XIGClassTableViewCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        [cell.rankImageView removeAllSubviews];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"排名1logo"]];
        image.frame = CGRectMake(0, 0, cell.rankImageView.width, cell.rankImageView.height);
        [cell.rankImageView addSubview:image];
        cell.recordLabel.textColor = [UIColor colorWithHexString:@"#FA7F6A"];
    }
    else if (indexPath.row == 1){
        [cell.rankImageView removeAllSubviews];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"排名2logo"]];
        image.frame = CGRectMake(0, 0, cell.rankImageView.width, cell.rankImageView.height);
        [cell.rankImageView addSubview:image];
        cell.recordLabel.textColor = [UIColor colorWithHexString:@"#FF9179"];
    }
    else if (indexPath.row == 2){
        [cell.rankImageView removeAllSubviews];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"排名3logo"]];
        image.frame = CGRectMake(0, 0, cell.rankImageView.width, cell.rankImageView.height);
        [cell.rankImageView addSubview:image];
        cell.recordLabel.textColor = [UIColor colorWithHexString:@"#FFA522"];
    }
    else{
        [cell.rankImageView removeAllSubviews];
        UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.rankImageView.width, cell.rankImageView.height)];
        rankLabel.textColor = [UIColor colorWithHexString:@"#ABB0CD"];
        cell.recordLabel.textColor = [UIColor colorWithHexString:@"#A7A7BD"];
        [rankLabel setFont:[UIFont fontWithName:@"DINAlternate-Bold" size:20]];
        rankLabel.textAlignment = NSTextAlignmentCenter;
        rankLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [cell.rankImageView addSubview:rankLabel];
    }
    ZYLClassRankModel *model = _array[indexPath.row];
    cell.nameLabel.text = model.class_id;
    cell.schoolLabel.text = model.college;
    double total = [model.total doubleValue];
    cell.recordLabel.text = [NSString stringWithFormat:@"%.2fkm", total];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
