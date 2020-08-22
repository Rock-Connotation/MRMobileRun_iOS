//
//  GYYRankChidlViewController.m
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/8/21.
//

#import "GYYRankChidlViewController.h"
#import "GYYRankHeaderMainView.h"
#import "GYYRankTableViewCell.h"
#import <AFNetworking.h>
#import <Masonry.h>
#import "UIImageView+WebCache.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <MBProgressHUD.h>

static NSString *const rankCellIdentifier = @"rankCell";

@interface GYYRankChidlViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

                                            //明确数组里要存放什么类型的对象
                                            //视觉上直观，操作有便利
@property (nonatomic, strong) NSMutableArray<GYYRankModel *> *dataArr;
@property (nonatomic, strong) GYYRankModel *myRankModel;

@end

@implementation GYYRankChidlViewController
{
    NSInteger currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubviews];   //创建视图
    currentPage = 1;
    [self requestData];      //网络请求  异步进行
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *studentid = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"];
    NSDictionary *param = @{@"studentid" : studentid,
                            @"page" : @(self->currentPage),  //++ 第几次请求
                            @"count" : @"15", //一次请求多少个
                            @"type" : @(self.isFaculty),
                            @"subtype" : @(self.rankType)};
    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/rank" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [hud hideAnimated:YES];
        
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
        [hud hideAnimated:YES];
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)createSubviews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
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
        [refreshHeader setTitle:@"正在刷新排行中………"forState:MJRefreshStateRefreshing];
        [refreshHeader setTitle:@"松开刷新排行" forState:MJRefreshStatePulling];
        [refreshHeader setTitle:@"下拉刷新排行" forState:MJRefreshStateIdle];
        _tableView.mj_header = refreshHeader;
        
        MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
        _tableView.mj_footer = refreshFooter;
        [refreshFooter setTitle:@"已加载完全部排行" forState:MJRefreshStateNoMoreData];
        [refreshFooter setTitle:@"正在加载更多排行数据………" forState:MJRefreshStateRefreshing];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;;
}

@end
