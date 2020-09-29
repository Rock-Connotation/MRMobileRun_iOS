//
//  MGDMoreViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/13.


#import "MGDMoreViewController.h"
#import "MGDSportTableViewCell.h"
#import "MGDColumnChartView.h"
#import "YBPopupMenu.h"
#import "MRTabBarController.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "MGDSportData.h"
#import "MGDCellDataViewController.h"
#import "MBProgressHUD.h"



//此处遵守自定义的MGDColumnChartView的协议，用于切换年份的操作
@interface MGDMoreViewController () <UITableViewDelegate,UITableViewDataSource,MGDColumnChartViewDelegate,YBPopupMenuDelegate,UIGestureRecognizerDelegate> {
    BOOL _isShowSec;
    NSArray *_selectArr;
    MJRefreshBackNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
}

//用于展示页面第一次加载出来时的柱形图数据模型的数组
@property (nonatomic, strong) NSMutableArray *recordArray;
//用于展示改变年份后的柱形图数据模型的数组
@property (nonatomic, strong) NSMutableArray *tmpArray;
//用于展示列表数据的数组数据模型的数组
@property (nonatomic, strong) NSMutableArray *cellListArray;
//列表数据模型
@property (nonatomic, strong) MGDSportData *userDataModel;
//柱形图数组
@property (nonatomic, strong) NSMutableArray *chartArr;
//加载数据失败时的hud
@property (nonatomic, strong) MBProgressHUD *hud;
//首次使用网络请求加载数据时的hud
@property (nonatomic, strong) MBProgressHUD *successHud;

@end

@implementation MGDMoreViewController

- (NSMutableArray *)chartArr
{
    if (_chartArr == nil) {
        _chartArr = [NSMutableArray array];
    }
    return _chartArr;
}


NSString *ID1 = @"Sport_cell";
static int page = 1;
static bool isConnected = false;
static AFHTTPSessionManager *manager; //单例的AFN

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.title = @"运动记录";
    
    //自定义的返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setImage:[UIImage imageNamed:@"返回箭头4"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //UI布局
    if (kIs_iPhoneX) {
        _recordTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0, 361, screenWidth, screenHeigth - 361) style:UITableViewStylePlain];
    }else {
        _recordTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0, 341, screenWidth, screenHeigth - 341) style:UITableViewStylePlain];
    }
    
    //UITableView的一些设置
    _recordTableView.separatorStyle = NO; //取消分割线
    _recordTableView.delegate = self;
    _recordTableView.dataSource = self;
    [self.view addSubview:_recordTableView];
    [_recordTableView registerClass:[MGDSportTableViewCell class] forCellReuseIdentifier:ID1];
    
    //深色模式颜色的适配
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = MGDColor3;
        self.recordTableView.backgroundColor = MGDColor1;
        self.backView.backgroundColor = MGDColor1;
        self.navigationController.navigationBar.barTintColor = MGDColor1;
        self.navigationController.navigationBar.tintColor = MGDTextColor1;
       } else {
           // Fallback on earlier versions
    }
    
    //加载数据的操作
    _recordArray = [[NSMutableArray alloc] init];
    _cellListArray = [[NSMutableArray alloc] init];
    _tmpArray = [[NSMutableArray alloc] init];
    
    //获取缓存中的数据
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSData *ColumnData = [user objectForKey:@"SportMoreList"]; //柱形图的数据
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:ColumnData];
    NSMutableArray *ColumnArray = [NSMutableArray arrayWithArray:array];
    
    NSData *cellarrayData = [user objectForKey:@"CellData"]; //跑步列表的数据
    NSArray *cellarray = [NSKeyedUnarchiver unarchiveObjectWithData:cellarrayData];
    NSMutableArray *listArray = [NSMutableArray arrayWithArray:cellarray];
    _recordArray = ColumnArray;
    _cellListArray = listArray;
    
    /**
     此处如果是首次登陆该账号，则使用网络数据
     如果不是，则首先读取缓存的数据
     如果是第一次打开此程序，然后判断当前网络的状况，如果有网络，则自动刷新，没有网络则不刷新
     之后再跳转到此页面只读取缓存数据
     */
   if (([user objectForKey:@"SportMoreList"] && [user objectForKey:@"CellData"]) || [user boolForKey:@"MoreIsCache"]) {
        NSLog(@"=====使用缓存数据=====");
        [self setUpRefresh];
        [self getCache:^(NSMutableArray *recordList) {
            [self loadmoreDataWithPageWithCache];
            [self setUI];
        }];
        if ([user boolForKey:@"MoreIsFirst"]) {
            [self checkNetWorkTrans];
            [user setBool:NO forKey:@"MoreIsFirst"];
            [user synchronize];
        }
    }else {
        NSLog(@"=====使用网络数据=====");
        [self setUpRefresh];
        _successHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _successHud.animationType = MBProgressHUDAnimationZoomOut;
        _successHud.mode = MBProgressHUDModeText;
        _successHud.label.text = @" 正在加载中... ";
        CGFloat margin = 0;
        if (kIs_iPhoneX) {
            margin = 361+20 - self.view.center.y;
        }else {
            margin = 361+20 - self.view.center.y;
        }
        [_successHud setOffset:CGPointMake(0, margin)];
        [self getRecordList:^(NSMutableArray *recordList) {
            [self loadmoreDataWithPage:self->_pageNumber];
            [self setUI];
        }];
        [user setBool:YES forKey:@"MoreIsCache"];
        [user setBool:NO forKey:@"MoreIsFirst"];
        [user synchronize];
    }
    
    //设置右滑返回的手势
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    //handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; //设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; //禁止系统自带的滑动手势
    
    //关闭预估高度的效果
    self.recordTableView.estimatedRowHeight = 0;
    self.recordTableView.estimatedSectionHeaderHeight = 0;
    self.recordTableView.estimatedSectionFooterHeight = 0;
}


- (void)handleNavigationTransition:(UIPanGestureRecognizer *)pan
{
    NSLog(@"右滑返回"); //自定义滑动手势
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}

//返回上一个控制器
- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}

//进行UI的布局
- (void)setUI {
     CGFloat navigationBarAndStatusBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (kIs_iPhoneX) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 370)];
        _columnChartView = [[MGDColumnChartView alloc] initWithFrame:CGRectMake(0, navigationBarAndStatusBarHeight, screenWidth, 228)];
        _divider = [[UIView alloc] initWithFrame:CGRectMake(0, 344, screenWidth, 1)];
    }else {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 348)];
        _columnChartView = [[MGDColumnChartView alloc] initWithFrame:CGRectMake(0, navigationBarAndStatusBarHeight, screenWidth, 228)];
        _divider = [[UIView alloc] initWithFrame:CGRectMake(0, 322, screenWidth, 1)];
    }

    //设置年份
    NSDate *date =[NSDate date];
    _columnChartView.yearName = [self dateToYear:date];
    _columnChartView.delegate = self;
    [self.view addSubview:_backView];
    [self.backView addSubview:_columnChartView];
    
    //深色模式的适配
    if (@available(iOS 11.0, *)) {
        self.divider.backgroundColor = MGDdividerColor;
        self.recordTableView.backgroundColor = MGDColor3;
    } else {
        // Fallback on earlier versions
    }
    
    [self.view addSubview:_divider];
    _isShowSec = false;
    _selectArr = [self columnYearLabelYear];
}

//设置关于列表刷新的相关文字
- (void)setUpRefresh {
    //上滑加载的设置
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_footer setTitle:@"上滑加载更多" forState:MJRefreshStateIdle];
    [_footer setTitle:@"上滑加载更多" forState:MJRefreshStatePulling];
    [_footer setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    self.recordTableView.mj_footer = _footer;
    
    //下拉刷新的设置
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadnewData)];
    [_header setTitle:@"正在刷新中………"forState:MJRefreshStateRefreshing];
    [_header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [_header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    self.recordTableView.mj_header = _header;
    self.recordTableView.estimatedRowHeight = 0;
    
    //刷新字体的深色模式适配
    if (@available(iOS 11.0, *)) {
        _header.stateLabel.textColor = MGDTextColor1;
        _footer.stateLabel.textColor = MGDTextColor1;
        } else {
               // Fallback on earlier versions
    }
}

/**
 首次登陆此账号时的网络请求，获取柱形图的数据，同时写入缓存，并且在block中请求列表的数据
 */
- (void)getRecordList:(void(^)(NSMutableArray *recordList))result {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]];
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [self dateToString:currentDate];
    NSString *lastDateStr = [self lastDateTostring:currentDate];
    NSDictionary *param = @{@"from_time":lastDateStr,@"to_time":currentDateStr};
    [manager POST:AllSportRecordUrl parameters:param
          success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = responseObject[@"data"];
        NSArray *record = [[NSArray alloc] init];
        record = dict[@"record_list"];
        for (NSDictionary *dic in record) {
            self->_userDataModel = [MGDSportData SportDataWithDict:dic];
            [self->_recordArray addObject:self.userDataModel];
        }
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self->_recordArray];
        [user setObject:arrayData forKey:@"SportMoreList"];
        [user synchronize];
        [self makeListData:self->_recordArray];
        //通过block把值传出来
        dispatch_async(dispatch_get_main_queue(), ^{
            result(self->_recordArray);
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error);
        [self->_successHud removeFromSuperview];
        self->_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->_hud.mode = MBProgressHUDModeText;
        self->_hud.label.text = @" 加载失败 ";
        [self->_hud hideAnimated:YES afterDelay:1.5];
    }];
}

/**
 上滑加载时，调用此方法，加载新的数据
 */
- (void) loadMoreData {
    [self.recordTableView.mj_footer beginRefreshing];
    if (_footer.state == MJRefreshStateNoMoreData) {
        [_footer endRefreshingWithNoMoreData];
    }
    //上滑时count++进行查询
    page++;
    _pageNumber = page;
    [self loadmoreDataWithPage:_pageNumber];
}

/**
 下拉刷新时，清除之前的数据，重新加载新的数据
 */
- (void) loadnewData {
    [self.recordTableView.mj_header beginRefreshing];
    page = 1;
    self->_pageNumber = page;
    [self loadmoreDataWithPageRefresh:self->_pageNumber];
}

/**
加载新的数据，同时写入缓存，没有数据时则设置footer的状态，没有网络时提示加载失败
 */
- (void)loadmoreDataWithPage:(int)page {
    manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]];
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    NSDictionary *param = @{@"page":[NSString stringWithFormat:@"%d",_pageNumber],@"count":@"5"};
    [manager POST:SportListUrl parameters:param
          success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = responseObject[@"data"];
        NSArray *record = [[NSArray alloc] init];
        record = dict[@"record_list"];
        //还有数据时继续查询，没有数据了改变状态为没有数据
        if (record.count > 0) {
            for (NSDictionary *dic in record) {
                self->_userDataModel = [MGDSportData SportDataWithDict:dic];
                [self->_cellListArray addObject:self.userDataModel];
            }
            [self cleanZeroData:self->_cellListArray];
            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self->_cellListArray];
            [user setObject:arrayData forKey:@"CellData"];
            [user synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.recordTableView reloadData]; //列表数据刷新
                [self.recordTableView layoutIfNeeded]; //停止刷新
            });
            [self.recordTableView.mj_footer endRefreshing];
        }else {
            self->_footer.state = MJRefreshStateNoMoreData; //改变状态
        }
            [self->_successHud removeFromSuperview]; //移除加载中的successHud
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error);
        [self.recordTableView.mj_footer endRefreshing];
        self->_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->_hud.animationType = MBProgressHUDAnimationZoomOut;
        self->_hud.mode = MBProgressHUDModeText;
        self->_hud.label.text = @" 加载失败 ";
        [self->_hud setOffset:CGPointMake(0, 25)];
        [self->_hud hideAnimated:YES afterDelay:1.2];
    }];
}

/**
 刷新新的数据后，清除之前的数据，加载新的数据，并且写入缓存,没有网络时提示刷新失败
 */
- (void)loadmoreDataWithPageRefresh:(int)page {
    manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]];
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    NSDictionary *param = @{@"page":[NSString stringWithFormat:@"%d",_pageNumber],@"count":@"5"};
    [manager POST:SportListUrl parameters:param
          success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = responseObject[@"data"];
        NSArray *record = [[NSArray alloc] init];
        record = dict[@"record_list"];
        [self->_cellListArray removeAllObjects];
        //还有数据时继续查询，没有数据了改变状态为没有数据
        if (record.count > 0) {
            for (NSDictionary *dic in record) {
                self->_userDataModel = [MGDSportData SportDataWithDict:dic];
                [self->_cellListArray addObject:self.userDataModel];
            }
            [self cleanZeroData:self->_cellListArray];
            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self->_cellListArray];
            [user setObject:arrayData forKey:@"CellData"];
            [user synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                //列表数据刷新
                [self.recordTableView reloadData];
                [self.recordTableView layoutIfNeeded];
                [self.recordTableView.mj_header endRefreshing];  //停止刷新
            });
        }else {
            self->_footer.state = MJRefreshStateNoMoreData;  //改变状态
        }
        [self.recordTableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error);
        [self.recordTableView.mj_header endRefreshing];
        self->_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->_hud.animationType = MBProgressHUDAnimationZoomOut;
        self->_hud.mode = MBProgressHUDModeText;
        self->_hud.label.text = @" 刷新失败 ";
        [self->_hud setOffset:CGPointMake(0, 25)];
        [self->_hud hideAnimated:YES afterDelay:1.2];
    }];
}

/**
 通过缓存读取数据
 */
- (void)loadmoreDataWithPageWithCache{
    [self setUpRefresh];
    dispatch_async(dispatch_get_main_queue(), ^{
        //列表数据刷新
        [self.recordTableView reloadData];
        [self.recordTableView layoutIfNeeded];
        //停止刷新
    });
    [self.recordTableView.mj_footer endRefreshing];
}

- (void)changeYearClick:(MGDColumnChartView *)chartView sender:(UIButton *)sender
{
    [self showYearSelect:sender];
}

//判断月份并且截取月份，设置当月为"本月"
- (NSArray *)columnChartTitleArrayYear:(NSString *)year {
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];

    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    NSMutableArray *monthArray = [NSMutableArray arrayWithArray:@[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"]];
    NSString *month = @"月";
    NSMutableArray *nowArray = [NSMutableArray new];
    if ([year isEqualToString:[NSString stringWithFormat: @"%ld", (long)currentYear]]) {
        for (int i = 0;i < monthArray.count; i++) {
            NSString *nowMonth = [NSString stringWithFormat:@"%d", i+1];
            if ([nowMonth isEqualToString:[NSString stringWithFormat:@"%ld", (long)currentMonth]]) {
                [nowArray addObject:@"本月"];
                break;
            }
            [nowArray addObject:[[NSString stringWithFormat:@"%d", i+1] stringByAppendingString:month]];
        }
        return [nowArray copy];
    }else {
        return [monthArray copy];
    }
}

//获取当前的年份，并且设置列表的年份为 上一年，本年，下一年
- (NSArray *)columnYearLabelYear {
    NSMutableArray *yearArray = [NSMutableArray new];
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    for (int i = 2;i >= 0; i--) {
        [yearArray addObject:[NSString stringWithFormat:@"%ld",(long)(currentYear  - i)]];
    }
    return [yearArray copy];
}

//获取柱形图的数据，无数据设为0
- (NSArray *)columnChartNumberArrayFor:(NSString *)itemName index:(NSInteger)index year:(NSString *)year {
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = self.chartArr[index];
    for (NSInteger i = 0; i < 31; i++) {
        NSString* point = [NSString stringWithFormat:@"%ld", (long)i];
        if (point.length == 1) {
            point = [NSString stringWithFormat:@"0%@", point];
        }
        NSString *num = dic[point];
        if (num) {
            [arr addObject:num];
        }else {
            [arr addObject:@"0"];
        }
    }
    return arr;
}

- (void)showYearSelect:(UIButton *)sender {
    [YBPopupMenu showRelyOnView:sender titles:_selectArr icons:@[@"", @"", @""] menuWidth:180 delegate:self];
}

/**
 点击年份来查询柱形图，从年初到年尾的全部数据，没有网络时提醒无网络连接
 */
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    NSString *year = _selectArr[index];
    NSLog(@"这是当前的年份----%@",year);
    NSDate *mydate=[NSDate date];
    NSString *currentYear = [self dateToYear:mydate];
    if ([year isEqualToString:currentYear]) {
         NSLog(@"%@-------%@",year,currentYear);
    }
    manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]];
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    NSString *currentDateStr = [year stringByAppendingString:@"-12-31 11:59:59"];
    NSString *lastDateStr = [year stringByAppendingFormat:@"-01-01 00:00:00"];
    NSDictionary *param = @{@"from_time":lastDateStr,@"to_time":currentDateStr};
    NSLog(@"%@",param);
    [manager POST:SportListUrl parameters:param
          success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tmpArray removeAllObjects];
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = responseObject[@"data"];
        NSArray *record = [[NSArray alloc] init];
        record = dict[@"record_list"];
        for (NSDictionary *dic in record) {
            self->_userDataModel = [MGDSportData SportDataWithDict:dic];
            [self->_tmpArray addObject:self.userDataModel];
        }
        self->_tmpArray =  [[self->_tmpArray reverseObjectEnumerator] allObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
        [self makeListData:self->_tmpArray];
        NSLog(@"刷新年份数据");
    });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        self->_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self->_hud.animationType = MBProgressHUDAnimationZoomOut;
        self->_hud.mode = MBProgressHUDModeText;
        self->_hud.label.text = @" 无网络连接 ";
        [self->_hud setOffset:CGPointMake(0, 25)];
        [self->_hud hideAnimated:YES afterDelay:1.2];
    }];
    self.columnChartView.yearName = year;
    [self.columnChartView reloadData];
}


#pragma mark- 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  screenHeigth * 0.117;
}

#pragma mark- 数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellListArray.count;
}


//转到杨诚的界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    MGDSportData *model = _cellListArray[indexPath.row];

    MGDCellDataViewController *detailDataVC = [[MGDCellDataViewController alloc] init];
        //距离
    detailDataVC.distanceStr = [NSString stringWithFormat:@"%.2f",[model.distance floatValue]/1000];
    //日期
    detailDataVC.date = [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@", model.FinishDate]];
    //时间
    detailDataVC.time = [self getTimeStringWithTimeStr:[NSString stringWithFormat:@"%@",model.FinishDate]];
    //速度
    detailDataVC.speedStr = [self getAverageSpeed:[NSString stringWithFormat:@"%0.2f",[model.AverageSpeed floatValue]]];
    //步频
    detailDataVC.stepFrequencyStr = [NSString stringWithFormat:@"%d",[model.AverageStepFrequency intValue]];
    //跑步时长
    detailDataVC.timeStr = [self getRunTimeFromSS:model.totalTime];
    //卡路里
    detailDataVC.energyStr = [NSString stringWithFormat:@"%d",[model.cal intValue]];
    //最大速度
    detailDataVC.MaxSpeed = [NSString stringWithFormat:@"%0.2f",[model.MaxSpeed floatValue]];
    //最大步频
    detailDataVC.MaxStepFrequency = [NSString stringWithFormat:@"%d",[model.MaxStepFrequency intValue]];
    //温度
    detailDataVC.degree = [NSString stringWithFormat:@"%d°C",[model.Temperature intValue]];

    //步频数组，用于画图
    detailDataVC.stepFrequencyArray = [self DataViewArray:model.StepFrequencyArray];
    
    //速度数组，用于画图
    detailDataVC.speedArray = [self DataViewArray:model.SpeedArray];
    
    //路径数组，用于绘制轨迹
    detailDataVC.locationAry = [self DataViewArray:model.pathArray];
//    detailDataVC.userIconStr = [user objectForKey:@"avatar_url"];
//    detailDataVC.userNmaeStr = [user objectForKey:@"nickname"];
    [self.navigationController pushViewController:detailDataVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //创建单元格（用复用池）
    MGDSportTableViewCell* cell = nil;
    cell.backgroundColor = [UIColor clearColor];
    cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    if (_recordArray != nil && ![_recordArray isKindOfClass:[NSNull class]] && _recordArray.count != 0) {
        MGDSportData *model = _cellListArray[indexPath.row];
        NSString *date = [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@", model.FinishDate]];
        //获取当前时间来判断，如果是昨天或者今天的数据则显示为文字，否则显示为日期
        NSDate *currentDate = [NSDate date];
        NSString *currentDateStr = [[self dateToString:currentDate] substringWithRange:NSMakeRange(5,5)];
        NSString *lastDay = [[self yesterdayTostring:currentDate] substringWithRange:NSMakeRange(5, 5)];
        if ([date isEqualToString:currentDateStr]) {
            cell.dayLab.text = @"今天";
        }else if ([date isEqualToString:lastDay]) {
            cell.dayLab.text = @"昨天";
        }else {
            cell.dayLab.text = date;
        }
        //展示cell上的数据
        NSString *time = [self getTimeStringWithTimeStr:[NSString stringWithFormat:@"%@",model.FinishDate]];
        cell.timeLab.text = time;
        cell.kmLab.text = [NSString stringWithFormat:@"%.2f",[model.distance floatValue]/1000];
        cell.minLab.text = [NSString stringWithFormat:@"%@",[self getMMSSFromSS:[NSString stringWithFormat:@"%@", model.totalTime]]];
        cell.calLab.text = [NSString stringWithFormat:@"%d",[model.cal intValue]];
        
        return cell;
    }else {
      return cell;
    }
}


/**
 通过缓存获取柱形图的数据
 */
- (void)getCache:(void(^)(NSMutableArray *recordList))result {
    [self.chartArr removeAllObjects];
    [self makeListData:self->_recordArray];
        //通过block把值传出来
    dispatch_async(dispatch_get_main_queue(), ^{
            result(self->_recordArray);
        });
}

//返回当前的时间（网络请求时返回的字典内容）
- (NSString *) dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

- (NSString *) dateToYear:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//返回去年的时间（网络请求时返回的字典内容）
- (NSString *) lastDateTostring:(NSDate *)date {
    NSDate *mydate=[NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:-1];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    return [self dateToString:newdate];
}

//返回昨天
- (NSString *) yesterdayTostring:(NSDate *)date {
    NSDate *mydate=[NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:-1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    return [self dateToString:newdate];
}

//秒数转换成时分秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    NSString *str_minute = [[NSString alloc] init];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)seconds%60];
    if (seconds >= 6000) {
        str_minute = [NSString stringWithFormat:@"%03ld",(long)(seconds%3600)/60];
    }else {
        str_minute = [NSString stringWithFormat:@"%02ld",(long)(seconds%3600)/60];
    }
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

//跑步时间的字符串
-(NSString *)getRunTimeFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

//时间戳换成日期
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue];
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}


//时间戳换成具体的时间
- (NSString *)getTimeStringWithTimeStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

//配速的字符串
- (NSString *)getAverageSpeed:(NSString *)averagespeed {
    NSArray  *array = [averagespeed componentsSeparatedByString:@"."];
    NSString *speed = [NSString stringWithFormat:@"%@'%@''",array[0],array[1]];
    return speed;
}

/**
 用于展示柱形图的柱子，从月份获取到天，累加每一天的数据，没有数据设置为0
 */
- (void)makeListData:(NSArray *)array {
    NSInteger count = 12;
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        [dataArr addObject:[NSMutableDictionary dictionary]];
    }
    for (MGDSportData *model in array) {
        NSString *date = [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@", model.FinishDate]];
        //以-符号来分割字符串
        NSArray *arr = [date componentsSeparatedByString:@"-"];
        if (arr.count > 1) {
            NSInteger count = [arr.firstObject integerValue] - 1;
            NSMutableDictionary *monthDic = dataArr[count];

            NSString* dayNum = arr[1];
            NSString* runNum = monthDic[dayNum];

            //累加每一天的走路
            if (runNum) {
                CGFloat runTemp = [NSString stringWithFormat:@"%.2f",[model.distance floatValue]].floatValue/1000;
                CGFloat all = runTemp + runNum.floatValue;
                monthDic[dayNum] = [NSString stringWithFormat:@"%.2f", all];

            }else {
                monthDic[dayNum] = [NSString stringWithFormat:@"%.2f",[model.distance floatValue]/1000];
            }
        }

    }
    [self.chartArr removeAllObjects];
    [self.chartArr addObjectsFromArray:dataArr];
    [self.columnChartView reloadData];
}

//拆去获取到的杨诚所需的数组的中括号
- (NSArray *)DataViewArray:(NSArray *)dataArr {
    NSString *CLASS = [NSString stringWithFormat:@"%@",[dataArr class]];
    if ([CLASS isEqualToString:@"__NSSingleObjectArrayI"]) {
        return @[];
    }else {
        NSMutableArray *test = [dataArr mutableCopy];
        NSString *s = test.lastObject;
        [test removeLastObject];
        s = [s substringToIndex:s.length - 2];
        [test addObject:s];
        return [test copy];
    }
}

//解决杨诚上传的空数组的BUG，如果时间戳为0的话，去除该数据
- (NSMutableArray *)cleanZeroData:(NSMutableArray *)array {
   NSArray * TempArray = [NSArray arrayWithArray:array];
    for (MGDSportData *model in TempArray) {
        NSString *date = [NSString stringWithFormat:@"%@",model.FinishDate];
        if ([date isEqualToString:@"0"]) {
            [array removeObject:model];
        }
    }
    return array;
}

//判断当前网络连接的情况，如果此时有网络，且是第一次打开该程序，则自动刷新，否则不刷新
- (void)checkNetWorkTrans {
    AFNetworkReachabilityManager *managerAF = [AFNetworkReachabilityManager sharedManager];
    [managerAF setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                isConnected = true;
                if (isConnected) {
                    [self loadnewData];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                isConnected = true;
                if (isConnected) {
                    [self loadnewData];
                }
                NSLog(@"使用WIFI");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                isConnected = true;
                if (isConnected) {
                    [self loadnewData];
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                isConnected = false;
                NSLog(@"没有连接网络");
                break;
        }
    }];
    [managerAF startMonitoring];
}

@end

