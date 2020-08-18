//
//  ZYLRankViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/29.
//

#import "ZYLRankViewController.h"
#import <AFNetworking.h>
#import <Masonry.h>
#import "GYYRankTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GYYRankHeaderMainView.h"
//#import "XIGSegementView.h"
//#import "ZYLAcademyRankViewController.h"
//#import "ZYLSchoolRankViewController.h"
//#import "YYkit.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <MBProgressHUD.h>


static NSString *const rankCellIdentifier = @"rankCell";

@interface ZYLRankViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong)UIButton *dayButton;
@property (nonatomic, strong)UIButton *weekButton;
@property (nonatomic, strong)UIButton *monthButton;
@property (nonatomic, strong)UIButton *schoolButton;
@property (nonatomic, strong)UIButton *academyButton;
@property (nonatomic, strong)UITableView *tableView;

                                            //明确数组里要存放什么类型的对象
                                            //视觉上直观，操作有便利
@property (nonatomic, strong) NSMutableArray<GYYRankModel *> *dataArr;
@property (nonatomic, strong) GYYRankModel *myRankModel;

@end

@implementation ZYLRankViewController
{
    NSInteger currentPage;
    NSInteger currentType;
    NSInteger currentSubtype;
    UIButton *_tempSmallBtn;
    UIButton *_tempTopBtn;
}

//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.hidden = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubviews];   //创建视图
    currentPage = 1;
    currentType = 0;
    currentSubtype = 0;
    [self requestData];  //网络请求  异步进行
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    ZYLSchoolRankViewController *view1 = [[ZYLSchoolRankViewController  alloc]init];
//    view1.title = @"校园排行";
//    ZYLAcademyRankViewController *view2 = [[ZYLAcademyRankViewController alloc]init];
//    view2.title = @"学院排行";
//    NSArray *viewArray = @[view1,view2];
//
//    XIGSegementView *segementView = [[XIGSegementView alloc]initWithFrame:CGRectMake(0, 50, screenWidth, self.view.height - NVGBARHEIGHT - STATUSBARHEIGHT) andControllers:viewArray WithStyle:@"systom"];
//    segementView.titleTextFocusColor = [UIColor colorWithHexString:@"#333739"];
//    segementView.titleTextNormalColor = [UIColor colorWithHexString:@"#B2B2B2"];
//    [self.view addSubview:segementView];

    // Do any additional setup after loading the view.
}

- (void)refreshHeaderAction{
    currentPage = 1; //0 0 0 0 00
    [self requestData];
}

- (void)refreshFooterAction{
    currentPage ++; // currentPage + 1;
    [self requestData];
}

- (void)refreshDayAction{
    currentSubtype = 0;
    [self refreshHeaderAction];
}

- (void)refreshWeekAction{
    currentSubtype = 1;
    [self refreshHeaderAction];
}

- (void)refreshMonthAction{
    currentSubtype = 2;
    [self refreshHeaderAction];
}

- (void)refreshSchoolAction{
    currentType = 0;
    [self refreshHeaderAction];
}

- (void)refreshAcademyAction{
    currentType = 1;
    [self refreshHeaderAction];
}


- (void)requestData{
    
    /**
     是AFURLSessionManager的子类，为了便利使用HTTP请求。当一个baseURL提供时，用相对路径构造GET/POST等便利的方法来创建请求。
     */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    // 请求   TCP/IP                                     http
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    //添加请求头
    [requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    
    // 响应
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];  //去除空值
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]]; //设置接收内容的格式
    [manager setResponseSerializer:responseSerializer];
    
    //HUD  加载菊花
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.mode = MBProgressHUDModeText;
//    _hud.label.text = @"正在加载数据";
//    [self.view addSubview:_hud];
    
    NSString *studentid = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"];
    NSDictionary *param = @{@"studentid" : studentid,
                            @"page" : @(self->currentPage),  //++ 第几次请求
                            @"count" : @"15", //一次请求多少个
                            @"type" : @(self->currentType),
                            @"subtype" : @(self->currentSubtype)};
    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/rank" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求到的数据 = %@", responseObject);
        if (self->currentPage == 1) {
            [self.dataArr removeAllObjects];
        }

        //单个模型赋值
        self.myRankModel = [GYYRankModel mj_objectWithKeyValues:responseObject[@"data"][@"UserData"]];
        
        
        //模型数组赋值  注意方法以及参数
        NSArray *tempArr = [GYYRankModel mj_objectArrayWithKeyValuesArray:responseObject[@"rankdata"][@"List"]];
        //page  conut
        [self.dataArr addObjectsFromArray:tempArr];
        //  0                                10       = 10
        //  10                              10        = 20
        //  20
        [self.tableView reloadData]; // UI刷新是有开销的
        self.tableView.tableHeaderView = [self headerView];
        
        if (tempArr.count < 15) {  //假设我一页请求3条，但是这次只给我返回了 0 1 2 总之小于3  那么我可以断定  已经没有更多数据了，除非是后台出错了
            [self.tableView.mj_footer endRefreshingWithNoMoreData];  //脚部标记 没有更多数据，禁止上拉
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error); // 404  500
        //MBProgressHUD  服务器异常 请稍后重试
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)createSubviews{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *navView = [[UIView alloc] init];
    if (@available(iOS 13.0, *)) {
        UIColor *GYYColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return COLOR_WITH_HEX(0xFCFCFC);
            }
            else {
                return COLOR_WITH_HEX(0x3C3F43);
            }
        }];
        navView.backgroundColor = GYYColor;
    } else {
        navView.backgroundColor = COLOR_WITH_HEX(0xFCFCFC);
    }
    [self.view addSubview:navView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTabBarHeight);
        make.top.mas_equalTo(150);
    }];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.and.top.and.right.mas_equalTo(0);
           make.height.mas_equalTo(150);
    }];
    
     [navView addSubview:self.dayButton];
        [navView addSubview:self.weekButton];
        [navView addSubview:self.monthButton];
        [navView addSubview:self.schoolButton];
        [navView addSubview:self.academyButton];
    //    [navView addSubview:_schoolButton];
    //    [navView addSubview:_academyButton];
        [_dayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.bottom.mas_equalTo(-4);
            make.size.mas_equalTo(CGSizeMake(42, 25));
        }];
        [_weekButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(86);
            make.bottom.mas_equalTo(-4);
            make.size.mas_equalTo(CGSizeMake(42, 25));
        }];
        [_monthButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(155);
            make.bottom.mas_equalTo(-4);
            make.size.mas_equalTo(CGSizeMake(42, 25));
        }];
        [_schoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(64);
            make.bottom.mas_equalTo(-50);
            make.size.mas_equalTo(CGSizeMake(124, 28));
        }];
        [_academyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(214);
            make.bottom.mas_equalTo(-50);
            make.size.mas_equalTo(CGSizeMake(124, 28));
        }];
    }

#pragma mark ======== UITableViewDelegate & UITableViewDataSource ========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {  //分几个区
    return 1;
}

/**
 下面三个方法 必须实现
 */
//每个分区有多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {   //每个区有几个cell
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {   //每个cell的高度
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYYRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rankCellIdentifier forIndexPath:indexPath];
    cell.rankModel = self.dataArr[indexPath.row];
    return cell;
}

- (UIView *)headerView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 103)];
    
    if (self.myRankModel) {
        NSLog(@"self.myRankModel  请求到了  可以布局了");
        GYYRankHeaderMainView *mainView = [[GYYRankHeaderMainView alloc] init];
        [headerView addSubview:mainView];
        mainView.rankModel = self.myRankModel;
        [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 5, 15));
        }];
    }
    return headerView;
}
 
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        if (@available(iOS 13.0, *)) {
            UIColor *GYYColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                    return COLOR_WITH_HEX(0xFCFCFC);
                }
                else {
                    return COLOR_WITH_HEX(0x3C3F43);
                }
            }];
            _tableView.backgroundColor = GYYColor;
        } else {
            _tableView.backgroundColor = COLOR_WITH_HEX(0xFCFCFC);
        }
        _tableView.showsVerticalScrollIndicator = NO;    //右侧 竖条
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 78;
        _tableView.tableHeaderView = [self headerView];
        [_tableView registerClass:[GYYRankTableViewCell class] forCellReuseIdentifier:rankCellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
        refreshHeader.lastUpdatedTimeLabel.hidden = NO;
        _tableView.mj_header = refreshHeader;
        
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
        _tableView.mj_footer = refreshFooter;
        [refreshFooter setTitle:@"已加载完全部排行" forState:MJRefreshStateNoMoreData];
    }
    return _tableView;
}


-(UIButton *)dayButton{
    if (!_dayButton) {
        _dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dayButton setTitle:@"日榜" forState:UIControlStateNormal];
        [_dayButton setTitleColor:COLOR_WITH_HEX(0xB2B2B2) forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_dayButton setTitleColor:[UIColor labelColor]
                             forState:UIControlStateSelected];
        } else {
            
            [_dayButton setTitleColor:COLOR_WITH_HEX(0x333739) forState:UIControlStateSelected];
            // Fallback on earlier versions
        }
        [_dayButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _dayButton.tag = 100;
    }
    return _dayButton;
}

-(UIButton *)weekButton{
    if (!_weekButton) {
        _weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weekButton setTitle:@"周榜" forState:UIControlStateNormal];
        [_weekButton setTitleColor:COLOR_WITH_HEX(0xB2B2B2) forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_weekButton setTitleColor:[UIColor labelColor]
                              forState:UIControlStateSelected];
        } else {
            
            [_weekButton setTitleColor:COLOR_WITH_HEX(0x333739) forState:UIControlStateSelected];
            // Fallback on earlier versions
        }
        [_weekButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _weekButton.tag = 200;
    }
    return _weekButton;
}

- (UIButton *)monthButton{
    if (!_monthButton) {
        _monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_monthButton setTitle:@"月榜" forState:UIControlStateNormal];
        [_monthButton setTitleColor:COLOR_WITH_HEX(0xB2B2B2) forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_monthButton setTitleColor:[UIColor labelColor]
                               forState:UIControlStateSelected];
        } else {
            
            [_monthButton setTitleColor:COLOR_WITH_HEX(0x333739) forState:UIControlStateSelected];
            // Fallback on earlier versions
        }
        [_monthButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _monthButton.tag = 300;
    }
    return _monthButton;
}

- (UIButton *)schoolButton{
    if (!_schoolButton) {
        _schoolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_schoolButton setTitle:@"校园排行" forState:UIControlStateNormal];
        [_schoolButton setTitleColor:COLOR_WITH_HEX(0xB2B2B2) forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_schoolButton setTitleColor:[UIColor labelColor]
                                forState:UIControlStateSelected];
        } else {
            
            [_schoolButton setTitleColor:COLOR_WITH_HEX(0x333739) forState:UIControlStateSelected];
            // Fallback on earlier versions
        }
        [_schoolButton addTarget:self action:@selector(clicktopButton:) forControlEvents:UIControlEventTouchUpInside];
        _schoolButton.tag = 400;
    }
    return _schoolButton;
}

- (UIButton *)academyButton{
    if (!_academyButton) {
        _academyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_academyButton setTitle:@"学院排行" forState:UIControlStateNormal];
        [_academyButton setTitleColor:COLOR_WITH_HEX(0xB2B2B2) forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_academyButton setTitleColor:[UIColor labelColor]
                                 forState:UIControlStateSelected];
        } else {
            
            [_academyButton setTitleColor:COLOR_WITH_HEX(0x333739) forState:UIControlStateSelected];
            // Fallback on earlier versions
        }
        [_academyButton addTarget:self action:@selector(clicktopButton:) forControlEvents:UIControlEventTouchUpInside];
        _academyButton.tag = 500;
    }
    return _academyButton;
}
- (void)clickButton:(UIButton*)btn{
    if (_tempSmallBtn == btn) {
        return;
    }
    
    if (btn.tag == 100) {
        [self refreshDayAction];
    }else if (btn.tag == 200) {
        [self refreshWeekAction];
    }else if (btn.tag == 300) {
        [self refreshMonthAction];
    }
    
    _tempSmallBtn.selected = NO;
    _tempSmallBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _tempSmallBtn = btn;
    _tempSmallBtn.selected = YES;
    _tempSmallBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
}
-(void)clicktopButton:(UIButton*)btn{
    if (_tempTopBtn == btn) {
        return;
    }
    if (btn.tag == 400){
        [self refreshSchoolAction];
    }else if (btn.tag == 500){
        [self refreshAcademyAction];
    }
    _tempTopBtn.selected = NO;
    _tempTopBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _tempTopBtn = btn;
    _tempTopBtn.selected = YES;
    _tempTopBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;;
}

@end
