//
//  GYYRankModel.m
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/8/12.
//

#import "GYYRankModel.h"
#import <MJExtension.h>

@implementation GYYRankModel

//// NSNumer -> NSString   一劳永逸
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([key isEqualToString:@"Value"]) {
//        self.DistanceValue = [NSString stringWithFormat:@"%.2f", [value floatValue]];
//    }
//}

//property 属性  根据属性名拦截value做基本数据操作
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([property.name isEqualToString:@"DistanceValue"]) {
        return [NSString stringWithFormat:@"%.2f", [oldValue floatValue]];
    }
    return oldValue;
}
    
                        //替换
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"DistanceValue" : @"Value"};
                //新值            //数据返回值    这个可能有冲突   所以选择新值替换
}

@end
