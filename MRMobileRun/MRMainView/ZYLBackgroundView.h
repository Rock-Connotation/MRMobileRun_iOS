//
//  ZYLBackgroundView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import <UIKit/UIKit.h>
#import "MRWeProgress/WeProgressCircle.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYLBackgroundView : UIView
- (void)initBackground;
- (void)initRunningRecordLabel;
- (void)initLeaderboard;
- (void)initProgressCircle;
@property (nonatomic,strong) WeProgressCircle *progressCircle;
@property (nonatomic,strong) UILabel *timeRecordLabel;
@end

NS_ASSUME_NONNULL_END
