//
//  GYYRankChidlViewController.h
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/8/21.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RankType) {
    RankTypeDay = 0,
    RankTypeWeek,
    RankTypeMonth
};

NS_ASSUME_NONNULL_BEGIN

@interface GYYRankChidlViewController : UIViewController

@property (nonatomic, assign)RankType rankType;
@property (nonatomic, assign)NSInteger isFaculty;

@end

NS_ASSUME_NONNULL_END
