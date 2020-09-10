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
#import "HttpClient.h"

#define BACKGROUNDCOLOR [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]
#define DIVIDERCOLOR [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]

@interface MGDMoreViewController ()<UITableViewDelegate,UITableViewDataSource,MGDColumnChartViewDelegate,YBPopupMenuDelegate,UIGestureRecognizerDelegate> {
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

@property (nonatomic, strong) MBProgressHUD *hud;

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
static bool iscache = false;
static int page = 1;
static AFHTTPSessionManager *manager;

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //设置返回按钮的颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"运动记录";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setImage:[UIImage imageNamed:@"返回箭头4"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    if (kIs_iPhoneX) {
        _recordTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0, 370, screenWidth, screenHeigth - 370) style:UITableViewStylePlain];
    }else {
        _recordTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0, 348, screenWidth, screenHeigth -348) style:UITableViewStylePlain];
    }
    _recordTableView.separatorStyle = NO;
    _recordTableView.delegate = self;
    _recordTableView.dataSource = self;
    [self.view addSubview:_recordTableView];
    [_recordTableView registerClass:[MGDSportTableViewCell class] forCellReuseIdentifier:ID1];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = MGDColor3;
        self.recordTableView.backgroundColor = MGDColor1;
        self.backView.backgroundColor = MGDColor1;
        self.navigationController.navigationBar.barTintColor = MGDColor1;
        self.navigationController.navigationBar.tintColor = MGDTextColor1;
       } else {
           // Fallback on earlier versions
    }
    _recordArray = [[NSMutableArray alloc] init];
    _tmpArray = [[NSMutableArray alloc] init];
    _cellListArray = [[NSMutableArray alloc] init];
    [self.recordTableView reloadData];
    NSData *arrayData = [user objectForKey:@"SportMoreList"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
    NSMutableArray *columnArray = [NSMutableArray arrayWithArray:array];
    
    NSData *cellarrayData = [user objectForKey:@"CellData"];
    NSArray *cellarray = [NSKeyedUnarchiver unarchiveObjectWithData:cellarrayData];
    NSMutableArray *listArray = [NSMutableArray arrayWithArray:cellarray];
    _recordArray = columnArray;
    _cellListArray = listArray;
    if (([user objectForKey:@"SportMoreList"] && [user objectForKey:@"CellData"]) && iscache) {
        NSLog(@"=====更多页面使用缓存数据=====");
        [self setUpRefresh];
        [self getCache:^(NSMutableArray *recordList) {
            [self loadmoreDataWithPageWithCache];
            [self setUI];
        }];
    }else {
        NSLog(@"=====更多页面使用网络数据=====");
        [self setUpRefresh];
        _successHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _successHud.animationType = MBProgressHUDAnimationZoomOut;
        _successHud.mode = MBProgressHUDModeText;
        _successHud.label.text = @" 正在加载中... ";
        [_successHud setOffset:CGPointMake(0, 25)];
        [self getRecordList:^(NSMutableArray *recordList) {
            [self loadmoreDataWithPage:self->_pageNumber];
            [self setUI];
        }];
        iscache = true;
    }
    
    //设置右滑返回
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    //handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //UITableView返回时contentOffset还在原来的位置
    self.recordTableView.estimatedRowHeight = 0;
    self.recordTableView.estimatedSectionHeaderHeight = 0;
    self.recordTableView.estimatedSectionFooterHeight = 0;
}


- (void)handleNavigationTransition:(UIPanGestureRecognizer *)pan
{
    //自定义滑动手势
    NSLog(@"右滑返回");
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1)
    {
        return NO;
    }
    return YES;
}


- (void) back {
    //self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setUI {
     CGFloat navigationBarAndStatusBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (kIs_iPhoneX) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 370)];
        _columnChartView = [[MGDColumnChartView alloc] initWithFrame:CGRectMake(0, navigationBarAndStatusBarHeight, screenWidth, 228)];
        _divider = [[UIView alloc] initWithFrame:CGRectMake(0, 344, screenWidth, 1)];
    }else {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 348)];
        _columnChartView = [[MGDColumnChartView alloc] initWithFrame:CGRectMake(0, navigationBarAndStatusBarHeight, screenWidth, 258)];
        _divider = [[UIView alloc] initWithFrame:CGRectMake(0, 322, screenWidth, 1)];
    }

    NSDate *date =[NSDate date];
    _columnChartView.yearName = [self dateToYear:date];
    _columnChartView.delegate = self;
    [self.view addSubview:_backView];
    [self.backView addSubview:_columnChartView];
    
    
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

- (void)setUpRefresh {
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_footer setTitle:@"上滑加载更多" forState:MJRefreshStateIdle];
    [_footer setTitle:@"上滑加载更多" forState:MJRefreshStatePulling];
    [_footer setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    self.recordTableView.mj_footer = _footer;
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadnewData)];
    //_header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:@"正在刷新中………"forState:MJRefreshStateRefreshing];
    [_header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [_header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    self.recordTableView.mj_header = _header;
    self.recordTableView.estimatedRowHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        _header.stateLabel.textColor = MGDTextColor1;
        _footer.stateLabel.textColor = MGDTextColor1;
        } else {
               // Fallback on earlier versions
    }
}

- (void)loadMoreData {
    [self.recordTableView.mj_footer beginRefreshing];
    if (_footer.state == MJRefreshStateNoMoreData) {
        [_footer endRefreshingWithNoMoreData];
    }
    //上滑时count++进行查询
    page++;
    _pageNumber = page;
    [self loadmoreDataWithPage:_pageNumber];
}

- (void)loadnewData{
    [self.recordTableView.mj_header beginRefreshing];
    page = 1;
    self->_pageNumber = page;
    [self loadmoreDataWithPageRefresh:self->_pageNumber];
}

- (void)loadmoreDataWithPage:(int)page {
    manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]];
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    NSDictionary *param = @{@"page":[NSString stringWithFormat:@"%d",_pageNumber],@"count":@"12"};
    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/getSportRecordList" parameters:param
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
            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self->_cellListArray];
            [user setObject:arrayData forKey:@"CellData"];
            [user synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                //列表数据刷新
                [self.recordTableView reloadData];
                [self.recordTableView layoutIfNeeded];
                //停止刷新
            });
            [self.recordTableView.mj_footer endRefreshing];
        }else {
            //改变状态
            self->_footer.state = MJRefreshStateNoMoreData;
        }
        [self->_successHud removeFromSuperview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error);
    }];
}

- (void)loadmoreDataWithPageRefresh:(int)page {
    manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]];
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    NSDictionary *param = @{@"page":[NSString stringWithFormat:@"%d",_pageNumber],@"count":@"12"};
    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/getSportRecordList" parameters:param
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
            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self->_cellListArray];
            [user setObject:arrayData forKey:@"CellData"];
            [user synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                //列表数据刷新
                [self.recordTableView reloadData];
                [self.recordTableView layoutIfNeeded];
                [self.recordTableView.mj_header endRefreshing];
                //停止刷新
            });
        }else {
            //改变状态
            self->_footer.state = MJRefreshStateNoMoreData;
        }
        [self.recordTableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error);
    }];
}

- (void)loadmoreDataWithPageWithCache{
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

//判断月份
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

//获取年份
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

//柱形图的数据，无数据设为0
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
    [YBPopupMenu showRelyOnView:sender titles:_selectArr icons:@[@"", @"", @"", @"", @""] menuWidth:180 delegate:self];
}

//点击年份，查询不同的年份
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {

    [self.tmpArray removeAllObjects];
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
    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/getAllSportRecord" parameters:param
          success:^(NSURLSessionDataTask *task, id responseObject) {
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
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error);
    }];
    self.columnChartView.yearName = year;
    [self.columnChartView reloadData];
}



#pragma mark- 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  78;
}

#pragma mark- 数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellListArray.count;
}


//转到杨诚的界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    NSLog(@"步频数组----%@",detailDataVC.stepFrequencyArray);
    NSLog(@"路径数组----%@",detailDataVC.speedArray);
    detailDataVC.locationAry = [self DataViewArray:model.pathArray];
    
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


//网络请求
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
    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/getAllSportRecord" parameters:param
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
        //[self.recordTableView reloadData];
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
        iscache = false;
    }];
}

- (void)getCache:(void(^)(NSMutableArray *recordList))result {
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
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",(long)seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
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


@end
