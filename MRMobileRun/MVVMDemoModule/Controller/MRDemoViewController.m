//
//  MRDemoViewController.m
//  MRMobileRun
//
//  Created by liangxiao on 2019/3/5.
//
#import <MGJRouter.h>
#import "MRRouterPublic.h"
#import "MRDemoViewController.h"
#import "MRDemoViewModel.h"
#import "MRDemoTableViewCell.h"
#import "MRDemoModel.h"

@interface MRDemoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MRDemoViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableview;

@end

@implementation MRDemoViewController

#pragma mark - lifecycle
+ (void)load {
    [MGJRouter registerURLPattern:kTestViewControllerPageURL toHandler:^(NSDictionary *routerParameters) {
        //调用者执行完 OpenUrl 方法的回调
        //此处应该做对此 VC 的操作
        
        MRDemoViewController *demoVC = [[MRDemoViewController alloc] init];
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [nav pushViewController:demoVC animated:YES];
    }];
}
    

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITableViewDelegate&Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MRDemoTableViewCell";
    
    MRDemoTableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MRDemoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        //给cell赋值 viewModel 的数据
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MRDemoModel *model = self.viewModel.modelArray[indexPath.row];
    
    //跳转详情页 actionURL 为详情页 URL
    [MGJRouter openURL:model.actionURL withUserInfo:nil completion:^(id result) {
    }];
}
#pragma mark - accessors
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
    }
    
    return _tableview;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
