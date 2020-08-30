//
//  MRLoginModel.m
//  MRMobileRun
//
//  Created by J J on 2019/3/31.
//

#import "MRLoginModel.h"
#import "HttpClient.h"
#import <AFNetworking.h>
#import "MRLoginViewController.h"
@implementation MRLoginModel
//java后端版本的登陆的post请求
//- (NSMutableDictionary *)postRequestWithStudentID:(NSString *)studentID andPassword:(NSString *)password
//{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    if ([studentID  isEqual: @""] || [password  isEqual: @""])
//    {
//        NSLog(@"账号密码为空");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFail" object:nil];
//    }
//    else
//    {
//    HttpClient *client = [HttpClient defaultClient];
//    NSLog(@"studentID = %@",studentID);
//    NSLog(@"password = %@",password);
//    [dic setObject:studentID forKey:@"studentId"];
//    [dic setObject:password forKey:@"password"];
//    NSLog(@"%@",dic);
//    NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded"};
//    [client requestWithHead:kLoginURL method:HttpRequestPost parameters:dic head:head prepareExecute:^{
//        //
//    } progress:^(NSProgress *progress) {
//        //
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([[responseObject objectForKey:@"status"] isEqual:@-2])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFail" object:nil];
//        }
//        else
//        {
//
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//
//            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"student_id"] forKey:@"studentID"];
//
//            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"token"] forKey:@"token"];
//            //存储学号
//            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"class_id"] forKey:@"class_id"];
//            //储存班级号
//
//            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"nickname"] forKey:@"nickname"];
//            //存储昵称
//            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"avatar_url"] forKey:@"avatar_url"];
////            存储头像
//            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"signature"] forKey:@"signature"];
////            存储个性签名
//            [user setObject:password forKey:@"password"];
//            [user synchronize];
//            //请求成功时发送广播
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginSuccess" object:nil];
//            NSLog(@"the data is JJ EDC Michael %@",responseObject);
//            self->_threadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cycleToNetWork) userInfo:nil repeats:YES];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateTimer)  name:@"turnOffTimer" object:nil];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer)  name:@"offTimer" object:nil];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keepTimer)  name:@"keepTimer" object:nil];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"the error is %@",error);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFail" object:error];
//    }];
//    }
//    return dic;
//}

//重写登陆的post请求，因为后端改成golang后返回的字段与java版本不同，此处按照postman返回的字段来写的
//登录的post请求
- (NSMutableDictionary *)postRequestWithStudentID:(NSString *)studentID andPassword:(NSString *)password
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([studentID  isEqual: @""] || [password  isEqual: @""])
    {
        NSLog(@"账号密码为空");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFailNoData" object:nil];
    }
    else
    {
    HttpClient *client = [HttpClient defaultClient];
    NSLog(@"studentID = %@",studentID);
    NSLog(@"password = %@",password);
    [dic setObject:studentID forKey:@"studentId"];
    [dic setObject:password forKey:@"password"];
    NSLog(@"%@",dic);
    NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded"};
    [client requestWithHead:kLoginURL method:HttpRequestPost parameters:dic head:head prepareExecute:^{
        //
    } progress:^(NSProgress *progress) {
        //
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqual:@401]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFailErrorData" object:nil];
        } else {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"StudentId"] forKey:@"studentID"];
            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"Token"] forKey:@"token"];

            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"Nickname"] forKey:@"nickname"];
            //存储昵称
            
            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"AvatarUrl"] forKey:@"avatar_url"];
            //            存储头像
            [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"Signature"] forKey:@"signature"];
            //            存储个性签名
            [user setObject:password forKey:@"password"];
            [user synchronize];
                    //请求成功时发送广播
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginSuccess" object:nil];
                    NSLog(@"the data is JJ EDC Michael %@",responseObject);
                    //self->_threadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cycleToNetWork) userInfo:nil repeats:YES];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateTimer)  name:@"turnOffTimer" object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer)  name:@"offTimer" object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keepTimer)  name:@"keepTimer" object:nil];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"the error is %@",error);
                if (error.code == -1001) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFailTimeOut" object:nil];
                }else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginFailNoClient" object:nil];
                }
            }];
    }
    return dic;
}

- (void)invalidateTimer
{
    [_threadTimer invalidate];
}

- (void)keepTimer
{
    [_threadTimer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer
{
    NSLog(@"定时器关闭定时器关闭定时器关闭");
    [_threadTimer setFireDate:[NSDate distantFuture]];
}

- (void)cycleToNetWork
{
    NSLog(@"repeat");
    //轮询是否收到邀约网络请求
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    HttpClient *client = [HttpClient defaultClient];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[user objectForKey:@"studentID"] forKey:@"student_id"];
    NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded",@"token":[user objectForKey:@"token"]};
    [client requestWithHead:kCycleYesOrNoInviteSuccess method:HttpRequestGet parameters:dic head:head prepareExecute:^
     {
         //
     } progress:^(NSProgress *progress)
     {
         //
     } success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"the responseObject is %@",responseObject);
         MRLoginViewController *vc = [[MRLoginViewController alloc] init];
         NSString *status = [responseObject objectForKey:@"status"];
         NSLog(@"stasus is %@",status);
         NSString *codeStr = [NSString stringWithFormat:@"%@",status];
         vc.invitedID = [[responseObject objectForKey:@"data"] objectForKey:@"invited_id"];
         NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
         [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"invited_id"] forKey:@"invite_ID"];
         if ([codeStr isEqualToString:@"200"])
         {
             NSLog(@"发射成功");
             NSLog(@"%@",responseObject);
             //设置弹窗效果
             vc.nickName = [[responseObject objectForKey:@"data"] objectForKey:@"nickname"];
             //NSLog(@"nickName == %@",vc.nickName);
             if (![vc.nickName isEqualToString:[user objectForKey:@"nickname"]])
             {
                 [self stopTimer];
                 [vc setTheSpringWindow];
             }
         }
         else
         {
             NSLog(@"发射失败");
             NSLog(@"%@",responseObject);
         }
     } failure:nil];

}
@end



