
//
//  MRRankModel.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/26.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRRankModel.h"
#import "MRAvatarModel.h"
#import "AFNetWorking.h"
@interface MRRankModel()
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *studentIdArray;
@property (nonatomic,strong) MRAvatarModel *avatarModel;

@property (nonatomic,strong) NSString *personRequestStatus;
@property (nonatomic,strong) NSString *classRequestStatus;
//判断是否已经发送请求
@end
@implementation MRRankModel

- (void)inquireRankWithPage:(int)page{
    //获取个人排行榜信息
    
    self.personRequestStatus = @"Yes";
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *string = @"http://running-together.redrock.team/sanzou/rank/student/distance";
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@"@"%@"@"%d",string,@"/",page]];
    
    
    if ([self.personRequestStatus isEqualToString:@"Yes"]) {
        self.personRequestStatus = @"No";
        [manager GET:url.absoluteString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            self.personRequestStatus = @"Yes";

            
            self.dataArray = [[NSMutableArray alloc]init];
            
            
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"] ] isEqual: @"<null>"]) {
                
                self.dataArray[0] = @"null";
                
                
            }
            else{
                self.dataArray = [responseObject objectForKey:@"data"] ;
                
            }
            //将请求到的数据解析后放入dataArray中
            
            
            
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"inquireRank" object:self.dataArray];
            
            
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            self.personRequestStatus = @"Yes";

        }];
        

    }
    
}

- (NSString *)getDate{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}



- (void)inquireClassRankWithData:(int )page{
    //获取班级排行榜信息
    self.classRequestStatus = @"Yes";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *string = @"http://running-together.redrock.team/sanzou/rank/class/distance/";
    
    string = [NSString stringWithFormat:@"%@"@"%d",string,page];
    
    
    NSURL *url = [NSURL URLWithString:string];
    if ([self.classRequestStatus isEqualToString:@"Yes"]) {
        
        self.classRequestStatus = @"No";

        
        [manager GET:url.absoluteString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.classRequestStatus = @"Yes";

            
            self.dataArray = [[NSMutableArray alloc]init];
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"] ] isEqual: @"<null>"]) {
                
                self.dataArray[0] = @"null";
                
                
            }
            else{
                self.dataArray = [responseObject objectForKey:@"data"] ;
                
            }
            
            
            
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"inquireClassRank" object:self.dataArray];
            
            
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            self.classRequestStatus = @"Yes";

        }];

        
        
    }
    
    
    
}

- (void)getClassInformation{
    //获取班级信息
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *string = @"http://running-together.redrock.team/sanzou/rank/class/";
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    string = [NSString stringWithFormat:@"%@"@"%@"@"%@",string,[user objectForKey:@"class_id"],@"/distance"];
    
    
    NSURL *url = [NSURL URLWithString:string];
    
    
    [manager GET:url.absoluteString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getClassInformation" object:responseObject];
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

@end
