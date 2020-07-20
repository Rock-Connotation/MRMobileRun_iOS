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
#import <Masonry.h>

#define BACKGROUNDCOLOR [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]

@interface MGDMoreViewController ()<UITableViewDelegate,UITableViewDataSource,MGDColumnChartViewDelegate,YBPopupMenuDelegate>
{
    BOOL _isShowSec;
    NSArray *_selectArr;
}

@end

@implementation MGDMoreViewController

NSString *ID1 = @"Sport_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUNDCOLOR;
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
    self.navigationItem.leftBarButtonItem.title = @"";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:51/255.0 green:55/255.0 blue:57/255.0 alpha:1.0]];
    
    [self setUI];
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 80);
    return newSize;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect rect = self.navigationController.navigationBar.frame;
    self.navigationController.navigationBar.frame = CGRectMake(rect.origin.x,rect.origin.y,rect. size.width,80);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    CGRect rect = self.navigationController.navigationBar.frame;
    self.navigationController.navigationBar.frame = CGRectMake(rect.origin.x,rect.origin.y,rect. size.width,44);
}


- (void)setUI {
    _recordTableView = [[MGDRecordTableView alloc] initWithFrame:CGRectMake(0, 360, screenWidth, screenHeigth - 394) style:UITableViewStylePlain];
    _recordTableView.separatorStyle = NO;
    _recordTableView.delegate = self;
    _recordTableView.dataSource = self;
    _recordTableView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:_recordTableView];
    [_recordTableView registerClass:[MGDSportTableViewCell class] forCellReuseIdentifier:ID1];
    
    _columnChartView = [[MGDColumnChartView alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 228)];
    _columnChartView.backgroundColor = [UIColor whiteColor];
    _columnChartView.yearName = @"2020";
    _columnChartView.delegate = self;
    [self.view addSubview:_columnChartView];
    
    _isShowSec = false;
    
    _selectArr = @[@"2018", @"2019", @"2020"];
    
}


- (void)changeYearClick:(MGDColumnChartView *)chartView sender:(UIButton *)sender
{
    [self showYearSelect:sender];
}

- (NSArray *)columnChartTitleArrayYear:(NSString *)year
{
    if ([year isEqualToString:@"2020"]) {
        return @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"本月", @"8月", @"9月", @"10月", @"11月", @"12月"];
        
    }else {
        return @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    }
}

- (NSArray *)columnChartNumberArrayFor:(NSString *)itemName index:(NSInteger)index year:(NSString *)year
{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 31; i++) {
        NSString *data = [NSString stringWithFormat:@"%f", [self randomBetween:0 AndBigNum:5.2 AndPrecision:100]];
        [arr addObject:data];
    }
    return arr;
}

- (float)randomBetween:(float)smallNum AndBigNum:(float)bigNum AndPrecision:(NSInteger)precision{
    float subtraction = bigNum - smallNum;
    subtraction = ABS(subtraction);
    subtraction *= precision;
    float randomNumber = arc4random() % ((int) subtraction + 1);
    randomNumber /= precision;
    float result = MIN(smallNum, bigNum) + randomNumber;
    return result;
}

- (void)showYearSelect:(UIButton *)sender
{
    [YBPopupMenu showRelyOnView:sender titles:_selectArr icons:@[@"", @"", @"", @"", @""] menuWidth:180 delegate:self];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    NSString *year = _selectArr[index];
    
    self.columnChartView.yearName = year;
    [self.columnChartView reloadData];
}


#pragma mark- 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  78;
}

#pragma mark- 数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建单元格（用复用池）
    MGDSportTableViewCell* cell = nil;
    cell.backgroundColor = [UIColor clearColor];
    cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    
    //测试用数据
    [self cell:cell andtest:indexPath.row];
    
    return cell;
}


- (void) Back {
    
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
