//
//  ZYLClassRankViewModel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import "ZYLClassRankViewModel.h"
#import "ZYLClassRankModel.h"
#import "ZYLRankModel.h"
#import <AFNetworking.h>

@implementation ZYLClassRankViewModel
+ (void)ZYLGetClassRankWithPages:(NSString *)page andtime:(NSString *)time{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"time": time, @"rank": @"class_distance_rank", @"page": page};
    [manager.requestSerializer setValue:kToken forHTTPHeaderField:@"token"];
    [manager GET:kRankListURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        NSMutableArray *modelArray = [NSMutableArray array];
        NSArray *dataArr = dic[@"data"];
        for (NSDictionary *dict in dataArr) {
            ZYLClassRankModel *model = [ZYLClassRankModel ModelWithDict:dict];
            [modelArray addObject: model];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClassRankCatched" object: modelArray];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"classRankRequestError----%@",error);
        NSMutableArray *arr = [@[] mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClassRankCatched" object: arr];
    }];
}

+ (void)ZYLGetMyClassRankWithdtime:(NSString *)time{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"time": time, @"rank": @"class_distance_rank", @"id": @"2017211903"};
    [manager.requestSerializer setValue:kToken forHTTPHeaderField:@"token"];
    [manager GET:kRankURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dataDic = dic[@"data"];
        ZYLRankModel *model = [ZYLRankModel ModelWithDict: dataDic];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyClassRankCatched" object: model];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"personalClassRankRequestError----%@",error);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyClassRankCatched" object: nil];
    }];
}
@end
