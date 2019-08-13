//
//  LJJInviteViewModel.m
//  MRMobileRun
//
//  Created by J J on 2019/4/3.
//

#import "LJJInviteViewModel.h"
#import "LJJInviteSearchResultView.h"
#import "LJJInviteRunVC.h"
#import "HttpClient.h"
#import <AFNetworking.h>
@implementation LJJInviteViewModel

- (void)setHistoryViewByTheHistoryNet:(id)responseObject
{
    NSLog(@"%@",responseObject);
}

-(void)setHisrotyViewWithViewControllerAndView:(LJJSearchedView *)View
{
    //NSLog(@"没有历史记录");

    
    //网络请求
    HttpClient *client = [[HttpClient alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[user valueForKey:@"studentID"] forKey:@"student_id"];
    NSDictionary *head = @{@"token":[user objectForKey:@"token"]};
    [client requestWithHead:ktheDataAboutHistoryInvited method:HttpRequestGet parameters:dic head:head prepareExecute:^{
        //
    } progress:^(NSProgress *progress) {
        //
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        __block int i = 0;
        __block int j = 0;
        for (NSDictionary *dictionary in [responseObject objectForKey:@"data"])
        {
            for (NSDictionary *dic in [dictionary objectForKey:@"passive_students"])
            {
                if (![[dic objectForKey:@"student_id"] isEqualToString:[user valueForKey:@"studentID"]])
                {
                    NSLog(@"%@",[dic valueForKey:@"student_id"]);
                    NSLog(@"%@",[dictionary objectForKey:@"distance"]);
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@.jpg", kAvatorURL, [dic valueForKey:@"student_id"]];
                    [manager GET: urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        NSData *imageData = responseObject;
                        UIImage *avatarImage = [UIImage imageWithData:imageData scale:1];
                        View.headView = [[UIImageView alloc] initWithImage:avatarImage];
                        View.headView.frame = CGRectMake(screenWidth *47.0/750, screenHeigth *(43.0 + i * 170)/1334, screenWidth *85.0/750, screenWidth *85.0/750);
                        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:View.headView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:View.headView.bounds.size];
                        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                        maskLayer.frame = View.headView.bounds;
                        maskLayer.path = maskPath.CGPath;
                        View.headView.layer.mask = maskLayer;
                        [View.idInfoScroView addSubview:View.headView];
                        
                        View.cutLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分割线3"]];
                        View.cutLine.frame = CGRectMake(0, screenHeigth *(160.0 + i * 170)/1334, screenWidth, screenWidth *1.77/750);
                        [View.idInfoScroView addSubview:View.cutLine];
                        i ++;
                        NSLog(@"i = %d",i);
                        if (i > 8)
                        {
                            View.idInfoScroView.contentSize = CGSizeMake(screenWidth, screenHeigth * (1 + (41.0 + i * 170)/1334));
                        }
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        NSLog(@"%@",error);
                    }];
                    
                    
                    NSDictionary *head = @{@"Content-Type":@"application/x-www-form-urlencoded",@"token":[user objectForKey:@"token"]};
                    NSMutableDictionary *di = [[NSMutableDictionary alloc] init];
                    [di setObject:[dic objectForKey:@"student_id"] forKey:@"info"];
                    HttpClient *client = [[HttpClient alloc] init];
                    [client requestWithHead:kSearchInfoUrl method:HttpRequestPost parameters:di head:head prepareExecute:^
                    {
                        //
                    } progress:^(NSProgress *progress)
                     {
                        //
                    } success:^(NSURLSessionDataTask *task, id responseObject)
                    {
                        NSString *nickname = [[responseObject objectForKey:@"data"] valueForKey:@"nickname"];
                        View.infoName = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 158.0/750, screenHeigth * (58.0 + j * 170)/1334, screenWidth *500.0/750, screenHeigth *13.0/1334)];
                        View.infoName.text = nickname;
                        
                        
                        NSString *college = [[responseObject objectForKey:@"data"] valueForKey:@"college"];
                        View.infoCollege = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 158.0/750, screenHeigth * (94 + j * 170)/1334, screenWidth *500.0/750, screenHeigth *10.0/1334)];
                        View.infoCollege.text = college;
                        
                        NSString *distance = [NSString stringWithFormat:@"%@%@",[dictionary objectForKey:@"distance"],@"Km"];
                        View.infoDistance = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth * 625.0/750, screenHeigth *(66.0 + j * 170)/1334, screenWidth *100.0/750, screenHeigth * 50.0/1334)];
                        View.infoDistance.text = distance;
                        
                        if (screenHeigth > 800)
                        {
                            View.infoName.font = [UIFont systemFontOfSize:17];
                            View.infoCollege.font = [UIFont systemFontOfSize:15];
                            View.infoDistance.font = [UIFont systemFontOfSize:19];
                        }
                        else if (screenHeigth > 600 && screenHeigth < 800)
                        {
                            View.infoCollege.font = [UIFont systemFontOfSize:13];
                            View.infoName.font = [UIFont systemFontOfSize:15];
                            View.infoDistance.font = [UIFont systemFontOfSize:17];
                        }
                        else if (screenHeigth < 600)
                        {
                            View.infoCollege.font = [UIFont systemFontOfSize:11];
                            View.infoName.font = [UIFont systemFontOfSize:13];
                            View.infoDistance.font = [UIFont systemFontOfSize:15];
                        }
                        
                        View.infoCollege.textColor = [LJJInviteRunVC colorWithHexString:@"#BDBDD3"];
                        View.infoName.textColor = [LJJInviteRunVC colorWithHexString:@"#5E676C"];
                        View.infoDistance.textColor = [LJJInviteRunVC colorWithHexString:@"#9C9CAF"];
                        [View.idInfoScroView addSubview:View.infoName];
                        [View.idInfoScroView addSubview:View.infoCollege];
                        [View.idInfoScroView addSubview:View.infoDistance];
                        
                        j ++;
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error)
                    {
                        //
                        NSLog(@"%@",error);
                    }];
                }
            }
        }        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"the error is %@",error);
    }];
}


- (void)setSearchResponseObject:(id)responseObject
{
    NSLog(@"the responseObject is %@",responseObject);
    NSDictionary *dicData = [responseObject objectForKey:@"data"];
    NSString *strCollege = [dicData objectForKey:@"college"];
    NSString *strName = [dicData objectForKey:@"nickname"];
    NSString *strStuID = [dicData objectForKey:@"student_id"];
    NSLog(@"学院 = %@ 昵称 = %@ 学号 = %@",strCollege,strName,strStuID);
    
    NSUserDefaults *person = [NSUserDefaults standardUserDefaults];
    [person setObject:strCollege forKey:@"personCollege"];
    [person setObject:strName forKey:@"personNickname"];
    [person setObject:strStuID forKey:@"personStuID"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"information" object:nil];
    //设置导航栏
}


@end
