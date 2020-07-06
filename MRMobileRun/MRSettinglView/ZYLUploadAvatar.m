//
//  ZYLUploadAvatar.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/17.
//
/*
 上传更改后的头像
 使用fromdata格式需要的数据如下
 jpg图像存入nsdat作为file
 student_id
 */

#import "ZYLUploadAvatar.h"
#import <AFNetworking.h>

@implementation ZYLUploadAvatar
+ (void)UpdateAvatarWithImage:(UIImage *)image{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue: token forHTTPHeaderField:@"token"];

    __block NSString *student_id = [user objectForKey:@"studentID"];
    __block NSData *avatar = UIImageJPEGRepresentation(image, 1);
    
    [manager POST: kUploadAvatarUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[student_id dataUsingEncoding: NSUTF8StringEncoding] name:@"student_id"];
        [formData appendPartWithFileData: avatar name: @"file" fileName: [NSString stringWithFormat:@"%@,jpg",student_id] mimeType: @"image/jpg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject[@"message"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
