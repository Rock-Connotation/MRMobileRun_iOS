//
//  MRRankInfo.m
//  AnotherDemo
//
//  Created by RainyTunes on 2017/2/25.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import "MRRankInfo.h"
//#import "MRAvatarModel.h"
#import "UIImageView+WebCache.h"
//@interface MRAvatarModel()

//@end

@implementation MRRankInfo
+ (instancetype)testInfoWithdic:(NSDictionary *)dic andPageChoose:(NSString *)page{
    
    MRRankInfo *info = [[MRRankInfo alloc] init];

    
    
    if ([page isEqualToString:@"personal"] ) {
        
        
    
    info.avatarImage = [[UIImageView alloc] init];
    
    
    info.name =[dic objectForKey:@"nickname"];
    info.schoolName = [dic objectForKey:@"college"];
    info.distance = [NSString stringWithFormat:@"%@", [dic objectForKey:@"total"] ];
    info.rankIndex = [NSString stringWithFormat:@"%@", [dic objectForKey:@"rank"] ];

        NSLog(@"\n\n\nthe rankIndex is%@\n\n\n",info.rankIndex);
        
    NSString *string = [dic objectForKey:@"student_id"];
    string = [NSString stringWithFormat:@"%@%@",@"http://running-together.redrock.team/sanzou/user/image/",string];
    NSURL *url = [NSURL URLWithString:string];
    
    NSLog(@"%@",url);
    [info.avatarImage sd_setImageWithURL:url   placeholderImage:[UIImage imageNamed:@"排行榜默认头像"]];
        
        
//

        
        
    }
    
    if ([page isEqualToString:@"class"] ) {
        
        NSLog(@"\n\n\n\n\n\n\n%@\n\n",page);
        
        info.name =[NSString stringWithFormat:@"%@",[dic objectForKey:@"class_id"] ];
        info.schoolName = [dic objectForKey:@"college"];
        info.distance = [NSString stringWithFormat:@"%@", [dic objectForKey:@"total"] ];
        info.rankIndex = [NSString stringWithFormat:@"%@", [dic objectForKey:@"rank"] ];
        
    }
    
    return info;
}
@end
