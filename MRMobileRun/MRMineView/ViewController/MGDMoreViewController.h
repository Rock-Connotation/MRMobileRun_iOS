//
//  MGDMoreViewController.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/13.
//

#import <UIKit/UIKit.h>
#import "MGDRecordTableView.h"
#include "MGDColumnChartView.h"


NS_ASSUME_NONNULL_BEGIN

@interface MGDMoreViewController : UIViewController

@property (nonatomic, strong) NSArray *month;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UILabel *navBarTitle;

@property (nonatomic, strong) MGDRecordTableView *recordTableView;

@property (nonatomic, strong) MGDColumnChartView *columnChartView;


@end

NS_ASSUME_NONNULL_END
