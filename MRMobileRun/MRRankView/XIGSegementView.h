//
//  XIGSegementView.h
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentViewScrollerViewDelegate <NSObject>

@required

- (void)eventWhenScrollSubViewWithIndex:(NSInteger)index;

@end

@interface XIGSegementView: UIView
@property (weak,nonatomic) id<SegmentViewScrollerViewDelegate> eventDelegate;
//标题部分
/*
 titleViewStyle设置titleView下面的滑条，为custom时有滑条
 */
@property (strong,nonatomic)NSString *titleViewStyle;
@property (strong,nonatomic)UIColor *titleTextNormalColor;
@property (strong,nonatomic)UIColor *titleTextFocusColor;
@property (strong,nonatomic)UIColor *titleBackGroundColor;
@property (assign)CGFloat titleHight;

- (instancetype)initWithFrame:(CGRect)frame andControllers:(NSArray <UIViewController *> *)controllers WithStyle:(NSString *)style;


@end
