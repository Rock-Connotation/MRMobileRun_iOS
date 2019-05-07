//
//  ZYLPolling.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/7.
//

#import "ZYLPolling.h"

@implementation ZYLPolling

+ (void)judgeActionIsEndWithTimer:(NSTimer *)judgeActionIsEndTimer {
    dispatch_queue_t judgeActionIsEndQueue = dispatch_queue_create("judgeActionIsEndQueue", DISPATCH_QUEUE_SERIAL);
    
    __block NSTimer *judgeActionIsEndTimer1 = judgeActionIsEndTimer;
    dispatch_async(judgeActionIsEndQueue, ^{
        judgeActionIsEndTimer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(action) userInfo:nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:judgeActionIsEndTimer1 forMode:NSDefaultRunLoopMode];
        [runLoop run];
    });
}

- (void)action {
    //    邀约是否结束（有一个人上传数据就结束）若结束 上传数据
//    AFHTTPSessionManager *isEndManager = [AFHTTPSessionManager manager];
//    NSString *isEndStrUrl = [kJudegEndUrl stringByAppendingString:[NSString stringWithFormat:@"%ld", self.invite_id]];
//
//    [isEndManager GET:isEndStrUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSString *isEndStr = responseObject[@"data"][@"result"];
//
//
//        if ([isEndStr isEqualToString:@"END"]) {
//            //此处结束跑步，传本次跑步的数据
//
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
}
@end
