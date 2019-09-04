

//
//  MRRunningHisToryModel.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/13.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRRunningHisToryModel.h"
#import "AFNetWorking.h"
@implementation MRRunningHisToryModel
+ (void)getHistorywithPage:(int )page{
    //某一天
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    NSString *string = @"http://running-together.redrock.team/sanzou/user";
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *studentID = [ user objectForKey:@"studentID"];
    //取出学生id
   
    string = [NSString stringWithFormat:@"%@%@%@%@%d",string,@"/",studentID,@"/",page];
    
    //拼接url
    NSURL *url = [NSURL URLWithString:string];
    
    
    
    [manager GET:url.absoluteString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
        NSLog(@"\n\n\nhistory\n\n\%@",responseObject);
        //当请求成功时发送广播
        //将接收到的字典写入数组中
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getHistory" object:[responseObject objectForKey:@"data"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getHistoryFail" object:error];
        NSLog(@"\n\n%@\n\n",error);
    }];
    

    
}

@end
