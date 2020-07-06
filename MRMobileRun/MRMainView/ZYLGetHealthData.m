//
//  ZYLGetHealthData.m
//  MRMobileRun
//
//  Created by 丁磊 on 2020/4/6.
//

#import "ZYLGetHealthData.h"
#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
@interface ZYLGetHealthData ()

@end

@implementation ZYLGetHealthData

+(id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
        [manager getPermissions];//检查是否获取权限
    });
    return manager;
}

- (void)getPermissions
{
//    if(HKVersion >= 8.0)
//    {
//        if ([HKHealthStore isHealthDataAvailable]) {
//
//            if(self.healthStore == nil)
//            self.healthStore = [[HKHealthStore alloc] init];
//
//            /*
//             组装需要读写的数据类型
//             */
//            NSSet *writeDataTypes = [self dataTypesToWrite];
//            NSSet *readDataTypes = [self dataTypesRead];
//
//            /*
//             注册需要读写的数据类型，也可以在“健康”APP中重新修改
//             */
//            [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
//                if (!success) {
//                    DebugLog(@"%@\n\n%@",error, [error userInfo]);
//                    return ;
//                }
//                else
//                {
//                    //                dispatch_async(dispatch_get_main_queue(), ^{
//                    //                    [self.window.rootViewController presentViewController:tabVC animated:YES completion:nil];
//                    //                });
//                }
//            }];
//        }
//    }
}

@end
