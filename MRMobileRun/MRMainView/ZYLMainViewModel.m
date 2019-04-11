//
//  ZYLMainViewModel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/2.
//

#import "ZYLMainViewModel.h"
#import <AFNetworking.h>

@implementation ZYLMainViewModel
+ (void)test {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://www.getpostman.com/collections/3b4abff2c4f4a8ebdadc" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
