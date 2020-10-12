//
//  MGDMineViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/10.
//

#import "MGDDataTool.h"
#import "MGDTimeTool.h"
#import "MGDRefreshTool.h"
#import "MGDMineViewController.h"
#import "MGDTopView.h"
#import "MGDBaseInfoView.h"
#import "MGDMiddleView.h"
#import "MGDSportTableView.h"
#import "MGDSportTableViewCell.h"
#import "MGDMineViewController.h"
#import "MGDMoreViewController.h"
#import "MGDUserData.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MRTabBarController.h"
#import "HttpClient.h"
#import "MGDSportData.h"
#import "MGDCellDataViewController.h"
#import <MJRefresh.h>
#import "MBProgressHUD.h"

#define BACKGROUNDCOLOR [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]


@interface MGDMineViewController () <UITableViewDataSource,UITableViewDelegate> {
    MJRefreshNormalHeader *_header;
}
@property (nonatomic, strong) MGDUserData *currentModel; //三大数据的模型
@property (nonatomic, strong) MGDSportData *sportModel; //运动列表数据的模型
@property (nonatomic, strong) NSMutableArray *userSportArray; //装运动列表的模型的数组
@property (nonatomic, strong) MBProgressHUD *hud; //失败时的HUD
@property (nonatomic, strong) MBProgressHUD *successHud;  //首次使用网络请求加载数据时的HUD
@property (nonatomic, assign) BOOL isConnected;  //是否连接了网络

@end

@implementation MGDMineViewController

NSString *ID = @"Recored_cell";
static AFHTTPSessionManager *manager; //单例的AFN

- (void)viewWillAppear:(BOOL)animated {
    _isConnected = false;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tabBar的高度
    CGFloat tabBarHeight;
    if (kIs_iPhoneX) {
        tabBarHeight = 83;
    }else {
        tabBarHeight = 49;
    }
    
    //UITableView的设置
    if (kIs_iPhoneX) {
        self.sportTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0,290, screenWidth, screenHeigth) style:UITableViewStylePlain];
    }else {
      self.sportTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0,265, screenWidth, screenHeigth - tabBarHeight) style:UITableViewStylePlain];
    }
    //去除分割线
    self.sportTableView.separatorStyle = NO;
    self.sportTableView.delegate = self;
    self.sportTableView.dataSource = self;
     self.sportTableView.scrollEnabled =YES;
    [self.view addSubview:self.sportTableView];
    
    [self.sportTableView registerClass:[MGDSportTableViewCell class] forCellReuseIdentifier:ID];
    
    [self buildUI];
    
    //加载数据的操作
    _userSportArray = [[NSMutableArray alloc] init];
    
    /**
     三大数据：
     如果是第一次登陆该账号，则请求网络数据，并且写入缓存
     之后首先读取缓存并展示，同时请求数据，并写入缓存，用于下一次的展示
     列表数据：
     此处如果是首次登陆该账号，则使用网络数据
     如果不是，则首先读取缓存的数据
     如果是第一次打开此程序，然后判断当前网络的状况，如果有网络，则自动刷新，没有网络则不刷新
     之后再跳转到此页面只读取缓存数据
    */
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (!([user objectForKey:@"km"] && [user objectForKey:@"min"] && [user objectForKey:@"cal"]) && ![user boolForKey:@"MineIsCache"]) {
        NSLog(@"==三大数据使用网络请求==");
        [self getBaseInfo];
        [user setBool:YES forKey:@"MineIsCache"];
        [user synchronize];
    }else {
        NSLog(@"==三大数据使用缓存数据==");
        self.baseView.Kmlab.text = [NSString stringWithFormat:@"%.2f",[[user objectForKey:@"km"] floatValue]];
        self.baseView.MinLab.text = [NSString stringWithFormat:@"%d",[[user objectForKey:@"min"] intValue]/60];
        self.baseView.CalLab.text = [NSString stringWithFormat:@"%d",[[user objectForKey:@"cal"] intValue]];
        [self refreshBaseDataCache];
    }
    
    NSData *arrayData = [user objectForKey:@"SportList"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
    NSMutableArray *sportList = [NSMutableArray arrayWithArray:array];
    _userSportArray = sportList;
    if ([user objectForKey:@"SportList"]) {
        NSLog(@"==记录列表的缓存的数据==");
        [self setUpRefresh];
        if ([user boolForKey:@"MineIsFirst"]) {
            [self checkNetWorkTrans];
            [user setBool:NO forKey:@"MineIsFirst"];
            [user synchronize];
        }
    }else {
        NSLog(@"==记录列表的网络数据==");
        if ([user boolForKey:@"MineIsFirst"]) {
            _successHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _successHud.mode = MBProgressHUDModeText;
            _successHud.animationType = MBProgressHUDAnimationZoomOut;
            _successHud.label.text = @" 正在加载中... ";
            [_successHud setOffset:CGPointMake(0, 25)];
        }
        [self getUserSportData];
        [user setBool:NO forKey:@"MineIsFirst"];
        [user synchronize];
    }
    
    //深色模式的适配
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = MGDColor3;
        self.backView.backgroundColor = MGDColor3;
        self.sportTableView.backgroundColor = MGDColor3;
    } else {
        // Fallback on earlier versions
    }
    [self setUpRefresh];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.sportTableView.contentSize = CGSizeMake(0,screenHeigth - 20);
}

- (void)buildUI {
    _backView = [[UIView alloc] init];
    _topview = [[MGDTopView alloc] init];
    _baseView = [[MGDBaseInfoView alloc] init];
    _middleView = [[MGDMiddleView alloc] init];
    
    [_middleView.moreBtn addTarget:self action:@selector(MoreVC) forControlEvents:UIControlEventTouchUpInside];
    
    if (kIs_iPhoneX) {
        _backView.frame = CGRectMake(0, 0, screenWidth, 290);
        _topview.frame = CGRectMake(0,0,screenWidth,136);
        _baseView.frame = CGRectMake(0,136,screenWidth,117);
        _middleView.frame = CGRectMake(0,253,screenWidth,22);
    }else {
        _backView.frame = CGRectMake(0, 0, screenWidth, 265);
        _topview.frame = CGRectMake(0,0,screenWidth,111);
        _baseView.frame = CGRectMake(0,111,screenWidth,117);
        _middleView.frame = CGRectMake(0,228,screenWidth,22);
    }
    //只设置左下角为圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topview.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(50, 50)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.topview.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topview.layer.mask = maskLayer;
    [self.view addSubview:_backView];
    [self.backView addSubview:_topview];
    [self.backView addSubview:_baseView];
    [self.backView addSubview:_middleView];
}

- (void)setUpRefresh {
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.sportTableView.mj_header = _header;
    self.sportTableView.estimatedRowHeight = 0;
    [MGDRefreshTool setUPHeader:_header];
}

- (void)loadNewData {
    [_header beginRefreshing];
    [_userSportArray removeAllObjects];
    [self getUserSportData];
}


#pragma mark- 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  screenHeigth * 0.117;
}

#pragma mark- 数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_userSportArray.count > 5) {
        return 5;
    }else {
        return _userSportArray.count;
    }
}

//转到杨诚的界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MGDSportData *model = _userSportArray[indexPath.row];
    MGDCellDataViewController *detailDataVC = [MGDDataTool DataToMGDCellDataVC:model];
    [self.navigationController pushViewController:detailDataVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建单元格（用复用池）
    MGDSportTableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //展示cell的数据
    if (_userSportArray != nil && ![_userSportArray isKindOfClass:[NSNull class]] && _userSportArray.count != 0) {
        MGDSportData *model = _userSportArray[indexPath.row];
        NSString *date = [MGDTimeTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%@", model.FinishDate]];
        NSDate *currentDate = [NSDate date];
        NSString *currentDateStr = [[MGDTimeTool dateToString:currentDate] substringWithRange:NSMakeRange(5,5)];
        NSString *lastDay = [[MGDTimeTool yesterdayTostring:currentDate] substringWithRange:NSMakeRange(5, 5)];
        if ([date isEqualToString:currentDateStr]) {
            cell.dayLab.text = @"今天";
        }else if ([date isEqualToString:lastDay]) {
            cell.dayLab.text = @"昨天";
        }else {
            cell.dayLab.text = date;
        }
        NSString *time = [MGDTimeTool getTimeStringWithTimeStr:[NSString stringWithFormat:@"%@",model.FinishDate]];
        cell.timeLab.text = time;
        cell.kmLab.text = [NSString stringWithFormat:@"%.2f",[model.distance floatValue] / 1000];
        cell.minLab.text = [NSString stringWithFormat:@"%@",[MGDTimeTool getMMSSFromSS:[NSString stringWithFormat:@"%@", model.totalTime]]];
        cell.calLab.text = [NSString stringWithFormat:@"%d",[model.cal intValue]];
    }else {

    }
    return cell;
}

- (void)MoreVC{
    MGDMoreViewController *moreVC = [[MGDMoreViewController alloc] init];
    moreVC.pageNumber = 1;
    [self.navigationController pushViewController:moreVC animated:YES];
}

//原来的三大数据的网络请求
- (void)getBaseInfo{
    manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    // 响应
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];  //去除空值
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]]; //设置接收内容的格式
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];

    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/getTotalData" parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = responseObject[@"data"];
        self->_currentModel = [MGDUserData DataWithDict:dict];
        [self reloadBaseData:self->_currentModel];
        [user setObject:self->_currentModel.distance forKey:@"km"];
        [user setObject:self->_currentModel.duration forKey:@"min"];
        [user setObject:self->_currentModel.consume forKey:@"cal"];
        [user synchronize];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error); // 404  500
        //MBProgressHUD  服务器异常 请稍后重试
    }];
}

- (void)refreshBaseDataCache {
    manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    // 响应
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];  //去除空值
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]]; //设置接收内容的格式
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];

    [manager POST:TotalDataUrl parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = responseObject[@"data"];
        self->_currentModel = [MGDUserData DataWithDict:dict];
        [user setObject:self->_currentModel.distance forKey:@"km"];
        [user setObject:self->_currentModel.duration forKey:@"min"];
        [user setObject:self->_currentModel.consume forKey:@"cal"];
        [user synchronize];
        NSLog(@"写入新的缓存");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error); // 404  500
        //MBProgressHUD  服务器异常 请稍后重试
    }];
}

//展示跑步总距离的数据
- (void)reloadBaseData:(MGDUserData *)model {
    self.baseView.Kmlab.text = [NSString stringWithFormat:@"%.2f",[model.distance floatValue]];
    self.baseView.MinLab.text = [NSString stringWithFormat:@"%d",[model.duration intValue]/60];
    self.baseView.CalLab.text = [NSString stringWithFormat:@"%d",[model.consume intValue]];
}

//获取近五次的运动记录（只显示五次）
- (void)getUserSportData {
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]];
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [MGDTimeTool dateToString:currentDate];
    NSString *lastDateStr = @"2020-01-01 00:00:00";
    NSDictionary *param = @{@"from_time":lastDateStr,@"to_time":currentDateStr};
    [manager POST:AllSportRecordUrl parameters:param
        success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = responseObject[@"data"];
        NSArray *record = [[NSArray alloc] init];
        record = dict[@"record_list"];
        [self->_userSportArray removeAllObjects];
        for (NSDictionary *dic in record) {
            self->_sportModel = [MGDSportData SportDataWithDict:dic];
            [self->_userSportArray addObject:self->_sportModel];
        }
        self->_userSportArray = [[self->_userSportArray reverseObjectEnumerator] allObjects];
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self->_userSportArray];
        [user setObject:arrayData forKey:@"SportList"];
        [user synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sportTableView reloadData];
        });
        [self.sportTableView.mj_header endRefreshing];
        [self->_successHud removeFromSuperview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.sportTableView.mj_header endRefreshing];
        [self->_successHud removeFromSuperview];
        NSLog(@"报错信息%@", error);
        if (error.code == -1001) {
            self->_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->_hud.mode = MBProgressHUDModeText;
            self->_hud.label.text = @" 网络异常 请稍后重试 ";
            [self->_hud hideAnimated:YES afterDelay:1.5];
        }else {
            self->_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self->_hud.mode = MBProgressHUDModeText;
            self->_hud.label.text = @" 加载失败 ";
            [self->_hud hideAnimated:YES afterDelay:1.5];
        }
    }];
}

- (void)checkNetWorkTrans {
    AFNetworkReachabilityManager *managerAF = [AFNetworkReachabilityManager sharedManager];
    [managerAF startMonitoring];
    [managerAF setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self->_isConnected = true;
                if (self->_isConnected) {
                    [self loadNewData];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self->_isConnected = true;
                if (self->_isConnected) {
                    [self loadNewData];
                }
                NSLog(@"使用WIFI");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self->_isConnected = true;
                if (self->_isConnected) {
                    [self loadNewData];
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self->_isConnected = false;
                NSLog(@"没有连接网络");
                break;
        }
    }];
}

@end
