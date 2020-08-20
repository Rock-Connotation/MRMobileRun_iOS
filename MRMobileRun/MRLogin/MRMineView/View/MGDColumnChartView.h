//
//  MGDColumnChartView.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MGDColumnChartView;

//协议
@protocol MGDColumnChartViewDelegate <NSObject>

//协议方法
- (NSArray *_Nullable)columnChartTitleArrayYear:(NSString *_Nullable)year;

- (NSArray *_Nullable)columnChartNumberArrayFor:(NSString *_Nullable)itemName index:(NSInteger)index year:(NSString *_Nonnull)year;

- (void)changeYearClick:(MGDColumnChartView *_Nullable)chartView sender:(UIButton *_Nullable)sender;

@end

@interface MGDColumnChartView : UIView

@property (nonatomic, weak) id<MGDColumnChartViewDelegate> delegate;

@property (nonatomic, strong) NSString *yearName;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
