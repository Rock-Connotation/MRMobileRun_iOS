//
//  ZYLRunningRecordModel.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/8.
//

#import "ZYLRunningRecordModel.h"

@implementation ZYLRunningRecordModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.begin_time = dic[@"begin_time"];
        self.end_time = dic[@"end_time"];
        self.distance = dic[@"distance"];
        self.invite_id = dic[@"id"];
        self.student_id = dic[@"student_id"];
        self.date = dic[@"date"];
    }
    return self;
}

+ (instancetype)ModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDic: dict];
}

@end
