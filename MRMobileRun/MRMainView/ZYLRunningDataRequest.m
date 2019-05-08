//
//  ZYLRunningDataRequest.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/8.
//

#import "ZYLRunningDataRequest.h"
#import "ZYLRunningRecordModel.h"
#import <AFNetworking.h>

@implementation ZYLRunningDataRequest

+ (void)ZYLGetPersonnalRunningRecord{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    NSString *student_id = [user objectForKey:@"studentID"];
    
    NSDictionary *params = @{@"student_id": student_id, @"page": @"1"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:kRunningHistoryUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (!responseObject) {
            NSArray *data = responseObject[@"data"];
            if (data != nil && ![data isKindOfClass:[NSNull class]] && data.count != 0) {
                ZYLRunningRecordModel *model = [ZYLRunningRecordModel ModelWithDict:data[0]];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"getPersonnalRunningRecordSuccess" object: model];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
