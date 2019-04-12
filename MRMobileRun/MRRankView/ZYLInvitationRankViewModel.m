//
//  ZYLInvitationRankViewModel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import "ZYLInvitationRankViewModel.h"
#import "ZYLInvitationRankModel.h"
#import "ZYLRankModel.h"
#import <AFNetworking.h>

@implementation ZYLInvitationRankViewModel
+ (void)ZYLGetInvitationRankWithPages:(NSString *)page andtime:(NSString *)time{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"time": time, @"rank": @"student_invitation_rank", @"page": page};
    [manager.requestSerializer setValue:kToken forHTTPHeaderField:@"token"];
    [manager GET:kRankListURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *modelArray = [NSMutableArray array];
        NSDictionary *dic = responseObject;
        NSArray *dataArr = dic[@"data"];
        for (NSDictionary *dict in dataArr) {
            ZYLInvitationRankModel *model = [ZYLInvitationRankModel ModelWithDict:dict];
            [modelArray addObject: model];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InviteRankCatched" object: modelArray];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"InvationRankRequestError----%@",error);
        NSMutableArray *arr = [@[] mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InviteRankCatched" object: arr];
    }];
}

+ (void)ZYLGetMyInvitationRankWithdtime:(NSString *)time{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"time": time, @"rank": @"student_invitation_rank", @"id": @"2017211903"};
    [manager.requestSerializer setValue:kToken forHTTPHeaderField:@"token"];
    [manager GET:kRankURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dataDic = dic[@"data"];
        ZYLRankModel *model = [ZYLRankModel ModelWithDict: dataDic];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyInviteRankCatched" object: model];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"PersonalInvatationRankRequestError----%@",error);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyInviteRankCatched" object: nil];
    }];
}
@end
