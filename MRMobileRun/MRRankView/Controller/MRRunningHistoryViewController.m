//
//  MRRunningHistoryViewController.m
//  
//
//  Created by 郑沛越 on 2017/3/8.
//
//

#import "MRRunningHistoryViewController.h"
#import "MRRunningHistoryView.h"
#import "MRHistoryTableViewCell.h" 
#import "MRRunningHisToryModel.h" 
#import "MRTimeReversalModel.h"
#import "MRRunningTrackViewController.h"
#import "MRMapView.h"
#import "MJRefresh.h"
#import "MASonry.h"
#import "MBProgressHUD.h"

@interface MRRunningHistoryViewController ()
@property (nonatomic,strong) MRRunningHistoryView *historyView;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,strong) MRTimeReversalModel *timeReversalModel;
@property (nonatomic,strong) MBProgressHUD *loginProgress;

@property int btuNum;
//处理时间
@property  int aryNum;
//用来存储获取到的内存数据的数组
@property  int page;
//这个是分页的页数，0是第一页

@property(nonatomic,strong) MRRunningTrackViewController *runningTrackVC;
@end

@implementation MRRunningHistoryViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tableview.mj_header beginRefreshing];
    self.tabBarController.tabBar.hidden = YES;
     NSLog(@"我的足迹开始了");
    //隐藏导航栏
}
- (void)viewDidLoad {
    self.page = 0;

    [super viewDidLoad];
    self.historyView = [[MRRunningHistoryView alloc]init];
    self.view = self.historyView;
    
    [self.historyView.backBtu addTarget:self action:@selector(clickBackBtu) forControlEvents:UIControlEventTouchUpInside];
    //添加返回
    [self initTableView];
    [self Notification];
    self.aryNum = 0;
    self.dataAry = [[NSMutableArray alloc] init];
    
    self.loginProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loginProgress.mode = MBProgressHUDModeIndeterminate;
    self.loginProgress.bezelView.color = [UIColor clearColor];
    self.loginProgress.userInteractionEnabled = NO;
    
    [MRRunningHisToryModel getHistorywithPage:self.page];
    
    // Do any additional setup after loading the view.
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBackBtu{

    [self.navigationController popViewControllerAnimated:YES];

    self.view = nil;
}

- (void)initTableView{
    self.tableview = [[UITableView alloc]init];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self.view).with.insets(UIEdgeInsetsMake(128.0/1334.0*screenHeigth, 0/750.0*screenWidth, 0/1334.0*screenHeigth, 0/750.0*screenWidth));
    }];
    
    self.timeReversalModel =[[MRTimeReversalModel alloc]init];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (self.dataAry.count > 0) {
        return self.dataAry.count;
    }
    else{

    return 0;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     
     NSLog(@"\n\n\n\n----%@---\n\n\n\n",self.dataAry);

         MRHistoryTableViewCell *cell = [MRHistoryTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
     
     
    

     if (indexPath.row <  self.dataAry.count && self.dataAry != NULL) {
         cell.distanceLabel.text = [self changeTextForm:[NSString stringWithFormat:@"%@",[self.dataAry[indexPath.row] objectForKey:@"distance"]] ];
         
         //获取跑步距离并显示在cell上
         NSString *duration = [NSString stringWithFormat:@"%@",[self.dataAry[indexPath.row] objectForKey:@"duration"]];
         
         
         cell.timeLabel.text = [self.timeReversalModel getTimeStringWithSecond:[duration intValue]];
         //获取跑步时间并调用时间类方法显示在cell上
         
         
         NSString *date = [self.dataAry[indexPath.row] objectForKey:@"end_time"];
         
         
         NSString *time = [self.timeReversalModel getTimeWithBeginTime:[self.dataAry[indexPath.row] objectForKey:@"begin_time"] andEndTime:[self.dataAry[indexPath.row] objectForKey:@"end_time"]];
         
         
         cell.timeLabel.text = time;
         
         cell.dateLabel.text = [self.timeReversalModel getDateWithEndTime:date];
         
         cell.viewFootprintsBtu.tag = indexPath.row;
         
         [cell.viewFootprintsBtu addTarget:self action:@selector(clickViewFootprintsBtu:) forControlEvents:UIControlEventTouchUpInside];
         
       
         self.aryNum++;
        
     }
     
        // 3.设置数据
    
         // 4.返回
         return cell;
 }


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
         // NSLog(@"heightForRowAtIndexPath");     // 取出对应航的frame模型

         return 96 *screenWidth/375;
}


- (void)clickViewFootprintsBtu:(id)sender{
    self.runningTrackVC = [[MRRunningTrackViewController alloc]init];

    int i = (int)[sender tag] ;
    
    self.runningTrackVC.locationAry = [self.dataAry[i] objectForKey:@"lat_lng"];

    

    [self presentViewController:self.runningTrackVC animated:YES completion:nil];
    
    
    
    
    NSString *timeString = [NSString stringWithFormat:@"%@",[self.dataAry[i] objectForKey:@"duration"]];
    
    self.runningTrackVC.runningTrackView.dataBaseView.timeLabel.text = [self.timeReversalModel getTimeStringWithSecond:[timeString intValue]];
    //下一个界面显示的跑步时间
    
    NSString *distance = [NSString stringWithFormat:@"%@",[self.dataAry[i] objectForKey:@"distance"]];
    
    self.runningTrackVC.runningTrackView.dataBaseView.distanceLabel.text = distance;
    //下一个界面显示的跑步距离
   
    NSMutableDictionary *dateDic = [self.timeReversalModel getDateAndChanceFormWithEndTime:[self.dataAry[i] objectForKey:@"end_time"]];
    
    self.runningTrackVC.runningTrackView.dataBaseView.dateOne.text = [dateDic objectForKey:@"date"];
    self.runningTrackVC.runningTrackView.dataBaseView.dateTwo.text = [dateDic objectForKey:@"time"];

    
    if ([self.dataAry[i] objectForKey:@"lat_lng"] != NULL) {
        
    
    self.runningTrackVC.locationAry =[self.dataAry[i] objectForKey:@"lat_lng"];
    }
    
        NSString *time = [self.timeReversalModel getTimeWithBeginTime:[self.dataAry[i] objectForKey:@"begin_time"] andEndTime:[self.dataAry[i] objectForKey:@"end_time"]];

    self.runningTrackVC.runningTrackView.dataBaseView.timeLabel.text = time;

}

- (void)Notification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHistory:)  name:@"getHistory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHistoryFail)  name:@"getHistory" object:nil];
    
}

- (void)getHistory:(NSNotification*)notification{
    
    self.loginProgress.hidden = YES;
    
    self.aryNum = 0;
    
    self.page ++;

    NSLog(@"%@",[notification object]);
    
    if (![[NSString stringWithFormat:@"%@",[notification object]  ]  isEqual: @"<null>" ]) {
    
    NSMutableArray *dataAry =  [notification object];
    
    

    
    if (dataAry.count >= 15) {
        self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [MRRunningHisToryModel  getHistorywithPage:self.page];
        }];
    }
    else{
        self.tableview.mj_footer = NULL;
    }
    
    [self.dataAry addObjectsFromArray:dataAry];

    
    [self.tableview reloadData];
    }

 
}

- (void)getHistoryFail{
    
    NSLog(@"\n\n\n%s\n\n\n","123");
    self.loginProgress.hidden = YES;

}
- (NSString *)changeTextForm:(NSString *)distance{
    
    double  title = [distance doubleValue];
    NSString  *text = [[NSString alloc] init];
    
    if (title < 10) {
        text = [NSString stringWithFormat:@"%.2lf",title];
        
    }
    
    if (title < 100 && title>= 10) {
        text = [NSString stringWithFormat:@"%.1lf",title];
        
    }
    
    if (title < 1000 && title>= 100) {
        text = [NSString stringWithFormat:@"%d",(int)title];
        
    }
    
    if (title  >= 1000) {
        text = [NSString stringWithFormat:@"%d",(int)title];
        
    }
    return text;

}
- (void)dealloc{
    NSLog(@"zxc");
}
@end
