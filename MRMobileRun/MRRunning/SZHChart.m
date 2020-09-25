//
//  SZHChart.m
//  SZHChart
//
//  Created by 石子涵 on 2020/8/6.
//  Copyright © 2020 石子涵. All rights reserved.
//


#import "SZHChart.h"
#import <objc/runtime.h>
#import <Masonry.h>

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height
@interface SZHChart()
@property int maxY; //最高的Y轴分割线的位置
@property double spaceY; //Y轴各刻度间的间距；
@property double spaceX;  //X轴各刻度间的间距
@property (nonatomic, strong) UIScrollView *chartScroll;

@property (nonatomic, assign) NSArray *pointAry;

@property (nonatomic, strong) UIColor *textColor;
@end



@implementation SZHChart
//初始化视图以及一些属性的封装
- (void)initWithViewsWithBooTomCount:(unsigned long )bottomCout AndLineDataAry:(NSArray *)lineDataAry AndYMaxNumber:(double )YmaxNumber{
    //对一些数据的初始化
    self.spaceY = screenHeight *0.0449;
    self.spaceX = screenWidth * 0.0933;
    self.lineColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.lineWidth = 6;
    self.lineColor = [UIColor redColor];
    self.bottomXCount = 0;          //初始的X轴lable的个数为0
    NSLog(@"传进来的速度数组为%@",lineDataAry);
//    self.bottomXCount = bottomCout - 1;
//    if ((bottomCout - 1 == 0 && bottomCout - 1 > 0) || (bottomCout - 1) < 6) {
//        self.bottomXCount = 6;
//    }else{
//        self.bottomXCount = (bottomCout - 1)/2;
//    }
    if (bottomCout - 1 < 6) {
        self.bottomXCount = 6;
    }else{
        self.bottomXCount = bottomCout - 1;
    }
    self.lineDataAry = lineDataAry;
    self.YmaxNumber = YmaxNumber;
    
    //x轴单位、y轴文本、x轴文本的字体颜色
    self.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    
   
    //显示图形的ScroolView
    self.chartScroll = [[UIScrollView alloc] init];
    self.chartScroll.bounces = NO; //不回弹
    self.chartScroll.showsHorizontalScrollIndicator = NO;     //不显示X轴的小滑条
    self.chartScroll.backgroundColor = [UIColor clearColor];
    self.chartScroll.contentSize = CGSizeMake( self.bottomXCount * (screenWidth * 0.1333 + 1) , self.chartScroll.bounds.size.height); //
    [self addSubview:self.chartScroll];
    [self.chartScroll mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.topYlabel.mas_right).offset(-10);
        make.left.equalTo(self).offset(screenWidth * 0.04 + 28 - 10);
        make.bottom.equalTo(self.mas_bottom);
        //        make.top.equalTo(self.topYlabel.mas_bottom);
        make.height.mas_equalTo(_spaceY * 6 + 20);
        make.width.mas_equalTo(screenWidth * 0.824);
    }];
    
    //Y轴单位label
           self.topYlabel = [[UILabel alloc] init];
           [self addSubview:self.topYlabel];
           [self.topYlabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self);
//               make.bottom.equalTo(self.chartScroll.mas_top);
               make.left.equalTo(self.mas_left).offset(screenWidth * 0.04);
               make.size.mas_equalTo(CGSizeMake(28, 16));
           }];
        self.topYlabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        self.topYlabel.textColor = [UIColor colorWithRed:65/255.0 green:68/255.0 blue:72/255.0 alpha:1.0];
    
    //X轴单位Label
    self.bottomXLabel = [[UILabel alloc] init];
    [self addSubview:self.bottomXLabel];
    [self.bottomXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chartScroll.mas_right);
        make.bottom.equalTo(self.chartScroll.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(16, 11));
    }];
    self.bottomXLabel.textColor = self.textColor;
    self.bottomXLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 8];
    
    //最左边的0
    UILabel *left0 = [[UILabel alloc] init];
    [self addSubview:left0];
    [left0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topYlabel);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 11));
    }];
    left0.text = @"0";
    left0.textAlignment = NSTextAlignmentRight;
    left0.textColor = self.textColor;
    left0.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];

    [self drawLineChart];
    
}
/**
 渲染折线图
 */
- (void)drawLineChart{
    
    NSMutableArray *muteableAry = [NSMutableArray array]; //用来存储左边label的数组
  
    //绘制纵轴文本和纵轴分割线
    for (int i = 1; i < 6; i++) {
        //绘制纵轴文本的label
        UILabel *leftLbl = [[UILabel alloc] init];
        leftLbl.textColor = self.textColor;
        leftLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 8];
        leftLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:leftLbl];
        [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topYlabel);
            make.bottom.equalTo(self.mas_bottom).offset(- _spaceY*i - 20 + 7.5);
            make.size.mas_equalTo(CGSizeMake(15, 11));
        }];
        
        //纵轴的分割线
        CALayer *line = [[CALayer alloc] init];
        line.frame = CGRectMake(0,0 + i * _spaceY,self.chartScroll.contentSize.width, 1);
        line.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor;
        if (i == 5) {
            CGFloat maxY = CGRectGetMaxY(line.frame);
            self.maxY = maxY;
//            NSLog(@"--------------%d",self.maxY);
        }
        [self.chartScroll.layer addSublayer:line];
        [muteableAry addObject:leftLbl];
    }
    self.leftLblAry = muteableAry;
    
    //绘制X轴
    CALayer *bottomline = [[CALayer alloc] init];
    bottomline.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor;
    bottomline.frame = CGRectMake(0,6 * _spaceY,self.chartScroll.contentSize.width, 1);
    [self.chartScroll.layer addSublayer:bottomline];
    
     //X轴文字
    for (int i = 1; i < self.bottomXCount + 1; i++) {
        UILabel *bottomlbl = [[UILabel alloc] init];
        bottomlbl.frame = CGRectMake(0 + i*_spaceX + (i-1)*15, 6 * _spaceY + 10, 15, 11);
        [self.chartScroll addSubview:bottomlbl];
        bottomlbl.text = [NSString stringWithFormat:@"%d", i * 5];
        bottomlbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
        bottomlbl.textColor = self.textColor;
        bottomlbl.textAlignment = NSTextAlignmentCenter;
    }
    //绘制折线
    [self drawLine];

}

/**
 * 绘制折线
 */
- (void)drawLine{
      NSMutableArray *pointAry = [NSMutableArray array]; //用来存储关键点的数组
        for (int i = 0; i < self.lineDataAry.count; i++) {
        //绘制关键点
            NSNumber * tempNum = self.lineDataAry[i];
            CGFloat ratio = tempNum.floatValue/self.YmaxNumber;
    //               NSLog(@"%f",ratio);
            CGFloat Y = 0;
//            if (tempNum.floatValue < 2) {
//               Y = ((6 * _spaceY ) * ratio)/2; //关键点的竖直位置
//            }else{
                Y = (6 * _spaceY ) * ratio; //关键点的竖直位置
//            }
          
    //        NSLog(@"%f",Y)
            //关键点的横向位置;
            CGFloat X = 0;
             if (i == 0) {
                X = 0;
                       }else{
                X = (8 + i*_spaceX + (i-1)*15)/2;
                       }
            
            //绘制折线
            if (pointAry.count == 0) {
                NSValue *firstvalue = [NSValue valueWithCGPoint:CGPointMake(X, _spaceY * 6 - Y + _spaceY)];
                [pointAry addObject:firstvalue];
                NSLog(@"添加了一个元素%lu",(unsigned long)pointAry.count);
            }else if(pointAry.count >= 0){
                //上一个坐标点
                NSValue *lastValue = pointAry.lastObject;
                CGPoint lastPoint = [lastValue CGPointValue];
                //现在的坐标点
                NSValue *currentValue = [NSValue valueWithCGPoint:CGPointMake(X, _spaceY * 6 - Y + _spaceY )];
                CGPoint currentpoint = [currentValue CGPointValue];
                //设置两个控制点
                CGFloat controlX = (lastPoint.x + currentpoint.x)/2;
                NSLog(@"%f",controlX);
                CGPoint controlPoint1 = CGPointMake(controlX, lastPoint.y);
                NSLog(@"控制点1的横纵坐标为---%f,------%f",controlPoint1.x,controlPoint1.y);
                CGPoint controlPoint2 = CGPointMake(controlX, currentpoint.y);
                 NSLog(@"控制点2的横纵坐标为---%f,------%f",controlPoint2.x,controlPoint2.y);
                UIBezierPath *linePath = [UIBezierPath bezierPath];
                linePath.lineCapStyle = kCGLineCapRound;
                linePath.lineJoinStyle = kCGLineJoinMiter;
                linePath.lineWidth = 6;
//                [linePath moveToPoint:lastPoint];
                [linePath addCurveToPoint:currentpoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
                [linePath addLineToPoint:currentpoint];

                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                                  lineLayer.path = linePath.CGPath;
                                  lineLayer.strokeColor = self.lineColor.CGColor;
                                  lineLayer.fillColor = [UIColor clearColor].CGColor;
                                  lineLayer.lineWidth = self.lineWidth;
                                  lineLayer.lineCap = kCALineCapRound;
                                  lineLayer.lineJoin = kCALineJoinRound;
                                  lineLayer.contentsScale = [UIScreen mainScreen].scale;
                [self.chartScroll.layer addSublayer:lineLayer];
                
                [pointAry addObject:currentValue];
                NSLog(@"元素个数为%lu",(unsigned long)pointAry.count);
        }
    }
}

   
@end

