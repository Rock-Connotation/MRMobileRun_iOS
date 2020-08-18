//
//  GYYRunModel.h
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYYRunModel : NSObject

//@property (nonatomic, copy) NSString *runModelId;

//@property (nonatomic, copy) NSArry *Aarr; //OtherClass
@property (nonatomic, copy) NSString *SubTitle;    //标题
@property (nonatomic, copy) NSString *NowValue;    //本次值
@property (nonatomic, copy) NSString *LastValue;   //上次值
@property (nonatomic, copy) NSString *Unit;         //单位
//@property (nonatomic, copy) NSString *tip;            //标志  找不到程序会crash

@end

NS_ASSUME_NONNULL_END
