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

#define BACKGROUNDCOLOR [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]
#define TopViewH screenHeigth * 0.1664
#define BaseViewH screenHeigth * 0.1754
#define MiddleViewH screenHeigth * 0.033

@interface MGDMineViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *baseDataArray;
    NSMutableArray *userArray;
}

@property (nonatomic, strong) MGDUserData *currentModel;
@property (nonatomic, strong) MGDUserInfo *userModel;

@end

@implementation MGDMineViewController

NSString *ID = @"Recored_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
           self.view.backgroundColor = MGDColor3;
       } else {
           // Fallback on earlier versions
    }
    //baseDataArray = [NSMutableArray new];
    //userArray = [NSMutableArray new];
    self.tabBarController.tabBar.hidden = NO;
    [self buildUI];
    //[self getBaseInfo];
    //[self getUserInfo];
}

- (void)buildUI {
    _topview = [[MGDTopView alloc] init];
    _baseView = [[MGDBaseInfoView alloc] init];
    _middleView = [[MGDMiddleView alloc] init];
    
    [_middleView.moreBtn addTarget:self action:@selector(MoreVC) forControlEvents:UIControlEventTouchUpInside];
    
    if (kIs_iPhoneX) {
        _topview.frame = CGRectMake(0,0,screenWidth,136);
        _baseView.frame = CGRectMake(0,136,screenWidth,117);
        _middleView.frame = CGRectMake(0,253,screenWidth,22);
        _sportTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0,290, screenWidth, screenHeigth - (290)) style:UITableViewStylePlain];
    }else {
        _topview.frame = CGRectMake(0,0,screenWidth,111);
        _baseView.frame = CGRectMake(0,111,screenWidth,117);
        _middleView.frame = CGRectMake(0,228,screenWidth,22);
        _sportTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0,265, screenWidth, screenHeigth - (265)) style:UITableViewStylePlain];
    }
    
    [self.view addSubview:_topview];
    [self.view addSubview:_baseView];
    [self.view addSubview:_middleView];
    [self.view addSubview:_sportTableView];
    
    [self scrollViewDidScroll:_sportTableView];
    _sportTableView.separatorStyle = NO;
    _sportTableView.delegate = self;
    _sportTableView.dataSource = self;
    
    [_sportTableView registerClass:[MGDSportTableViewCell class] forCellReuseIdentifier:ID];
       
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
    NSString *urlStr = @"https://cyxbsmobile.redrock.team/wxapi/mobile-run/getTotalData";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
         for (NSDictionary *dict in responseObject[@"data"]) {
             self->_currentModel = [MGDUserData DataWithDict:dict];
             [self->baseDataArray addObject:self->_currentModel];
            }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadBaseData:self->_currentModel];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)reloadBaseData:(MGDUserData *)model {
    self.baseView.Kmlab.text = model.total_distance;
    self.baseView.MinLab.text = model.total_duration;
    self.baseView.CalLab.text = model.total_consume;
}

- (void)getUserInfo {
    NSString *url = kLoginURL;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
         for (NSDictionary *dict in responseObject[@"user_data"]) {
             self->_userModel = [MGDUserInfo InfoWithDict:dict];
             [self->userArray addObject:self->_userModel];
            }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadUserInfo:self->_userModel];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)reloadUserInfo:(MGDUserInfo *)model {
    self.topview.userName.text = model.userName;
    self.topview.personalSign.text = model.userSign;
    [self.topview.userIcon sd_setImageWithURL:[NSURL URLWithString:model.userIcon]];
}
@end

