//
//  ZYLRankViewModel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import "ZYLRankViewModel.h"
#import <AFNetworking.h>

@implementation ZYLRankViewModel

+ (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __block NSString *token = [[NSString alloc] init];
    [manager POST:kLoginURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[@"2017210338" dataUsingEncoding: NSUTF8StringEncoding] name:@"student_id"];
        [formData appendPartWithFormData:[@"010685" dataUsingEncoding: NSUTF8StringEncoding] name:@"password"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"token-----%@",responseObject);
        token = dic[@"data"][@"token"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"rank error----%@",error);
    }];
}


@end
