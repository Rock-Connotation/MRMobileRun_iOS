//
//  MGDMoreViewController.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/13.
//

#import "MGDMoreViewController.h"
#import "MGDSportTableViewCell.h"
#import "MGDColumnChartView.h"
#import "YBPopupMenu.h"
#import "MRTabBarController.h"
#import <Masonry.h>

#define BACKGROUNDCOLOR [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]
#define DIVIDERCOLOR [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]

@interface MGDMoreViewController ()<UITableViewDelegate,UITableViewDataSource,MGDColumnChartViewDelegate,YBPopupMenuDelegate> {
    BOOL _isShowSec;
    NSArray *_selectArr;
}

@end

@implementation MGDMoreViewController

NSString *ID1 = @"Sport_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
           self.view.backgroundColor = MGDColor3;
       } else {
           // Fallback on earlier versions
    }
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    // 设置navigationBar透明
    self.navigationController.navigationBar.subviews[0].alpha = 0;
    // 去除navigationBar底部浅灰色的分割线
    self.navigationController.navigationBar.subviews[0].subviews[0].alpha = 0;
    //设置返回按钮的颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"运动记录";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setImage:[UIImage imageNamed:@"返回箭头4"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    [self setUI];
    
}

- (void) back {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setUI {
    
    if (kIs_iPhoneX) {
        _columnChartView = [[MGDColumnChartView alloc] initWithFrame:CGRectMake(0, 120, screenWidth, 258)];
        _divider = [[UIView alloc] initWithFrame:CGRectMake(0, 360, screenWidth, 1)];
        _recordTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0, 369, screenWidth, screenHeigth - 369) style:UITableViewStylePlain];
    }else {
        _columnChartView = [[MGDColumnChartView alloc] initWithFrame:CGRectMake(0, 80, screenWidth, 258)];
        _divider = [[UIView alloc] initWithFrame:CGRectMake(0, 338, screenWidth, 1)];
        _recordTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0, 347, screenWidth, screenHeigth - 347) style:UITableViewStylePlain];
    }

    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    NSString *currentyear = [NSString stringWithFormat: @"%ld", (long)currentYear];
    _columnChartView.yearName = currentyear;
    _columnChartView.delegate = self;
    [self.view addSubview:_columnChartView];
    
    [self scrollViewDidScroll:_recordTableView];
    _recordTableView.separatorStyle = NO;
    _recordTableView.delegate = self;
    _recordTableView.dataSource = self;
    [self.view addSubview:_recordTableView];
    [_recordTableView registerClass:[MGDSportTableViewCell class] forCellReuseIdentifier:ID1];
    
    if (@available(iOS 11.0, *)) {
        self.divider.backgroundColor = MGDdividerColor;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_divider];
    
    _isShowSec = false;
    
    _selectArr = [self columnYearLabelYear];
    
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
        [yearArray addObject:[NSString stringWithFormat:@"%ld",currentYear  - i]];
    }
    return [yearArray copy];
}


- (NSArray *)columnChartNumberArrayFor:(NSString *)itemName index:(NSInteger)index year:(NSString *)year {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 31; i++) {
        NSString *data = [NSString stringWithFormat:@"%f", [self randomBetween:0 AndBigNum:5.8 AndPrecision:100]];
        [arr addObject:data];
    }
    return arr;
}

//测试函数
- (float)randomBetween:(float)smallNum AndBigNum:(float)bigNum AndPrecision:(NSInteger)precision {
    float subtraction = ABS(bigNum - smallNum);
    subtraction *= precision;
    float randomNumber = (arc4random() % ((int) subtraction + 1)) / precision;
    float result = MIN(smallNum, bigNum) + randomNumber;
    return result;
}

- (void)showYearSelect:(UIButton *)sender {
    [YBPopupMenu showRelyOnView:sender titles:_selectArr icons:@[@"", @"", @"", @"", @""] menuWidth:180 delegate:self];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    NSString *year = _selectArr[index];
    self.columnChartView.yearName = year;
    [self.columnChartView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _recordTableView) {
        CGFloat offY = scrollView.contentOffset.y;
        if (offY < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}


#pragma mark- 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  78;
}

#pragma mark- 数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //跳转到具体的跑步详情页面
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建单元格（用复用池）
    MGDSportTableViewCell* cell = nil;
    cell.backgroundColor = [UIColor clearColor];
    cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    
    //测试用数据
    [self cell:cell andtest:indexPath.row];
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.hidesBottomBarWhenPushed = NO;
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


@end
