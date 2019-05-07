//
//  ZYLRunningRecordView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/2.
//

#import <UIKit/UIKit.h>
#import "MRRunningLabel.h"
#import "MRNumLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYLRunningRecordView : UIView
- (instancetype)init;
@property (nonatomic,strong)  MRRunningLabel *runningTimeLabel;

@property (nonatomic,strong) MRNumLabel *runningDiastanceLabel;
@end

NS_ASSUME_NONNULL_END
