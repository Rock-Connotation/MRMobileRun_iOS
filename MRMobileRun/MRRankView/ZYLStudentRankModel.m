//
//  ZYLStudentRankModel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import "ZYLStudentRankModel.h"

@implementation ZYLStudentRankModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.college = dic[@"college"];
        self.total = dic[@"total"];
        self.distance = dic[@"distance"];
        self.class_id = dic[@"class_id"];
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
