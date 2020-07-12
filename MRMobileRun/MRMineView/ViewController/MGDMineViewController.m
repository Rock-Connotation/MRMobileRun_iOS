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

#define BACKGROUNDCOLOR [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0];

@interface MGDMineViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation MGDMineViewController

NSString *ID = @"Setting_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0];
    MGDTopView *topview = [[MGDTopView alloc] init];
    topview.frame = CGRectMake(0,0,screenWidth,136);
    [self.view addSubview:topview];
    
    MGDBaseInfoView *baseView = [[MGDBaseInfoView alloc] init];
    baseView.frame = CGRectMake(0,136,screenWidth,117);
    [self.view addSubview:baseView];
    
    MGDMiddleView *middleView = [[MGDMiddleView alloc] init];
    middleView.frame = CGRectMake(0, 253, screenWidth,37);
    [self.view addSubview:middleView];
    
    MGDSportTableView *sportTableView = [[MGDSportTableView alloc] initWithFrame:CGRectMake(0, 290, screenWidth, screenHeigth - 290 - 83) style:UITableViewStylePlain];
    sportTableView.separatorStyle = NO;
    sportTableView.delegate = self;
    sportTableView.dataSource = self;
    sportTableView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:sportTableView];
    [sportTableView registerClass:[MGDSportTableViewCell class] forCellReuseIdentifier:ID];
    
    
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
    cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //测试用数据
    [self cell:cell andtest:indexPath.row];
    
    return cell;
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
                   cell.calLab.text = @"193";
               }
               break;
           case 2:
               {
                   cell.dayLab.text = @"昨天";
                   cell.timeLab.text = @"19:03";
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

