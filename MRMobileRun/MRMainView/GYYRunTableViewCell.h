//
//  GYYRunTableViewCell.h
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/7/10.
//

#import <UIKit/UIKit.h>
#import "GYYRunModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYYRunTableViewCell : UITableViewCell

@property (nonatomic, strong)GYYRunModel *runModel;
@property (nonatomic, copy)NSDictionary *runDataDic;

@end

NS_ASSUME_NONNULL_END
