//
//  LJJInviteViewModel.m
//  MRMobileRun
//
//  Created by J J on 2019/4/3.
//

#import "LJJInviteViewModel.h"
#import "LJJInviteSearchResultView.h"
@implementation LJJInviteViewModel

- (void)setHistoryViewByTheHistoryNet:(id)responseObject
{
    NSLog(@"%@",responseObject);
}

- (void)setHisrotyViewWhenNoHistoryWithViewController:(LJJInviteRunVC *)VC andView:(LJJInviteRunView *)View
{
//    [View.imageBack setImage:[UIImage imageNamed:@"过短弹窗"]];
//    View.imageBack.frame = CGRectMake(screenWidth * 0.1, screenHeigth * 0.6777, screenWidth * 0.8, screenHeigth * 0.233);
//    //历史记录label
//    View.historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 0.098, screenHeigth * 0.64, screenWidth * 0.37, screenHeigth * 0.02998501)];
//    View.historyLabel.text = @"历史记录";
//    View.historyLabel.textColor = [UIColor grayColor];
//    [VC.view addSubview:View.historyLabel];
    NSLog(@"没有历史记录");
}

- (void)setSearchResponseObject:(id)responseObject
{
    NSLog(@"the responseObject is %@",responseObject);
    NSDictionary *dicData = [responseObject objectForKey:@"data"];
    NSString *strCollege = [dicData objectForKey:@"college"];
    NSString *strName = [dicData objectForKey:@"nickname"];
    NSString *strStuID = [dicData objectForKey:@"student_id"];
    NSLog(@"学院 = %@ 昵称 = %@ 学号 = %@",strCollege,strName,strStuID);
    
    NSUserDefaults *person = [NSUserDefaults standardUserDefaults];
    [person setObject:strCollege forKey:@"personCollege"];
    [person setObject:strName forKey:@"personNickname"];
    [person setObject:strStuID forKey:@"personStuID"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"information" object:nil];
    //设置导航栏
}


@end
