//
//  MGDMineViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/10.
//

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

#define BACKGROUNDCOLOR [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]


@interface MGDMineViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *userSportArray;
}

@property (nonatomic, strong) MGDUserData *currentModel;
@property (nonatomic, strong) MGDSportData *sportModel;
@property (nonatomic, strong) NSUserDefaults *user;

@end

@implementation MGDMineViewController

NSString *ID = @"Recored_cell";

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBaseInfo];
    [self getUserSportData];
    userSportArray = [[NSMutableArray alloc] init];
    CGFloat tabBarHeight;
    if (kIs_iPhoneX) {
        tabBarHeight = 83;
    }else {
        tabBarHeight = 49;
    }
    self.sportTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0,0, screenWidth, screenHeigth - tabBarHeight) style:UITableViewStylePlain];
    [self scrollViewDidScroll:self.sportTableView];
    self.sportTableView.separatorStyle = NO;
    self.sportTableView.delegate = self;
    self.sportTableView.dataSource = self;
    self.sportTableView.bounces = YES;
    [self.view addSubview:self.sportTableView];
    
    [self.sportTableView registerClass:[MGDSportTableViewCell class] forCellReuseIdentifier:ID];
    
    [self buildUI];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = MGDColor3;
        self.backView.backgroundColor = MGDColor3;
        self.sportTableView.backgroundColor = MGDColor3;
    } else {
        // Fallback on earlier versions
    }
    self.sportTableView.tableHeaderView = self.backView;
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
    [self.backView addSubview:_topview];
    [self.backView addSubview:_baseView];
    [self.backView addSubview:_middleView];
}



#pragma mark- 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  78;
}

#pragma mark- 数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (userSportArray.count > 5) {
        return 5;
    }else {
        return userSportArray.count;
    }
}

//转到杨诚的界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MGDSportData *model = userSportArray[indexPath.row];
    
    MGDCellDataViewController *detailDataVC = [[MGDCellDataViewController alloc] init];
    //距离
    detailDataVC.distanceStr = [NSString stringWithFormat:@"%.2f",[model.distance floatValue] / 1000];
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
    //路径数组，不用你那个locationAry就没问题,自己模仿下上面的写法
    
    [self.navigationController pushViewController:detailDataVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建单元格（用复用池）
    MGDSportTableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //展示cell的数据
    if (userSportArray != nil && ![userSportArray isKindOfClass:[NSNull class]] && userSportArray.count != 0) {
        MGDSportData *model = userSportArray[indexPath.row];
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
        cell.kmLab.text = [NSString stringWithFormat:@"%.2f",[model.distance floatValue] / 1000];
        cell.minLab.text = [NSString stringWithFormat:@"%@",[self getMMSSFromSS:[NSString stringWithFormat:@"%@", model.totalTime]]];
        cell.calLab.text = [NSString stringWithFormat:@"%d",[model.cal intValue]];
    }else {

    }
    return cell;
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

//tableView禁止向上滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _sportTableView) {
        CGFloat offY = scrollView.contentOffset.y;
        if (offY < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}

- (void)MoreVC{
    MGDMoreViewController *moreVC = [[MGDMoreViewController alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBar" object:nil];
    moreVC.pageNumber = 1;
    [self.navigationController pushViewController:moreVC animated:YES];
}

//原来的三大数据的网络请求
- (void)getBaseInfo{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    NSLog(@"%@",token);
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
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error); // 404  500
        //MBProgressHUD  服务器异常 请稍后重试
    }];
}

//展示跑步总距离的数据
- (void)reloadBaseData:(MGDUserData *)model {
    self.baseView.Kmlab.text = [NSString stringWithFormat:@"%.2f",[model.distance floatValue]];
    self.baseView.MinLab.text = [NSString stringWithFormat:@"%d",[model.duration intValue]];
    self.baseView.CalLab.text = [NSString stringWithFormat:@"%d",[model.consume intValue]];
}

//获取近五次的运动记录（只显示五次）
- (void)getUserSportData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
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
            self->_sportModel = [MGDSportData SportDataWithDict:dic];
            [self->userSportArray addObject:self->_sportModel];
        }
        self->userSportArray = [[self->userSportArray reverseObjectEnumerator] allObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sportTableView reloadData];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"报错信息%@", error); // 404  500
        //MBProgressHUD  服务器异常 请稍后重试
    }];
}

//返回当前的时间
- (NSString *) dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//返回去年的时间
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

//配速的字符串
- (NSString *)getAverageSpeed:(NSString *)averagespeed {
    NSArray  *array = [averagespeed componentsSeparatedByString:@"."];
    NSString *speed = [NSString stringWithFormat:@"%@'%@''",array[0],array[1]];
    return speed;
}

//跑步时间的字符串
-(NSString *)getRunTimeFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

- (NSArray *)DataViewArray:(NSArray *)dataArr {
    NSString *CLASS = [NSString stringWithFormat:@"%@",[dataArr class]];
    if ([CLASS isEqualToString:@"__NSSingleObjectArrayI"]) {
        return @[];
    }else {
        NSLog(@"%@",[dataArr class]);
        NSMutableArray *test = [dataArr mutableCopy];
        NSString *s = test.lastObject;
        [test removeLastObject];
        s = [s substringToIndex:s.length - 2];
        [test addObject:s];
        return [test copy];
    }
}

@end

