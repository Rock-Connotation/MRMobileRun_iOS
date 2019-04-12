//
//  XIGStudentViewController.m
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/27.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "XIGStudentViewController.h"
#import "XIGBeforeYou.h"
#import "XIGInviteTableViewCell.h"
#import "ZYLStudentRankViewModel.h"
#import "ZYLStudentRankModel.h"
#import "ZYLRankModel.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <YYkit.h>

@interface XIGStudentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)NSArray<UIButton *> *btnArray;
@property (nonatomic,strong)UIImageView *slidingView;
@property (nonatomic,strong)XIGBeforeYou *you;
@property (nonatomic,strong)UITableView *tab;
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)UILabel *errorLab;
@property (nonatomic,assign)NSString *page;
@property (nonatomic,strong)NSString *time;
@end


@implementation XIGStudentViewController
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"F2F6F7"];
    //MODEL
    [ZYLStudentRankViewModel ZYLGetStudentRankWithPages: self.page andtime:self.time];
    //hud菊花
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.label.text = @"正在加载数据";
    [self.view addSubview:_hud];
    _errorLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.centerX - 50, self.view.centerY - 10 , 100, 20)];
    _errorLab.textAlignment = NSTextAlignmentCenter;
    //顶部按钮
    [self addTitleBtn];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTableView:) name:@"StuRankCatched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateYouView:) name:@"MyStuRankCatched" object:nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F2F6F7"];
    //请求_you的数据，有数据加载，没有不加载
    [ZYLStudentRankViewModel ZYLGetMyStudentRankWithdtime: self.time];
}
#pragma mark 几个view的初始化
//BeforeView的初始化
- (void)setBeforeView:(ZYLRankModel *)rankModel{
    //在本地拿头像
    NSString *path_document = NSHomeDirectory();
    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/avatar.png"];
    UIImage *avatarImage = [UIImage imageWithContentsOfFile:imagePath];

    _you = [[XIGBeforeYou alloc]init];
    _you.frame = CGRectMake(0, _btnArray[1].bottom + 1, screenWidth, 160);
    _you.nameLabel.text = rankModel.nickname;
    double diff = [rankModel.prev_difference doubleValue];
    _you.recordLabel.text = [NSString stringWithFormat:@"%.2f",diff];
    _you.headImageView.image = avatarImage;
    double rank = [rankModel.rank doubleValue];
    _you.rankingLabl.text = [NSString stringWithFormat:@"%.0f",rank];
    double total = [rankModel.total doubleValue];
    _you.diffNumLabel.text = [NSString stringWithFormat:@"%.0f",total];
    [_you setKindLabel:@"km"];
}
//tableview的初始化
- (void)setTableView{
    _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, _btnArray[1].bottom, screenWidth, self.view.bottom - _btnArray[1].bottom) style:UITableViewStyleGrouped];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.tableHeaderView = _you;
    _tab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tab.backgroundColor = [UIColor clearColor];
    //刷新器
    [self setupRefresh];
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

//顶部按钮
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
    [self loadDate:self.time];
    if ([btn.currentTitle isEqualToString:@"总榜"]) {
        _slidingView.frame = CGRectMake(btn.centerX - 14, btn.bottom - 2, 28, 2);
    }
    else{
        _slidingView.frame = CGRectMake(btn.centerX - 7, btn.bottom - 2, 14, 2);
    }
    
}
#pragma mark 数据的交互
- (void)loadDate:(NSString *)style{
    [ZYLStudentRankViewModel ZYLGetMyStudentRankWithdtime: self.time];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.label.text = @"正在加载数据";
    [self.view addSubview:_hud];
    [_tab removeFromSuperview];
    [_you removeFromSuperview];
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
-(void)UpdateYouView:(NSNotification *)notification{
    ZYLRankModel *rankModel = notification.object;
    [_you removeFromSuperview];
    if (rankModel) {
        [self setBeforeView: rankModel];
        [ZYLStudentRankViewModel ZYLGetStudentRankWithPages:self.page andtime:self.time];
    }
    else{
        [_hud hideAnimated:YES];
        _errorLab.text = @"暂无数据";
        [self.view addSubview:_errorLab];
    }
    
}
//下拉加载数据
- (void)reloadData{
    NSInteger num = [[self.page numberValue] integerValue];
    num++;
    self.page = [[NSNumber numberWithInteger:num] stringValue];
    [ZYLStudentRankViewModel ZYLGetStudentRankWithPages:self.page andtime:self.time];
}

#pragma mark tableview协议
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XIGInviteTableViewCell *cell = [XIGInviteTableViewCell cellWithTableView:tableView];
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
    [cell.headImageView removeAllSubviews];
    ZYLStudentRankModel *model = _array[indexPath.row];
//    NSString *urlString = [[NSString alloc]initWithFormat:@"http://running-together.redrock.team/sanzou/user/image/%@",dic[@"student_id"]];
//    NSURL *imagePath = [NSURL URLWithString:urlString];
//    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.headImageView.width, cell.headImageView.height)];
//    [headImage  sd_setImageWithURL:imagePath];
//    [cell.headImageView addSubview:headImage];
   
    cell.nameLabel.text = model.nickname;
    cell.schoolLabel.text = model.college;
    double total = [model.total doubleValue];
    cell.recordLabel.text = [NSString stringWithFormat:@"%.2fkm", total];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
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
