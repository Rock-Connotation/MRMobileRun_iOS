//
//  RunningMainPageView.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/10.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "LongPressView.h"
NS_ASSUME_NONNULL_BEGIN

@interface RunningMainPageView : UIView
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIImageView *GPSImgView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *milesLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *dragLabel;
@property (nonatomic, strong) UIImageView *speedImgView;
@property (nonatomic, strong) UIImageView *timeImgView;
@property (nonatomic, strong) UIImageView *energyImgView;
@property (nonatomic, strong) UILabel *speedNumberLbl;
@property (nonatomic, strong) UILabel *timeNumberLbl;
@property (nonatomic, strong) UILabel *energyNumberLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *speedLbl;
@property (nonatomic, strong) UILabel *energyLbl;

@property (nonatomic, strong) UIButton *lockBtn;
@property (nonatomic, strong) LongPressView *endLongPressView;
@property (nonatomic, strong) UIButton *endtBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, strong) UIButton *unlockBtn;
@property (nonatomic, strong) LongPressView *unlockLongPressView;

@property (nonatomic, strong) UIImageView *pauseImgView;
@property (nonatomic, strong) UIImageView *continueImgView;
@property (nonatomic, strong) UIImageView *endImgView;
@property (nonatomic, strong) UILabel *pauseLabel;
@property (nonatomic, strong) UILabel *continueLabel;
@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UIImageView *unlockImgView;
@property (nonatomic, strong) UILabel *unlockLabel;

- (void)mainRunView;
- (void)addMapView;
- (void)addViewOnMap;
- (void)addViewOnBottomView;
- (void)addViewsOnBtn; //在button上添加控件；
@end

NS_ASSUME_NONNULL_END
