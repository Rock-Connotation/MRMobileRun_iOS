//
//  MRRankInfo.h
//  AnotherDemo
//
//  Created by RainyTunes on 2017/2/25.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRRankInfo : NSObject
@property NSString *name;
@property NSString *schoolName;
@property NSString *rankIndex;
@property NSString *distance;
@property UIImageView *avatarImage;
+ (instancetype)testInfoWithdic:(NSDictionary *)dic andPageChoose:(NSString *)page;
@end
