//
//  ZYLMainViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//


#import "ZYLMainViewController.h"
#import "ZYLMainView.h"
#import "ZYLStartRunningButton.h"
#import "ZYLHostView.h"
#import "ZYLGetTimeScale.h"
#import "ZYLHealthManager.h"
#import "GYYHealthTableViewCell.h"
#import "GYYRunTableViewCell.h"
#import "GYYHealthManager.h"
#import "MRTabBarController.h"
#import <MGJRouter.h>
#import <Masonry.h>
#import "HttpClient.h"
#import "ZYLRunningDataRequest.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import <YYKit.h>
#import <MJExtension.h>

static NSString *const cellIdentifier = @"healthCell";
static NSString *const runCellIdentifier = @"runCell";

@interface ZYLMainViewController ()<UITableViewDelegate, UITableViewDataSource>
{
//    NSInteger todaySteps;
//    NSInteger yesterdaySteps;
//    NSInteger todayStairs;
//    NSInteger yesterdayStairs;
}
//@property (strong, nonatomic) ZYLHostView *hostView;
//@property (nonatomic, strong) NSUserDefaults *user;
//@property (nonatomic, strong) ZYLHealthManager *healthManager;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UILabel *navLab;
@property (nonatomic, strong)UILabel *tempLab;
@property (nonatomic, strong)NSMutableArray *dataArray;  //上拉加载更多  一定要用可变数组
@property (nonatomic, strong)NSMutableArray *runDataArr;

@end

@implementation ZYLMainViewController


- (void)viewWillAppear:(BOOL)animated{  //视图将要出现
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self healthManagerConfig];
}

- (void)viewDidAppear:(BOOL)animated{  //视图已经出现
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        UIColor * rightColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) { //浅色模式
                return [UIColor whiteColor];
            } else { //深色模式
                return [UIColor blackColor];
            }
        }];
        self.view.backgroundColor = rightColor; //根据当前模式(光明\暗黑)-展示相应颜色
    }

//    self.user = [NSUserDefaults standardUserDefaults];
//    self.healthManager = [ZYLHealthManager shareInstance];
//    [self.view addSubview: self.hostView];
//    [self getDataFromHealth];
//    [self.hostView setTextOfStepLab:[NSString stringWithFormat:@"%ld",(long)todaySteps]  andStairLab:[NSString stringWithFormat:@"%ld",(long)todayStairs]];
    [self createSubviews];
    [self requestData];
    //请求成功时发送广播
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"isLoginSuccess" object:nil];
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
    
    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/home" parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求到的数据 = %@", responseObject);
        //hud remove
        NSInteger status = [responseObject[@"status"] integerValue]; //NSNumber
        if (status == 200) { //1.判断请求成功标志   成功，则继续取数据
//            NSDictionary *data = result[@"data"];   //2.1根据数据类型，层层取数据，直至核心数据
            NSArray *classify = responseObject[@"data"];  //2.2取到一个数组
            
//            NSDictionary *runData; //2.3临时容器
//            for (int i = 0; i < classify.count; i++) { //2.4遍历classify数组
//                NSDictionary *tempDic = classify[i];
//                if ([tempDic[@"title"] isEqualToString:@"跑步"]) {
//                    runData = tempDic;
//                    break;
//                }
//            }
//            NSArray *tempArr = runData[@"data"];
            
            
//            self.runDataArr = [GYYRunModel mj_objectArrayWithKeyValuesArray:tempArr];
//            //代码少
//                //用时少  0.001  MJExtension   YYModel
            
//            NSLog(@"%@",responseObject);
//            for (int i = 0; i < classify.count; i++) {
//                NSDictionary *tempDic = classify[i];
//                GYYRunModel *model = [[GYYRunModel alloc] init];
//                [model setValuesForKeysWithDictionary:tempDic];  //KVC  要走好多方法  访问好多成员变量
//               [self.runDataArr addObject:model];
//            }
                                                //对象数组      键值对数组  字典
            self.runDataArr = [GYYRunModel mj_objectArrayWithKeyValuesArray:classify];  //没有 page size 所以直接赋值
            
            
            
            [self.tableView reloadData];
//            NSArray *classify = result[@"data"][@"classify"];
        }else{
            
        }
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error); // 404  500
        //MBProgressHUD  服务器异常 请稍后重试
    }];
}

- (void)healthManagerConfig{
    GYYHealthManager *healthManager = [GYYHealthManager shareInstance];
    [healthManager authorizeHealthKit:^(BOOL success, NSError * _Nonnull error) {
        if (success) {
            __weak typeof(self) weakSelf = self;   //block里避免循环引用，要用__weak 弱引用self    避免循环引用
            __block NSString *todayStais, *yesterdayStairs, *todayStep, *yesterdayStep;  //不是属性的基本类型，要用__block修饰
            
            dispatch_group_t group =  dispatch_group_create();//创建一个任务组
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            //把一个任务异步加到队列
            dispatch_group_enter(group);
            dispatch_async(queue, ^{
                // 追加任务 1
                [healthManager getStairIsToday:YES completion:^(double value, NSError * _Nonnull error) {
                    todayStais = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:value]];
                    NSLog(@"今日阶梯：%@", todayStais);
                    dispatch_group_leave(group);
                }];
            });
            
            dispatch_group_enter(group);
            dispatch_async(queue, ^{
                // 追加任务 2
                [healthManager getStairIsToday:NO completion:^(double value, NSError * _Nonnull error) {
                    yesterdayStairs = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:value]];
                    NSLog(@"昨日阶梯：%@", yesterdayStairs);
                    dispatch_group_leave(group);
                }];
            });
           
            dispatch_group_enter(group);
            dispatch_async(queue, ^{
                // 追加任务 3
                [healthManager getStepCountIsToday:YES completion:^(double value, NSError * _Nonnull error) {
                    todayStep = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:value]];
                    NSLog(@"今日步数：%@", todayStep);
                    dispatch_group_leave(group);
                }];
            });
        
            
            dispatch_group_enter(group);
            dispatch_async(queue, ^{
                // 追加任务 4
                [healthManager getStepCountIsToday:NO completion:^(double value, NSError * _Nonnull error) {
                    yesterdayStep = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:value]];
                    NSLog(@"昨日步数：%@", yesterdayStep);
                    dispatch_group_leave(group);
                }];
            });
            
            
            //监听任务组事件的执行完毕
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                // 等前面的异步任务都执行完毕后，回到主线程执行下边任务
                
                NSMutableDictionary *stepDic = weakSelf.dataArray[0];
                NSMutableDictionary *stairsDic = weakSelf.dataArray[1];
                
                
                [stepDic setObject:(todayStep == nil ? @" 12836" : todayStep)
                            forKey:@"todayData"];
                [stepDic setObject:(yesterdayStep == nil? @"8762":yesterdayStep)
                            forKey:@"yesterdayData"];
                
                [stairsDic setObject:(todayStais == nil ? @"387" : todayStais)
                              forKey:@"todayData"];
                [stairsDic setObject:(yesterdayStairs == nil ? @"411" : yesterdayStairs)
                              forKey:@"yesterdayData"];
                
                
                [weakSelf.tableView reloadData];
                [weakSelf.tableView layoutIfNeeded];
            });
        }else{
            NSLog(@"权限验证失败");
        }
    }];
}

- (void)createSubviews{
    if (@available(iOS 13.0, *)) {
        UIColor *GYYColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return COLOR_WITH_HEX(0xFCFCFC);
            }
            else {
                return COLOR_WITH_HEX(0x3C3F43);
            }
        }];
        self.view.backgroundColor = GYYColor;
    } else {
        self.view.backgroundColor = COLOR_WITH_HEX(0xFCFCFC);
    }
    
    UIView *navView = [[UIView alloc] init];
    [self.view addSubview:navView];
    [navView addSubview:self.navLab];
    [navView addSubview:self.tempLab];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    [_navLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(63);
    }];
    [_tempLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_navLab.mas_centerY).offset(0);
        make.right.mas_equalTo(55);
    }];
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
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTabBarHeight);
        make.top.equalTo(navView.mas_bottom).offset(0);
    }];
}

//- (void) getDataFromHealth{
//    todaySteps = [self.healthManager getTodayStepCount];
//    yesterdaySteps = [self.healthManager getYesterdayStepCount];
//    todayStairs = [self.healthManager getTodayFlightsClimbedCount];
//    yesterdayStairs = [self.healthManager getYesterdayFlightsClimbedCount];
//}

//#pragma mark - 懒加载
//- (ZYLHostView *)hostView{
//    if (!_hostView) {
//        _hostView = [[ZYLHostView alloc] init];
//        _hostView.frame = CGRectMake(0, -kStatusBarHeigh*kRateX, screenWidth, screenHeigth);
//        _hostView.scrollEnabled = YES;
//        _hostView.contentSize = CGSizeMake(screenWidth, screenHeigth+100*kRateY);
//        [_hostView.greetLab setText:[NSString stringWithFormat:@"%@%@", [ZYLGetTimeScale getTimeScaleString], [_user valueForKey:@"nickname"]]];
//
//    }
//    return _hostView;
//}

#pragma mark ======== UITableViewDelegate & UITableViewDataSource ========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {  //分几个区
    return 2;
}



/**
 下面三个方法 必须实现
 */
//每个分区有多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {   //每个区有几个cell
        if (section == 0){
            return self.dataArray.count;
        }else{
            return self.runDataArr.count; //0   4
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {   //每个cell的高度
        if (indexPath.section == 0){
            return 137;
        }else{
            return 137;
        }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.section == 0) {
            GYYHealthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.runDataDic = self.dataArray[indexPath.row];
            return cell;
        }else{
            GYYRunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:runCellIdentifier forIndexPath:indexPath];
            cell.runModel = self.runDataArr[indexPath.row];
            return cell;
        }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //点击触发
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    if (@available(iOS 13.0, *)) {
        UIColor *GYYColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return COLOR_WITH_HEX(0xFCFCFC);
            }
            else {
                return COLOR_WITH_HEX(0x3C3F43);
            }
        }];
        headerView.backgroundColor = GYYColor;
    } else {
        headerView.backgroundColor = COLOR_WITH_HEX(0xFCFCFC);
    }
    
//    if (section == 0) {
    UILabel *headerLab = [[UILabel alloc] init];
    [headerView addSubview:headerLab];
    if (section == 0 ) {     // 只有label.text是不一样的 所以 if else 判断下赋值不同的text 就可以
            
        headerLab.text = @"健康";
    }else{
        headerLab.text = @"跑步";
    }
    headerLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    if (@available(iOS 13.0, *)) {
        headerLab.textColor = [UIColor labelColor];
    } else {
        headerLab.textColor = COLOR_WITH_HEX(0x333739);
        // Fallback on earlier versions
    }
    [headerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        }];
//    }else if (section == 1) {
//        UILabel *headerLab = [[UILabel alloc] init];
//        [headerView addSubview:headerLab];
//        headerLab.text = @"跑步";
//        headerLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
//        headerLab.textColor = COLOR_WITH_HEX(0x333739);
//        [headerLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(15);
//            make.centerY.mas_equalTo(0);
//        }];
//    }
    return headerView;
}

#pragma mark ======== Getter =========
- (UILabel *)navLab{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
      NSString *nickname = [user objectForKey:@"nickname"];
    NSString *Labname = [NSString stringWithFormat:@"上午好，%@",nickname];
    if (!_navLab) {
        _navLab = [[UILabel alloc] init];
        _navLab.text = Labname;
        _navLab.textColor = COLOR_WITH_HEX(0xA0A0A0);
        _navLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    }
    return _navLab;
}
-(UILabel *)tempLab{
    if (!_tempLab) {
        _tempLab = [[UILabel alloc] init];
        _tempLab.text = @"23°C";
        _tempLab.textColor = COLOR_WITH_HEX(0x64686F);
        _tempLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    }
    return _tempLab;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
        _tableView.estimatedRowHeight = 137;
        _tableView.sectionHeaderHeight = 25;
        _tableView.sectionFooterHeight = 0.01;
        [_tableView registerClass:[GYYHealthTableViewCell class] forCellReuseIdentifier:cellIdentifier];
        [_tableView registerClass:[GYYRunTableViewCell class] forCellReuseIdentifier:runCellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (NSMutableArray *)runDataArr{
    if (!_runDataArr) {
        _runDataArr = [NSMutableArray array];
    }
    return _runDataArr;
}
                                      
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        NSMutableDictionary *stepDic = [NSMutableDictionary dictionaryWithDictionary:@{@"icon" : @"homepage_step",
        @"title" : @"步数",
        @"todayData" : @"0",
        @"todayTitle" : @"今日步数",
        @"unit" : @"步",
        @"yesterdayData" : @"0",
        @"yesterdayTitle" : @"昨日步数"
        }];
        
        NSDictionary *stairDic = [NSMutableDictionary
            dictionaryWithDictionary:@{@"icon" : @"homepage_stairs",
        @"title" : @"已爬阶梯",
        @"todayData" : @"0",
        @"todayTitle" : @"今日阶梯",
        @"unit" : @"阶",
        @"yesterdayData" : @"0",
        @"yesterdayTitle" : @"昨日阶梯"
        }];
//        NSDictionary *mileDic = @{@"icon" : @"homepage_kilometer",
//                                  @"title" : @"里程",
//                                  @"todayData" : @"5.42",
//                                  @"todayTitle" : @"今日里程",
//                                  @"unit" : @"公里",
//                                  @"yesterdayData" : @"3.55",
//                                  @"yesterdayTitle" : @"昨日里程"
//                                  };
//        NSDictionary *timeDic = @{@"icon" : @"homepage_time",
//                                  @"title" : @"运动时间",
//                                  @"todayData" : @"4:42",
//                                  @"todayTitle" : @"今日运动时间",
//                                  @"unit" : @"时间",
//                                  @"yesterdayData" : @"3:34",
//                                  @"yesterdayTitle" : @"昨日运动时间"
//                                  };
//        NSDictionary *paceDic = @{@"icon" : @"homepage_pace",
//                                  @"title" : @"步频",
//                                  @"todayData" : @"5.42",
//                                  @"todayTitle" : @"本次里程",
//                                  @"unit" : @"公里",
//                                  @"yesterdayData" : @"3.55",
//                                  @"yesterdayTitle" : @"上次里程"
//                                  };
//        NSDictionary *consumeDic = @{@"icon" : @"homepage_consume",
//                                     @"title" : @"消耗",
//                                     @"todayData" : @"4:42",
//                                     @"todayTitle" : @"今日运动时间",
//                                     @"unit" : @"时间",
//                                     @"yesterdayData" : @"3:34",
//                                     @"yesterdayTitle" : @"昨日运动时间"
//                                     };
        [_dataArray addObject:stepDic];
        [_dataArray addObject:stairDic];
//        [_dataArray addObject:mileDic];
//        [_dataArray addObject:timeDic];
//        [_dataArray addObject:paceDic];
//        [_dataArray addObject:consumeDic];
    }
        return _dataArray;
}
@end
