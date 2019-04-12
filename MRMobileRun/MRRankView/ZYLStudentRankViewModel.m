//
//  ZYLStudentRankViewModel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import "ZYLStudentRankViewModel.h"
#import "ZYLStudentRankModel.h"
#import "ZYLRankModel.h"
#import <AFNetworking.h>

@implementation ZYLStudentRankViewModel
+ (void)ZYLGetStudentRankWithPages:(NSString *)page andtime:(NSString *)time{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"time": time, @"rank": @"student_distance_rank", @"page": page};
    
    [manager.requestSerializer setValue:kToken forHTTPHeaderField:@"token"];
    [manager GET:kRankListURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                NSMutableArray *modelArray = [NSMutableArray array];
        NSDictionary *dic = responseObject;
        NSArray *dataArr = dic[@"data"];
        for (NSDictionary *dict in dataArr) {
            ZYLStudentRankModel *model = [ZYLStudentRankModel ModelWithDict:dict];
            [modelArray addObject: model];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StuRankCatched" object: modelArray];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"studentRankRequestError----%@",error);
        NSMutableArray *arr = [@[] mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StuRankCatched" object: arr];
    }];
}

+ (void)ZYLGetMyStudentRankWithdtime:(NSString *)time{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"time": time, @"rank": @"student_distance_rank", @"id": @"2017211903"};
    [manager.requestSerializer setValue:kToken forHTTPHeaderField:@"token"];
    [manager GET:kRankURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dataDic = dic[@"data"];
        ZYLRankModel *model = [ZYLRankModel ModelWithDict: dataDic];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyStuRankCatched" object: model];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"PersonalStudentRankRequest----%@",error);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyStuRankCatched" object: nil];
    }];
}

@end
