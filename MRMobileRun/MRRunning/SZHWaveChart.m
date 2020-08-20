//
//  SZHWaveChart.m
//  SZHChart
//
//  Created by 石子涵 on 2020/8/8.
//  Copyright © 2020 石子涵. All rights reserved.
//

#import "SZHWaveChart.h"
#import <objc/runtime.h>
#import <Masonry.h>

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height
@interface SZHWaveChart()
@property CGPoint lastestPoint; //最后一个坐标点
@property CGPoint startPoint; //最开始的一个坐标点
@property int maxY; //最高的Y轴分割线的位置
@property double spaceY; //Y轴各刻度间的间距；
@property double spaceX;  //X轴各刻度间的间距
@property (nonatomic, strong) UIScrollView *chartScroll;

@property (nonatomic, assign) NSArray *pointAry;

@property (nonatomic, strong) UIColor *textColor;

@property (strong,nonatomic) UIBezierPath *circlePath;
@end

@implementation SZHWaveChart

//初始化视图以及一些属性的封装
- (void)initWithViewsWithBooTomCount:(unsigned long)bottomCout AndLineDataAry:(NSArray *)lineDataAry AndYMaxNumber:(double )YmaxNumber{
    self.spaceY = screenHeight *0.0449;
    self.spaceX = screenWidth * 0.0933;
    self.lineColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    self.lineWidth = 6;
    self.lineColor = [UIColor redColor];
    if (bottomCout < 6) {
        self.bottomXCount = 5;
    }else{
         self.bottomXCount = bottomCout - 1;
    }
    self.lineDataAry = lineDataAry;
    self.YmaxNumber = YmaxNumber;
    self.colorArr = [NSArray arrayWithObjects:(id)[[[UIColor redColor] colorWithAlphaComponent:0.4] CGColor],(id)[[[UIColor whiteColor] colorWithAlphaComponent:0.1] CGColor], nil];
    
    
    //x轴单位、y轴文本、x轴文本的字体颜色
    self.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    
    
    
    //显示图形的ScroolView
    self.chartScroll = [[UIScrollView alloc] init];
    self.chartScroll.bounces = NO; //不回弹
    self.chartScroll.showsHorizontalScrollIndicator = YES;     //不显示X轴的小滑条
    self.chartScroll.backgroundColor = [UIColor clearColor];
    self.chartScroll.contentSize = CGSizeMake( self.bottomXCount * (screenWidth * 0.1333 + 1) , self.chartScroll.bounds.size.height); //self.bottomXCount * (screenWidth * 0.1333)
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
//        make.bottom.equalTo(self.chartScroll.mas_top);
        make.left.equalTo(self.mas_left).offset(screenWidth * 0.04);
        make.size.mas_equalTo(CGSizeMake(28, 16));
    }];
    self.topYlabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
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

//渲染折线图
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
    //遮罩图层轨迹
        UIBezierPath *shelterBezier = [UIBezierPath bezierPath];
        shelterBezier.lineCapStyle = kCGLineCapRound;
        shelterBezier.lineJoinStyle = kCGLineJoinMiter;
    //折线轨迹
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        linePath.lineCapStyle = kCGLineCapRound;
        linePath.lineJoinStyle = kCGLineJoinMiter;
        linePath.lineWidth = 1;
        
    CGFloat X = 0;
        for (int i = 0; i < self.lineDataAry.count; i++) {
        //绘制关键点
            NSNumber * tempNum = self.lineDataAry[i];
            CGFloat ratio = tempNum.floatValue/self.YmaxNumber;
    //               NSLog(@"%f",ratio);
            CGFloat Y = (5 * _spaceY ) * ratio; //关键点的竖直位置
    //        NSLog(@"%f",Y);
            if (i == 0) {
                X = 0;
            }else{
                 X = 8 + i*_spaceX + (i-1)*15; //关键点的横向位置
            }
           
            //绘制折线 和 遮罩层
         
            if (pointAry.count == 0) {
                NSValue *firstvalue = [NSValue valueWithCGPoint:CGPointMake(X, _spaceY * 6 - Y )];
                self.startPoint = [firstvalue CGPointValue];
               
                NSLog(@"开始点的坐标%f,%f",self.startPoint.x,self.startPoint.y);
                [pointAry addObject:firstvalue];
                NSLog(@"添加了一个元素%lu",(unsigned long)pointAry.count);
                [linePath moveToPoint:self.startPoint];
                [shelterBezier moveToPoint:self.startPoint];
            }else if(pointAry.count >= 0){
                //上一个坐标点
                NSValue *lastValue = pointAry.lastObject;
                CGPoint lastPoint = [lastValue CGPointValue];
                NSLog(@"上一个坐标点的坐标%f,%f",lastPoint.x,lastPoint.y);
                //现在的坐标点
                NSValue *currentValue = [NSValue valueWithCGPoint:CGPointMake(X, _spaceY * 6 - Y )];
                CGPoint currentpoint = [currentValue CGPointValue];
                NSLog(@"现在的坐标点的坐标%f,%f",currentpoint.x,currentpoint.y);

                //设置两个控制点
                CGFloat controlX = (lastPoint.x + currentpoint.x)/2;
//                NSLog(@"%f",controlX);
                CGPoint controlPoint1 = CGPointMake(controlX, lastPoint.y);
//                NSLog(@"控制点1的横纵坐标为---%f,------%f",controlPoint1.x,controlPoint1.y);
                CGPoint controlPoint2 = CGPointMake(controlX, currentpoint.y);
//                 NSLog(@"控制点2的横纵坐标为---%f,------%f",controlPoint2.x,controlPoint2.y);
                
                //绘制折线
                [linePath addCurveToPoint:currentpoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
                //将折线添加到scroll上
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                                  lineLayer.path = linePath.CGPath;
                lineLayer.strokeColor = [UIColor clearColor].CGColor;
                                  lineLayer.fillColor = [UIColor clearColor].CGColor;
                                  lineLayer.lineWidth = 1;
                                  lineLayer.lineCap = kCALineCapRound;
                                  lineLayer.lineJoin = kCALineJoinRound;
                                  lineLayer.contentsScale = [UIScreen mainScreen].scale;
                [self.chartScroll.layer addSublayer:lineLayer];
                
                //绘制遮罩层
                [shelterBezier addCurveToPoint:currentpoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
                [pointAry addObject:currentValue];
                if (i == self.lineDataAry.count - 1) {
                    self.lastestPoint = currentpoint;
                    NSLog(@"最后一个坐标点的坐标为%f,%f",self.lastestPoint.x,self.lastestPoint.y);
                    
                    [self dralineWithShelterVezier:shelterBezier AndSTartP:self.startPoint];
                }
//                NSLog(@"元素个数为%lu",(unsigned long)pointAry.count);
            }
        }
     
    self.pointAry = pointAry;
    //图表颜色填充
}

/**
 * 设置颜色渐变
 */
//绘制遮罩层轨迹


- (void)dralineWithShelterVezier:(UIBezierPath *)shelterBezier AndSTartP:(CGPoint )startP{
    CGFloat bgHeight = 6 * _spaceY;  //得到在X轴上
    //获取最后一个点的X值
    CGFloat lastPointX = self.lastestPoint.x;
    //最后一个点对应的x轴的位置
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgHeight);
    [shelterBezier addLineToPoint:lastPointX1]; //遮罩层轨迹绘制
    //回到原点
    [shelterBezier addLineToPoint:CGPointMake(startP.x, bgHeight)];
   
    [shelterBezier addLineToPoint:startP]; //密闭
//    CAShapeLayer *shelterlineLayer = [CAShapeLayer layer];
//                         shelterlineLayer.path = shelterBezier.CGPath;
//                         shelterlineLayer.strokeColor = [UIColor greenColor].CGColor;
//                         shelterlineLayer.fillColor = [UIColor clearColor].CGColor;
//                         shelterlineLayer.lineWidth = 8;
//                         shelterlineLayer.lineCap = kCALineCapRound;
//                         shelterlineLayer.lineJoin = kCALineJoinRound;
//                         shelterlineLayer.contentsScale = [UIScreen mainScreen].scale;
//       [self.chartScroll.layer addSublayer:shelterlineLayer];
    [self addGradientWithBezierPath:shelterBezier];
}

//渐变图层
-(void)addGradientWithBezierPath:(UIBezierPath *)beizer{
    //遮罩层
       CAShapeLayer *shadeLayer = [CAShapeLayer layer];
       shadeLayer.path = beizer.CGPath;
       shadeLayer.fillColor = [UIColor greenColor].CGColor;
       CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(CGRectGetMinX(self.chartScroll.frame), CGRectGetMinY(self.chartScroll.frame), self.chartScroll.contentSize.width, 6 * _spaceY);
       gradientLayer.startPoint = CGPointMake(0, 0);
       gradientLayer.endPoint = CGPointMake(0, 1);
       gradientLayer.cornerRadius = 5;
       gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:56/255.0 green:190/255.0 blue:216/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:106/255.0 green:207/255.0 blue:191/255.0 alpha:0.1].CGColor];
//
    gradientLayer.locations = @[@(0.5)];
       CALayer *baseLayer = [CALayer layer];
       [baseLayer addSublayer:gradientLayer];
       [baseLayer setMask:shadeLayer];
       [self.chartScroll.layer addSublayer:baseLayer];
}





















//-(void)addBezierPoint:(NSArray *)pointArray andColor:(UIColor *)color andColors:(NSArray *)colors{
//    CGPoint startP = CGPointMake(0, 0);
//    startP = [[pointArray objectAtIndex:0] CGPointValue];
//    //直线的连线
//    UIBezierPath *lineBeizer = [UIBezierPath bezierPath];
//    [lineBeizer moveToPoint:startP];
//    _circlePath = lineBeizer;
//    //遮罩层的形状
//    UIBezierPath *shelterBezier = [UIBezierPath bezierPath];
//       shelterBezier.lineCapStyle = kCGLineCapRound;
//       shelterBezier.lineJoinStyle = kCGLineJoinMiter;
//    
//       [shelterBezier moveToPoint:startP];
//    
//    for (int i = 0;i<pointArray.count;i++ ) {
//        if (i > 0) {
//            CGPoint prePoint = [[pointArray objectAtIndex:i-1] CGPointValue];
//            CGPoint nowPoint = [[pointArray objectAtIndex:i] CGPointValue];
//            [lineBeizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
//            [lineBeizer addLineToPoint:nowPoint];
//            [shelterBezier addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
//            if (i == pointArray.count-1) {
//                [lineBeizer moveToPoint:nowPoint];//添加连线
//                lastPoint = nowPoint;
//            }
//        }
//        
//    }
//}
@end


