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
#import "MGDUserInfo.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MRTabBarController.h"
#import "HttpClient.h"
#import "MGDSportData.h"

#define BACKGROUNDCOLOR [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]


@interface MGDMineViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *userSportArray;
}

@property (nonatomic, strong) MGDUserData *currentModel;
@property (nonatomic, strong) MGDUserInfo *userModel;
@property (nonatomic, strong) MGDSportData *sportModel;
@property (nonatomic, strong) NSUserDefaults *user;

@end

@implementation MGDMineViewController

NSString *ID = @"Recored_cell";

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.sportTableView.scrollEnabled = NO;
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
    
    [self getUserInfo];
    [self getBaseInfo];
    [self getUserSportData];
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
    return  screenHeigth * 0.0961;
}

#pragma mark- 数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (userSportArray.count > 5) {
        return 5;
    }else {
        return userSportArray.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //跳转到具体的跑步详情页面
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建单元格（用复用池）
    MGDSportTableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //展示cell的数据
    if (userSportArray != nil && ![userSportArray isKindOfClass:[NSNull class]] && userSportArray.count != 0) {
        MGDSportData *model = userSportArray[indexPath.row];
        NSString *date = [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@", model.date]];
        if ([self isToday:date]) {
            cell.dayLab.text = @"今天";
        }else if ([self isYesterday:date]) {
            cell.dayLab.text = @"昨天";
        }else {
            cell.dayLab.text = date;
        }
        NSString *time = [self getTimeStringWithTimeStr:[NSString stringWithFormat:@"%@",model.date]];
        cell.timeLab.text = time;
        cell.kmLab.text = [NSString stringWithFormat:@"%.2f",[model.distance floatValue]];
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

//判断跑步的日期是否是今天
- (BOOL)isToday:(NSString *)timeStr {
    NSString *str = [self getDateStringWithTimeStr:timeStr];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [[self dateToString:currentDate] substringWithRange:NSMakeRange(5,5)];
    if ([currentDateStr isEqualToString:str]) {
        return YES;
    }else {
        return NO;
    }
}

//判断跑步的日期是否是昨天
- (BOOL)isYesterday:(NSString *)timeStr {
    NSString *str = [self getDateStringWithTimeStr:timeStr];
    NSDate *mydate=[NSDate date];
    NSString *lastDay = [[self yesterdayTostring:mydate] substringWithRange:NSMakeRange(5, 5)];
    if ([lastDay isEqualToString:str]) {
        return YES;
    }else {
        return NO;
    }
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
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)getBaseInfo{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    NSLog(@"%@",token);
    // 响应
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];  //去除空值
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]]; //设置接收内容的格式
    [manager setResponseSerializer:responseSerializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    
    [manager POST:@"https://cyxbsmobile.sajo.fun/wxapi/mobile-run/getTotalData" parameters:nil
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

//关于用户信息的网络请求
- (void)getUserInfo {
//        HttpClient *client = [HttpClient defaultClient];
//        _user = [NSUserDefaults standardUserDefaults];
//        NSString *student_id = [_user objectForKey:@"studentID"];
//        NSString *pwd = [_user objectForKey:@"password"];
//        NSDictionary *param = @{@"studentId":student_id,@"password":pwd};
//        NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded"};
//        [client requestWithHead:kLoginURL method:HttpRequestPost parameters:param head:head prepareExecute:^
//         {
//             //
//         } progress:^(NSProgress *progress)
//         {
//             //
//         } success:^(NSURLSessionDataTask *task, id responseObject)
//         {
//             self->_userModel = [MGDUserInfo InfoWithDict:responseObject[@"data"]];
//             [self reloadUserInfo:self->_userModel];
//         } failure:^(NSURLSessionDataTask *task, NSError *error) {
//             //
//             NSLog(@"%@",error);
//         }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *student_id = [user objectForKey:@"studentID"];
    NSString *pwd = [user objectForKey:@"password"];
    NSDictionary *param = @{@"studentId":student_id,@"password":pwd};
    // 响应
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",nil]]; //设置接收内容的格式
    [manager setResponseSerializer:responseSerializer];
    [manager POST:@"https://cyxbsmobile.sajo.fun/wxapi/mobile-run/login" parameters:param
        success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_userModel = [MGDUserInfo InfoWithDict:responseObject[@"data"]];
        [self reloadUserInfo:self->_userModel];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error);
    }];
}

//展示用户信息的数据
- (void)reloadUserInfo:(MGDUserInfo *)model {
    self.topview.userName.text = model.userName;
    self.topview.personalSign.text = model.userSign;
    [self.topview.userIcon sd_setImageWithURL:[NSURL URLWithString:model.userIcon]];
}

- (void)getUserSportData {
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
    [manager POST:@"https://cyxbsmobile.sajo.fun/wxapi/mobile-run/getAllSportRecord" parameters:param
        success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = responseObject[@"data"];
        NSArray *record = [[NSArray alloc] init];
        record = dict[@"record_list"];
        for (NSDictionary *dic in record) {
            NSLog(@"%@",dic[@"FinishDate"]);
            self->_sportModel = [MGDSportData SportDataWithDict:dic];
            self->_sportModel.date = [NSString stringWithFormat:@"%@",dic[@"FinishDate"]];
            [self->userSportArray addObject:self->_sportModel];
            [self.sportTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"=====%@", error); // 404  500
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

//返回上个月的时间
- (NSString *) lastDateTostring:(NSDate *)date {
     NSDate *mydate=[NSDate date];
     NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
     NSDateComponents *comps = nil;
     comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:mydate];
     NSDateComponents *adcomps = [[NSDateComponents alloc] init];
     [adcomps setYear:0];
     [adcomps setMonth:-1];
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

@end

