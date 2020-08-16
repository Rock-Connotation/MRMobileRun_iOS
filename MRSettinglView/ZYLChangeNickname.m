//
//  ZYLChangeNickname.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/17.
//
/*
 上传更改后的昵称
 使用application/x-www-form-urlencoded格式作为Content-Type
 需要上传token验证信息
 上传字典@{@"nickname": nickname}作为data
 student_id
 */

#import "ZYLChangeNickname.h"
#import <AFNetworking.h>


@implementation ZYLChangeNickname
+ (void)uploadChangedNickname:(NSString *)nickname{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    NSString *student_id = [user objectForKey:@"studentID"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue: token forHTTPHeaderField: @"token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dic = @{@"nickname": nickname};
    __block NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSDictionary *param = @{@"student_id": student_id, @"data": data};
    
    [manager POST:kNicknameUrl parameters: param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        ;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject[@"message"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
