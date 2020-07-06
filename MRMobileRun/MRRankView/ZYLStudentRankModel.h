//
//  ZYLStudentRankModel.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLStudentRankModel : NSObject
@property (copy, nonatomic) NSString *college;
@property (copy, nonatomic) NSNumber *total;
@property (copy, nonatomic) NSNumber *distance;
@property (copy, nonatomic) NSString *class_id;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *student_id;
@property (copy, nonatomic) NSNumber *rank;
@property (copy, nonatomic) NSNumber *steps;
- (instancetype)initWithDic:(NSDictionary*)dic;
+ (instancetype)ModelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
