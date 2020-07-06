//
//  ZYLRankModel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/12.
//

#import "ZYLRankModel.h"

@implementation ZYLRankModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.college = dic[@"college"];
        self.total = dic[@"total"];
        self.distance = dic[@"distance"];
        self.prev_difference = dic[@"prev_difference"];
        self.nickname = dic[@"nickname"];
        self.student_id = dic[@"student_id"];
        self.rank = dic[@"rank"];
        self.steps = dic[@"steps"];
    }
    return self;
}

+ (instancetype)ModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDic: dict];
}
@end
