//
//  MRLoginModel.m
//  MRMobileRun
//
//  Created by J J on 2019/3/31.
//

#import "MRLoginModel.h"
#import "HttpClient.h"
@implementation MRLoginModel

//登录的post请求
- (NSMutableDictionary *)postRequestWithStudentID:(NSString *)studentID andPassword:(NSString *)password
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([studentID  isEqual: @""] || [password  isEqual: @""])
    {
        NSLog(@"账号密码为空");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFail" object:nil];
    }
    else
    {
    NSString *url = @"http://111.230.169.17:8080/mobilerun/user/login";
    HttpClient *client = [HttpClient defaultClient];
    NSLog(@"studentID = %@",studentID);
    NSLog(@"password = %@",password);
    [dic setObject:studentID forKey:@"student_id"];
    [dic setObject:password forKey:@"password"];
    NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    [client requestWithHead:url method:HttpRequestPost parameters:dic head:head prepareExecute:^{
        //
    } progress:^(NSProgress *progress) {
        //
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqual:@-2])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFail" object:nil];
        }
        else
        {
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"student_id"] forKey:@"studentID"];
            
            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"token"] forKey:@"token"];
            //存储学号
            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"class_id"] forKey:@"class_id"];
            //储存班级号
            
            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"nickname"] forKey:@"nickname"];
            //存储昵称
            //请求成功时发送广播
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginSuccess" object:nil];
            NSLog(@"%@",responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"the error is %@",error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFail" object:error];
    }];
    }
    return dic;
}
@end
