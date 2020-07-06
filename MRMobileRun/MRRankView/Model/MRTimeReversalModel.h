//
//  MRTimeReversalModel.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/2.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRTimeReversalModel : NSObject
- (NSString *)getTimeStringWithSecond:(int )second;
- (NSString *)postDate;
- (NSString *)getTimestamp;
- (NSString *)getDateWithEndTime:(NSString *)endTime;
- (NSMutableDictionary *)getDateAndChanceFormWithEndTime:(NSString *)endTime;
- (NSString *)getTimeWithBeginTime:(NSString *)beginTime andEndTime:(NSString *)endTime;
    @end
