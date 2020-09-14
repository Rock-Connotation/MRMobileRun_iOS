//
//  LongPressView.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/20.
//


#import <UIKit/UIKit.h>
#import "SVGKit.h"
#import "SVGKImage.h"
#import "SVGKParser.h"

NS_ASSUME_NONNULL_BEGIN

//解锁、结束时长按手势的解锁，配上slider的颜色

@interface LongPressView : UIView
@property (nonatomic, strong)UIImageView *imgView; //png格式
//@property (nonatomic, strong)SVGKLayeredImageView *imgview; //SVG格式
@property (nonatomic, strong)UILabel *titleLbl;
@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, strong)UIColor *sideColor;
@property (nonatomic,strong)  CAShapeLayer *arcLayer;

- (void)initLongPressView;
- (void)addTarget:(id)target select:(SEL)selectAction;
- (void)stopDraw;
@end

NS_ASSUME_NONNULL_END
