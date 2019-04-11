//
//  ZYLRankViewController.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/31.
//

#import "ZYLRankViewController.h"
#import "ZYLRankViewModel.h"
#import <Masonry.h>
#import "MRRankTitleView.h"
#import "WeKit.h"
#import "MRRankPersonalBoardView.h"
#import "MRRankClassBoardView.h"
#import "MRRankTableViewCell.h"
#import "MRRankInfo.h"
//#import "MRRankModel.h"
//#import "MRHomePageModel.h"
#import "UIImageView+WebCache.h"
#import "MRRankClassTableViewCell.h"
#import <MJRefresh.h>

#define rateX screenWidth / 375.0
#define rateY screenHeigth / 667.0

static const NSInteger lowest_color = 0xF2F6F7;
static const NSInteger text_normal_color = 0xF2F6F7;
static const NSInteger text_inactive_color = 0xDEBDEC;

@interface ZYLRankViewController () <UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate>
@property (nonatomic, strong) MRRankTitleView *titleView;
@property (nonatomic, strong) MRRankClassBoardView *classBoardView;
@property (nonatomic, strong) MRRankPersonalBoardView *personalBoardView;
@property (nonatomic, strong) UIImageView *switcherImageView;
@property (nonatomic, strong) UITableView *personalRankTableView;
@property (nonatomic, strong) UITableView *classRankTableView;
@property (nonatomic,strong) NSMutableArray *tableViewDataArray;
@property (nonatomic,strong) NSMutableArray *classDataAry;
@property (nonatomic,strong) MRRankInfo *rankInfo;
@property (nonatomic,strong) NSString *pageString;
//@property (nonatomic,strong) MRRankModel *rankModel;
//保存当前页面的String
//@property (nonatomic,strong) MRHomePageModel *getPersonInformationModel;
@property int page;

@end

@implementation ZYLRankViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden: YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ZYLRankViewModel request];
    [self Notification];
    self.page = 0;
    self.pageString = @"personal";
    
//    self.rankModel = [[MRRankModel alloc]init];
//    [self.rankModel inquireRankWithPage:self.page];
//
//    self.getPersonInformationModel = [[MRHomePageModel alloc]init];
//
//    [self.getPersonInformationModel getDistanceAndRank];
    
    self.tableViewDataArray = [[NSMutableArray alloc]init];
    self.classDataAry = [[NSMutableArray alloc]init];
//    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(lowest_color);
    //大导航栏
    [self.view addSubview:self.titleView];
    //校园排行
    self.personalBoardView = [MRRankPersonalBoardView boardView];
    [self.view addSubview:self.personalBoardView];
    //    self.personalBoardView.hidden = YES;
    [self.view addSubview:self.switcherImageView];
    [self.view addSubview:self.classRankTableView];
    [self.view addSubview:self.personalRankTableView];
    [self.personalBoardView sendSubviewToBack:self.view];
    [self.classBoardView sendSubviewToBack:self.view];
    
    self.personalRankTableView.allowsSelection = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74 * ScreenHeight / 667;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //仅用于测试
    if ([self.pageString isEqualToString:@"personal"]){
        
        NSLog(@"\n\n\n\ncount%ld\n\n\n",self.tableViewDataArray.count);
        
        
        return self.tableViewDataArray.count;
        
        
    }
    else{
        NSLog(@"\n\n\n\n%ld\n\n\n",self.classDataAry.count);
        
        return self.classDataAry.count;
        
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MRRankClassTableViewCell *cell = [MRRankClassTableViewCell cellWithTableView:tableView];
    
    
    if ([self.pageString isEqualToString:@"personal"] && self.tableViewDataArray.count != 0) {
        
        self.personalRankTableView.hidden = NO;
        MRRankTableViewCell *personCell = [MRRankTableViewCell cellWithTableView:tableView];
        
        [personCell setRankInfo:[MRRankInfo  testInfoWithdic:self.tableViewDataArray[indexPath.row] andPageChoose:self.pageString]];
        
        
        return personCell;
    }
    else{
        MRRankClassTableViewCell *classCell = [MRRankClassTableViewCell
                                               cellWithTableView:tableView];
        
        self.personalRankTableView.hidden = NO;
        
        [classCell setRankInfo:[MRRankInfo  testInfoWithdic:self.classDataAry[indexPath.row] andPageChoose:self.pageString]];
        
        
        return classCell;
        
    }
    
    return cell;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Notification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inquireRank:)  name:@"inquireRank" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRankAndDistance:)  name:@"getRankAndDistance" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inquireClassRank:)  name:@"inquireClassRank" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getClassInformation:) name:@"getClassInformation"object:nil];
}

- (void)inquireRank:(NSNotification*)notification{
    
    
    
    
    NSMutableArray *dataAry =  [notification object];
    
    if (dataAry.count >= 15) {
        self.personalRankTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
//            [self.rankModel inquireRankWithPage:self.page];
        }];
    }
    else{
        self.personalRankTableView.mj_footer = NULL;
    }
    
    
    NSLog(@"123______");
    
    if (![dataAry[0] isEqual: @"null"]) {
        NSLog(@"/n/n/n/n1231232%@131231/n/n/n/n",dataAry);
        
        NSLog(@"\n\n\n\n----------------\n\n\n\n");
        
        
        [self.tableViewDataArray addObjectsFromArray:dataAry];
        
        NSLog(@"/n/n/n/n1231232131231/n/n/n/n");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.personalRankTableView
             reloadData];
            
        });
    }
    else{
        [self.personalRankTableView.mj_footer endRefreshing];
        
    }
    
    
    
}

- (void)inquireClassRank:(NSNotification*)notification{
    
    //班级排行榜数据
    
    NSMutableArray *dataAry =  [notification object];
    
    if (self.tableViewDataArray.count != dataAry.count) {
        [self.tableViewDataArray removeAllObjects];
    }
    
    if (dataAry.count > 15) {
        
        NSLog(@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n---%lu---\n\n\n\n\n\n\n\n",(unsigned long)dataAry.count);
        
        
        self.personalRankTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
//            [self.rankModel inquireClassRankWithData:self.page];
        }];
    }
    else{
        self.personalRankTableView.mj_footer  = NULL;
    }
    
    
    if (![dataAry[0] isEqual: @"null"]) {
        NSLog(@"/n/n/n/n1231232%@131231/n/n/n/n",dataAry);
        
        NSLog(@"\n\n\n\n----------------\n\n\n\n");
        
        
        [self.classDataAry addObjectsFromArray:dataAry];
        
        NSLog(@"%@",self.classDataAry);
        NSLog(@"/n/n/n/n1231232131231/n/n/n/n");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.personalRankTableView
             reloadData];
            
        });
    }
    else{
        [self.personalRankTableView.mj_footer endRefreshingWithNoMoreData];
        
    }
    
    NSLog(@"------123");
    
    
    
}
- (void)getClassInformation:(NSNotification*)notification{
    
    
    NSMutableDictionary *dataDic = [notification object];
    
    dataDic = [dataDic objectForKey:@"data"];
    
    NSString *classIdString = [dataDic objectForKey:@"class_id"];
    self.classBoardView.nameLabel.text = [NSString stringWithFormat:@"%@",classIdString ];
    
    NSString *rankString =[dataDic objectForKey:@"rank"];
    self.classBoardView.rankLabel.text = [NSString stringWithFormat:@"%@"@"%@", @"排名：",rankString];
    
    NSString *distanceString = [dataDic objectForKey:@"total"];
    self.classBoardView.distanceLabel.text = [NSString stringWithFormat:@"%@"@"%@"@"%@",@"路程：",distanceString,@" km"];
    
    NSString *gapDistance = [dataDic objectForKey:@"prev_difference"];
    self.classBoardView.gapDistanceLabel.text = [NSString stringWithFormat:@"%@"@"%@"@"%@",@"距上一名：",gapDistance,@" km" ];
    
    
    
}
- (void)getRankAndDistance:(NSNotification*)notification{
    
    NSMutableDictionary *dataDic = [notification object];
    dataDic = [dataDic objectForKey:@"data"];
    
    
    
    if ([ [ NSString stringWithFormat:@"%@",
           [dataDic objectForKey:@"nickname"] ]
         isEqual: @"<null>"]) {
        
        self.personalBoardView.nameLabel.text =
        [dataDic objectForKey:@"name"];
    }
    
    else{
        self.personalBoardView.nameLabel.text = [dataDic objectForKey:@"nickname"];
        
    }
    
    NSNumber *totalDistance = [dataDic  objectForKey:@"total"];
    if ([[NSString stringWithFormat:@"%@",totalDistance ]isEqualToString:@"null"]) {
        totalDistance = 0;
    }
    
    self.personalBoardView.distanceLabel.text =[NSString stringWithFormat:@"%@"@"%@"@"%@",@"路程：",totalDistance,@" km"];
    
    
    NSNumber *rank = [dataDic  objectForKey:@"rank"];
    self.personalBoardView.rankLabel.text =[NSString stringWithFormat:@"%@"@"%@",@"排名：",rank];
    
    NSNumber *duration  = [dataDic objectForKey:@"prev_difference"];
    self.personalBoardView.gapDistanceLabel.text =[NSString stringWithFormat:@"%@"@"%@"@"%@",@"距上一名：",duration,@" km"];
    
    
    
    
    NSString *path_document = NSHomeDirectory();
    //图片的存储路径
    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/avatar.png"];
    
    self.personalBoardView.avatarImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    
    
    
    
    
}

- (void)clickBackBtu{
    
    [self.navigationController popViewControllerAnimated:YES];
    self.view = nil;
    
}

- (void)clickFirstTabButton{
    
    [self.tableViewDataArray removeAllObjects];
    //清空DataSource
    
    [UIView animateWithDuration:0.5 animations:^{
        self.switcherImageView.center = CGPointMake(103.0 *screenWidth/375.0, 101 *screenHeigth/568.0);
    }];
    //滑块动画
    self.pageString = @"personal";
    self.page = 0;
    //清空页数
    self.personalRankTableView.hidden = YES;
    
    self.classBoardView.hidden = YES;
    self.personalBoardView.hidden = NO;
    
    
    self.titleView.firstTabButton.enabled = NO;
    self.titleView.secondTabButton.enabled = YES;
    
//    [self.rankModel inquireRankWithPage:self.page];
    
    
    self.titleView.firstTabLabel.textColor =  UIColorFromRGB(text_normal_color);
    
    self.titleView.secondTabLabel.textColor =  UIColorFromRGB(text_inactive_color);
    
    
    
    self.rankInfo = [[MRRankInfo alloc]init];
    
    self.rankInfo.avatarImage.image = [UIImage imageNamed:@"用户"];
}

- (void)clickSecondTabButton{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.switcherImageView.center = CGPointMake(270.5 *screenWidth/375.0, 101*screenHeigth/568.0);
    }];
    //滑块动画
    [self.classDataAry removeAllObjects];
    //清空DataSource
    self.personalRankTableView.hidden = YES;
    
    self.page = 0;
    //清空页数
//    [self.rankModel getClassInformation];
    
    self.pageString = @"class";
    
    self.personalBoardView.hidden = YES;
    self.classBoardView = [MRRankClassBoardView boardView];
    [self.view addSubview:self.classBoardView];
    
    
    
    self.titleView.firstTabButton.enabled = YES;
    self.titleView.secondTabButton.enabled = NO;
    self.titleView.firstTabLabel.textColor =  UIColorFromRGB(text_inactive_color);
    self.titleView.secondTabLabel.textColor =  UIColorFromRGB(text_normal_color);
    
    self.rankInfo = [[MRRankInfo alloc]init];
    
    
//    [self.rankModel inquireClassRankWithData:self.page];
    
    
    NSLog(@"eee");
}



- (void)animationDidStart:(CAAnimation *)anim{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.switcherImageView.center = CGPointMake(242.5 *screenWidth/375.0, 100);
    }];
    
    
}

//动画结束的时候调用
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    self.switcherImageView.layer.position = CGPointMake( 148.0 *ScreenWidth / 750.0, 227.0 *screenHeigth/1334.0);
    
}

#pragma mark - 懒加载

- (MRRankTitleView *)titleView{
    if (!_titleView) {
        _titleView = [MRRankTitleView titleView];
        [_titleView.backButton addTarget:self action:@selector(clickBackBtu) forControlEvents:UIControlEventTouchUpInside];
        [_titleView.firstTabButton addTarget:self action:@selector(clickFirstTabButton) forControlEvents:UIControlEventTouchUpInside];
        [_titleView.secondTabButton addTarget:self action:@selector(clickSecondTabButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleView;
}

- (UIImageView *)switcherImageView{
    if (!_switcherImageView) {
        CGRect rect0 = CGRectMake(69 * rateX, 111 *rateY, 73.5 * rateX, 15 * rateY);
        UIImage *i0 = [UIImage imageNamed:@"导航滑条2"];
        _switcherImageView = [[UIImageView alloc] initWithFrame:rect0];
        _switcherImageView.image = i0;
    }
    return _switcherImageView;
}

- (UITableView *)classRankTableView{
    if (!_classRankTableView) {
        CGRect rect1 = CGRectMake(0, 230 * rateY, ScreenWidth, ScreenHeight - 230 * rateY);
        _classRankTableView = [[UITableView alloc] initWithFrame:rect1];
        _classRankTableView.delegate = self;
        _classRankTableView.dataSource = self;
        _classRankTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _classRankTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_classRankTableView setRowHeight:148 *screenHeigth/1334 ];
        _classRankTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    return _classRankTableView;
}

- (UITableView *)personalRankTableView{
    if (!_personalRankTableView) {
        CGRect rect1 = CGRectMake(0, 230 * rateY, ScreenWidth, ScreenHeight - 230 * rateY);
        _personalRankTableView = [[UITableView alloc] initWithFrame:rect1];
        _personalRankTableView.delegate = self;
        _personalRankTableView.dataSource = self;
        _personalRankTableView.hidden = YES;
        _personalRankTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _personalRankTableView;
}

@end
