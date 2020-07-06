//
//  ZYLGraybar.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/26.
//

#import "ZYLGraybar.h"
#import <Masonry.h>
@implementation ZYLGraybar

 - (instancetype)init
 {
     self = [super init];
     if (self) {
         self.backgroundColor =  COLOR_WITH_HEX(0xE1E4E5);
         self.layer.cornerRadius = 4;
//
         self.textLab = [[UILabel alloc] init];
         self.textLab.textColor = [UIColor whiteColor];
         self.textLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*kRateX];
         self.textLab.textAlignment = NSTextAlignmentLeft;
         [self addSubview: self.textLab];
         
         self.dataLab = [[UILabel alloc] init];
         self.dataLab.textColor = [UIColor whiteColor];
         self.dataLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*kRateX];
         self.dataLab.textAlignment = NSTextAlignmentLeft;
         [self addSubview: self.dataLab];
//         barLayer = [CAShapeLayer new];
//         [self.layer addSublayer:barLayer];
//         barLayer.strokeColor = COLOR_WITH_HEX(0xE1E4E5).CGColor;
//         barLayer.lineCap = kCALineCapButt;
//         barLayer.frame = self.bounds;
//
//         self.barWidth = self.bounds.size.width;
     }
     return self;
 }
- (void)setTextLabStr:(NSString *)textLabStr{
    CGSize size = [textLabStr sizeWithAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:14*kRateX]}];
    self.textLab.frame = CGRectMake(5*kRateX, 2.5*kRateY, size.width, size.height);
    self.textLab.text = textLabStr;
}

- (void)setDataLabStr:(NSString *)dataLabStr{
//    CGSize size = [dataLabStr sizeWithAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:14]}];
    [self.dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize size = [dataLabStr sizeWithAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:14*kRateX]}];
        make.right.equalTo(self.mas_right).mas_offset(-10*kRateX);
        make.top.equalTo(self.mas_top).mas_offset(2.5);
        make.width.mas_equalTo(size.width+10*kRateY);
        make.height.mas_equalTo(size.height);
    }];
    self.dataLab.text = dataLabStr;
}
// //设置百分百（显示动画）
// - (void)setProgress
// {
//     barPath = [UIBezierPath bezierPath];
//     [barPath moveToPoint:CGPointMake(self.bounds.origin.x, self.bounds.origin.y+self.bounds.origin.y+self.bounds.size.height/2)];
//     [barPath addLineToPoint:CGPointMake(self.bounds.size.width*_barProgress, self.bounds.origin.y+self.bounds.origin.y+self.bounds.size.height/2)];
//     [barPath setLineWidth:_barWidth];
//     [barPath setLineCapStyle:kCGLineCapSquare];
//
//     CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//     pathAnimation.duration = 1.0;
//     pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//     pathAnimation.fromValue = @0.0f;
//     pathAnimation.toValue = @1.0f;
//     [barLayer addAnimation:pathAnimation forKey:nil];
//
//     barLayer.strokeEnd = 1.0;
//
//     barLayer.path = barPath.CGPath;
// }
//
// //设置柱子的宽度
// - (void)setBarWidth:(float)progressWidth
// {
//     _barWidth = progressWidth;
//     barLayer.lineWidth = _barWidth;
//
//     [self setProgress];
// }
//
//
// //设置柱子颜色
// - (void)setBarColor:(UIColor *)barColor
// {
//     barLayer.strokeColor = barColor.CGColor;
// }
//
// //设置柱子进度
// - (void)setBarProgress:(float)progress
// {
//     _barProgress = progress;
//     [self setProgress];
// }
//
// //设置数值
// - (void)setBarText:(NSString*)text{
//     textLayer = [CATextLayer layer];
//     textLayer.string = text;
//     textLayer.foregroundColor = COLOR_WITH_HEX(0xA0A0A0).CGColor;
//     textLayer.font = CFBridgingRetain([UIFont fontWithName:@"PingFangSC-Regular" size: 14]);
//     textLayer.alignmentMode = kCAAlignmentLeft;
//
//     textLayer.bounds = barLayer.bounds;
//     textLayer.position = CGPointMake(self.bounds.size.width*3/2 + 5 , self.bounds.size.height/2);
//     CABasicAnimation *fade = [self fadeAnimation];
//     [textLayer addAnimation:fade forKey:nil];
//     [self.layer addSublayer:textLayer];
// }
//
// //设置标题
// - (void)setBarTittle:(NSString*)tittle{
//     tittleLayer = [CATextLayer layer];
//     tittleLayer.string = tittle;
//     tittleLayer.foregroundColor = COLOR_WITH_HEX(0xA0A0A0).CGColor;
//     tittleLayer.font = CFBridgingRetain([UIFont fontWithName:@"PingFangSC-Regular" size: 14]);
//     tittleLayer.alignmentMode = kCAAlignmentRight;
//
//     tittleLayer.bounds = barLayer.bounds;
//     tittleLayer.position = CGPointMake(-self.bounds.size.width/2 , self.bounds.size.height/2);
//     CABasicAnimation *fade = [self fadeAnimation];
//     [tittleLayer addAnimation:fade forKey:nil];
//     [self.layer addSublayer:tittleLayer];
// }
//
// //渐变动画
// -(CABasicAnimation*)fadeAnimation
// {
//     CABasicAnimation* fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//     fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
//     fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
//     fadeAnimation.duration = 2.0;
//
//     return fadeAnimation;
// }

@end
