//
//  MRRunningHistoryTrackModel.m
//  MRMobileRun
//
//  Created by J J on 2019/9/3.
//

#import "MRRunningHistoryTrackModel.h"
#import "MRRunningHistoryTrackController.h"
#import "HttpClient.h"
@implementation MRRunningHistoryTrackModel
- (void)loadData
{
    HttpClient *client = [HttpClient defaultClient];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [client requestWithHead:kHistoryTrack method:HttpRequestGet parameters:@{@"student_id":[user valueForKey:@"studentID"]} head:@{@"token":[user valueForKey:@"token"]} prepareExecute:^{
        //
    } progress:^(NSProgress *progress) {
        //
    } success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSString *pageSize = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"this_pageSize"]];
         NSUInteger columeNum = 0;
         if (![pageSize isEqualToString:@"0"])
         {
             NSArray *arr = [responseObject valueForKey:@"data"];
             MRRunningHistoryTrackController *vc = [[MRRunningHistoryTrackController alloc] init];
             vc.distanceArr = [[NSMutableArray alloc] init];
             vc.dateArr = [[NSMutableArray alloc] init];
             for (NSMutableArray *array in arr[0])
             {
                 NSString *distance = [array valueForKey:@"distance"];
                 NSString *date = [array valueForKey:@"date"];
                 NSLog(@"distance == %@",distance);
                 NSLog(@"date == %@",date);
                 [vc.dateArr addObject:date];
                 [vc.distanceArr addObject:distance];
                 columeNum ++;
             }
             [user setInteger:columeNum forKey:@"colume"];
             [user setObject:vc.dateArr forKey:@"dateArray"];
             [user setObject:vc.distanceArr forKey:@"distanceArray"];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"NoTrack" object:nil];
         }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
