//
//  ZYLUptateRunningData.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/3.
//

#import "ZYLUptateRunningData.h"
#import "AES128Util.h"
#import "GTMBase64.h"
#import "ZYLTimeStamp.h"
#import "ZYLMD5Encrypt.h"
#import <AFNetworking.h>
//非邀约上传跑步数据接口
#define UNINVITE_UPDATERUNNUNGDATAURL @"http://111.230.169.17:8080/mobilerun/user/distance/update"
//邀约上传跑步数据接口
#define INVITE_UPDATERUNNUNGDATAURL @"111.230.169.17:8080/mobilerun/invite/update_data"

@implementation ZYLUptateRunningData

+ (void)ZYLPostUninviteRunningDataWithDataString:(NSString *)dataStr{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    
    NSString *timeStamp = [ZYLTimeStamp getCodeTimeStamp];
    NSString *str = [NSString stringWithFormat:@"%@.%@.%@",token,timeStamp,SALT];
    NSString *salt = [ZYLMD5Encrypt MD5ForLower32Bate: str];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:timeStamp forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:salt forHTTPHeaderField:@"signature"];
    
    [manager POST:UNINVITE_UPDATERUNNUNGDATAURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData: [dataStr dataUsingEncoding:NSUTF8StringEncoding] name:@"rundata"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

+ (void)ZYLPostInviteRunningDataWithDataString:(NSString *)dataStr{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    
    NSString *timeStamp = [ZYLTimeStamp getCodeTimeStamp];
    NSString *str = [NSString stringWithFormat:@"%@.%@.%@",token,timeStamp,SALT];
    NSString *salt = [ZYLMD5Encrypt MD5ForLower32Bate: str];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:timeStamp forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:salt forHTTPHeaderField:@"signature"];
    
    [manager POST:INVITE_UPDATERUNNUNGDATAURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData: [dataStr dataUsingEncoding:NSUTF8StringEncoding] name:@"rundata"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
