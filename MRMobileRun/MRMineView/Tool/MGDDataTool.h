//
//  MGDDataTool.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/10/11.
//


#import <Foundation/Foundation.h>
#import "MGDSportData.h"
#import "MGDCellDataViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGDDataTool : NSObject

+ (MGDCellDataViewController *) DataToMGDCellDataVC:(MGDSportData *)model;
+ (NSArray *)DataViewArray:(NSArray *)dataArr;
+ (NSMutableArray *)cleanZeroData:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
