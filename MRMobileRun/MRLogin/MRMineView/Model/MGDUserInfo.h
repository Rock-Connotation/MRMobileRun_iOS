//
//  MGDUserInfo.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDUserInfo : NSObject

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *userSign;

@property (nonatomic, strong) NSString *userIcon;

@property (nonatomic, strong) NSString *name;

-(instancetype)initWithDic:(NSDictionary *)dict;

+(instancetype)InfoWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
