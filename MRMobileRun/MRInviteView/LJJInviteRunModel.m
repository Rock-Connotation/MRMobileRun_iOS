//
//  LJJInviteRunModel.m
//  MRMobileRun
//
//  Created by J J on 2019/4/2.
//

#import "LJJInviteRunModel.h"
#import "LJJInviteViewModel.h"
#import "LJJInviteRunVC.h"
#import "LJJInviteSearchResultViewController.h"
#import "HttpClient.h"
@implementation LJJInviteRunModel

- (void)catchTheLoginToken
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginSuccess" object:nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSLog(@"the token is %@",[user valueForKey:@"token"]);
    NSLog(@"student_id is %@",[user valueForKey:@"studentID"]);
    
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *head = @{@"token":[user valueForKey:@"token"]};
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //[dic setObject:@"2015211878" forKey:@"student_id"];
    [dic setObject:[user valueForKey:@"studentID"] forKey:@"student_id"];
    [client requestWithHead:kInvitationHistoryRecordUrl method:HttpRequestGet parameters:dic head:head prepareExecute:^{
        
    } progress:^(NSProgress *progress) {
        //
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"successful");
        LJJInviteViewModel *m = [[LJJInviteViewModel alloc] init];
        NSArray *arrayData = [responseObject objectForKey:@"data"];
        if (arrayData.count == 0)
        {
            //[m setHisrotyViewWhenNoHistoryWithViewController:VC andView:view];
        }
        //
//        [m setHistoryViewByTheHistoryNet:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error is %@", error);
    }];
}

- (void)invitePeopleToRunURL
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginSuccess" object:nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSLog(@"the token is %@",[user valueForKey:@"token"]);

    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *head = @{@"token":[user valueForKey:@"token"],@"Content-Type":@"application/x-www-form-urlencoded"};
    NSUserDefaults *a = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[a valueForKey:@"textName"] forKey:@"info"];
    NSString *textName = [a valueForKey:@"textName"];
    //网络请求
    [client requestWithHead:kSearchInfoUrl method:HttpRequestPost parameters:dic head:head prepareExecute:^{
        //
    } progress:^(NSProgress *progress) {
        //
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"查找该学生为 : %@",responseObject);
        LJJInviteViewModel *m = [[LJJInviteViewModel alloc] init];
        if ([[responseObject objectForKey:@"status"]  isEqual: @-1001] || [[responseObject objectForKey:@"status"]  isEqual: @19])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchFail" object:nil];
        }
        else if ([textName isEqualToString:@""] || textName.length == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchFail" object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchSuccessful" object:nil];
            [m setSearchResponseObject:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        NSLog(@"%@",error);
    }];
    
}

@end
