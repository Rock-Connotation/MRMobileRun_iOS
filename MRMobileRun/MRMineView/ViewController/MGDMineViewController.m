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
#import <MJRefresh.h>
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
    
    _sportTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0,0, screenWidth, screenHeigth) style:UITableViewStylePlain];
    [self scrollViewDidScroll:_sportTableView];
    _sportTableView.separatorStyle = NO;
    _sportTableView.delegate = self;
    _sportTableView.dataSource = self;
    [self.view addSubview:_sportTableView];
    
    [_sportTableView registerClass:[MGDSportTableViewCell class] forCellReuseIdentifier:ID];
    
    [self buildUI];
    if (@available(iOS 11.0, *)) {
        self.backView.backgroundColor = MGDColor3;
    } else {
        // Fallback on earlier versions
    }
    self.sportTableView.tableHeaderView = self.backView;
    
    self.sportTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    //[self getUserInfo];
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
    return  78;
}

#pragma mark- 数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //跳转到具体的跑步详情页面
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建单元格（用复用池）
    MGDSportTableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
//    MGDSportData *model = userSportArray[indexPath.row];
//    cell.dayLab.text = model.date;
//    cell.kmLab.text = model.distance;
//    cell.minLab.text = model.totalTime;
//    cell.calLab.text = model.cal;
//    cell.timeLab.text = model.date;
    
    //测试用数据
    [self cell:cell andtest:indexPath.row];
    
    return cell;
}

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

- (void)loadMoreData {
    NSLog(@"111");
}

- (void)cell:(MGDSportTableViewCell* )cell andtest:(NSInteger) row {
    switch (row) {
           case 0:
               {
                   cell.dayLab.text = @"今天";
                   cell.timeLab.text = @"19:32";
                   cell.kmLab.text = @"5.32";
                   cell.minLab.text = @"29:12";
                   cell.calLab.text = @"461";
                   
               }
               break;
           case 1:
               {
                   cell.dayLab.text = @"";
                   cell.timeLab.text = @"8:02";
                   cell.kmLab.text = @"2.04";
                   cell.minLab.text = @"12:40";
                   cell.calLab.text = @"1933213";
               }
               break;
           case 2:
               {
                   cell.dayLab.text = @"昨天";
                   cell.timeLab.text = @"2:03";
                   cell.kmLab.text = @"1.03";
                   cell.minLab.text = @"5:42";
                   cell.calLab.text = @"95";
               }
               break;
           case 3:
               {
                   cell.dayLab.text = @"10-12";
                   cell.timeLab.text = @"20:16";
                   cell.kmLab.text = @"1.20";
                   cell.minLab.text = @"6:32";
                   cell.calLab.text = @"103";
               }
               break;
               
           case 4:
               {
                   cell.dayLab.text = @"10-18";
                   cell.timeLab.text = @"7:58";
                   cell.kmLab.text = @"5.32";
                   cell.minLab.text = @"29:12";
                   cell.calLab.text = @"461";
               }
               break;
           case 5:
               {
                  cell.dayLab.text = @"";
                  cell.timeLab.text = @"14:22";
                  cell.kmLab.text = @"4.31";
                  cell.minLab.text = @"18:54";
                  cell.calLab.text = @"375";
               }
           default:
               break;
       }
}

- (void)getBaseInfo {
    HttpClient *client = [HttpClient defaultClient];
    _user = [NSUserDefaults standardUserDefaults];
    NSString *token = [_user objectForKey:@"token"];
    NSDictionary *param = @{@"token":token};
    [client requestWithHead:@"https://cyxbsmobile.redrock.team/wxapi/mobilerun/getTotalData" method:HttpRequestGet parameters:param head:nil prepareExecute:^
     {
         //
     } progress:^(NSProgress *progress)
     {
         //
     } success:^(NSURLSessionDataTask *task, id responseObject)
     {
        
         //self->_currentModel = [MGDUserData DataWithDict:responseObject[@"data"]];
        NSLog(@"通过GET请求获取用户的跑步三个大信息");
        NSLog(@"%@",responseObject[@"info"]);
        NSLog(@"%@",responseObject);
         //[self reloadBaseData:self->_currentModel];
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         //
         NSLog(@"这是GET请求用户三个跑步大信息时报的错");
         NSLog(@"%@",error);
     }];
}

- (void)reloadBaseData:(MGDUserData *)model {
    self.baseView.Kmlab.text = model.total_distance;
    self.baseView.MinLab.text = model.total_duration;
    self.baseView.CalLab.text = model.total_consume;
}

- (void)getUserInfo {
        HttpClient *client = [HttpClient defaultClient];
        _user = [NSUserDefaults standardUserDefaults];
        NSString *student_id = [_user objectForKey:@"studentID"];
        NSString *pwd = [_user objectForKey:@"password"];
        NSDictionary *param = @{@"studentId":student_id,@"password":pwd};
        NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded"};
        [client requestWithHead:kLoginURL method:HttpRequestPost parameters:param head:head prepareExecute:^
         {
             //
         } progress:^(NSProgress *progress)
         {
             //
         } success:^(NSURLSessionDataTask *task, id responseObject)
         {
             self->_userModel = [MGDUserInfo InfoWithDict:responseObject[@"data"]];
             [self reloadUserInfo:self->_userModel];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             //
             NSLog(@"%@",error);
         }];
}


- (void)reloadUserInfo:(MGDUserInfo *)model {
    self.topview.userName.text = model.userName;
    self.topview.personalSign.text = model.userSign;
    [self.topview.userIcon sd_setImageWithURL:[NSURL URLWithString:model.userIcon]];
}

//- (void)getUserSportData {
//    HttpClient *client = [HttpClient defaultClient];
//    _user = [NSUserDefaults standardUserDefaults];
//    NSDate *currentDate = [NSDate date];
//    NSString *currentDateStr = [self dateToString:currentDate];
//    NSString *lastDateStr = [self lastDateTostring:currentDate];
//    NSString *token = [_user objectForKey:@"token"];
//    NSDictionary *param = @{@"token":token,@"from_time":lastDateStr,@"to_time":currentDateStr};
//    NSLog(@"%@",param);
//    [client requestWithHead:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/getAllSportRecord" method:HttpRequestPost parameters:param head:nil prepareExecute:^
//     {
//         //
//     } progress:^(NSProgress *progress)
//     {
//         //
//     } success:^(NSURLSessionDataTask *task, id responseObject)
//     {
//        NSLog(@"获取用户的cell中的数据");
//        NSLog(@"%@",responseObject);
//     } failure:^(NSURLSessionDataTask *task, NSError *error) {
//         //
//         NSLog(@"这是获取cell数据失败的报错");
//         NSLog(@"%@",error);
//     }];
//}

- (void)getUserSportData {
    _user = [NSUserDefaults standardUserDefaults];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [self dateToString:currentDate];
    NSString *lastDateStr = [self lastDateTostring:currentDate];
    NSString *token = [_user objectForKey:@"token"];
    NSDictionary *param = @{@"token":token,@"from_time":lastDateStr,@"to_time":currentDateStr};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", @"text/plain",nil];
    [manager POST:@"https://cyxbsmobile.redrock.team/wxapi/mobile-run/getAllSportRecord" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
         NSLog(@"获取用户的cell中的数据");
         NSLog(@"%@",responseObject[@"info"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (NSString *) dateToString: (NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

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


@end

