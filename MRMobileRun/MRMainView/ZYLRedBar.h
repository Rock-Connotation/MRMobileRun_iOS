//
//  ZYLRedBar.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLRedBar : UIView
//{
//    CAShapeLayer *backgroundLayer; //背景层
//    UIBezierPath *backgroundPath; //背景赛贝尔路径
//    CAShapeLayer *barLayer; //柱状层
//    UIBezierPath *barPath; //柱状赛贝尔路径
//    CATextLayer *textLayer; //数值文字显示层
//    CATextLayer *tittleLayer; //标题文字说明层
//}
//
//@property (nonatomic) UIColor *barColor;//柱的颜色
//@property (nonatomic) float barProgress;//柱子长度 0-1之间
//@property (nonatomic) float barWidth;//柱子宽度
//@property (nonatomic) NSString *barText;//数值
//@property (nonatomic) NSString *barTittle;//标题

@property (nonatomic, strong) UILabel *textLab; //条条左边的名字
@property (nonatomic, strong) UILabel *dataLab; //条条右边的数据
@property (nonatomic, copy) NSString *textLabStr;
@property (nonatomic, copy) NSString *dataLabStr;
@end

NS_ASSUME_NONNULL_END
