
//
//  ZYLAvatarRequest.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/20.
//

#import "ZYLAvatarRequest.h"
#import <AFNetworking.h>

@implementation ZYLAvatarRequest

+ (void)ZYLGetAvatarWithStudent_id:(NSString *)student_id{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    由于返回数据是NSData需要设置这一句，不然直接错误了
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc]init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@.jpg", kAvatorURL, student_id];
    [manager GET: urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *imageData = responseObject;
        UIImage *avatarImage = [UIImage imageWithData: imageData scale:1];
        
//        将图片存储在本地
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:imageData forKey: @"myAvatar"];
        [defaults synchronize];
//        返回加载图片
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getAvatarSuccess" object: avatarImage];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
