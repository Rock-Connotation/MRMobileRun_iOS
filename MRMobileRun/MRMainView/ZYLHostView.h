//
//  ZYLHostView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import <UIKit/UIKit.h>

@class ZYLBackGroudView;
@class ZYLNumLabel;
@class ZYLRedBar;
@class ZYLGraybar;
NS_ASSUME_NONNULL_BEGIN

@interface ZYLHostView : UIScrollView
@property (nonatomic, strong) ZYLBackGroudView *bkg;

@property (nonatomic, strong) ZYLNumLabel *stepLab;
@property (nonatomic, strong) ZYLNumLabel *stairLab;
@property (nonatomic, strong) ZYLNumLabel *distanceLab_1;
@property (nonatomic, strong) ZYLNumLabel *timeLab;
@property (nonatomic, strong) ZYLNumLabel *distanceLab_2;
@property (nonatomic, strong) ZYLNumLabel *consumeLab;

@property (nonatomic, strong) ZYLRedBar *todayStepBar;
@property (nonatomic, strong) ZYLGraybar *yesterdayStepBar;
@property (nonatomic, strong) ZYLRedBar *todayStairBar;
@property (nonatomic, strong) ZYLGraybar *yesterdayStairBar;
@property (nonatomic, strong) ZYLRedBar *distanceBar_1;
@property (nonatomic, strong) ZYLRedBar *timeBar;
@property (nonatomic, strong) ZYLRedBar *distanceBar_2;
@property (nonatomic, strong) ZYLRedBar *consumeBar;

@property (nonatomic, strong) UILabel *greetLab;
@property (nonatomic, strong) UILabel *weatherLab;
@property (nonatomic, strong) UIImageView *weatherImage;

@property (nonatomic, copy) NSString *greetLabStr;

- (void) setTextOfStepLab:(NSString *)steps andStairLab:(NSString *)stairs;
@end

NS_ASSUME_NONNULL_END
