//
//  LongPressView.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/20.
//

#import "LongPressView.h"
#import <Masonry.h>
#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@interface LongPressView()<CAAnimationDelegate>
{
    SEL _action;
}
@property (unsafe_unretained,nonatomic) id target;
@end

@implementation LongPressView

- (void)initLongPressView{
    //背景色（深色模式适配）
    if (@available(iOS 11.0, *)) {
        self.backgroundColor = WhiteColor;
    } else {
        // Fallback on earlier versions
    }
    
    self.sideColor = [UIColor colorWithRed:123/255.0 green:183/255.0 blue:196/255.0 alpha:1.0];
    
    //中心背景的颜色
    self.bgView = [[UIView alloc] init];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    //将其设置为原型
    self.bgView.layer.cornerRadius = 45;
    self.bgView.layer.masksToBounds = 45 ? YES : NO;
    
    
    self.imgView = [[UIImageView alloc] init];
    [self.bgView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.titleLbl = [[UILabel alloc] init];
    [self.bgView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgView);
        make.top.equalTo(self.imgView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(70, 17));
    }];
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];

}

//让这个View可以添加目标，实现方法
- (void)addTarget:(id)target select:(SEL)selectAction{
    _target = target;
    _action = selectAction;
}

//绘制长按时边缘的动画
- (void)drawRoundView:(CGPoint)centerPoint withStartAngle:(CGFloat)startAngle withEndAngle:(CGFloat)endAngle withRadius:(CGFloat)radius {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle  clockwise:YES];
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.strokeColor = self.sideColor.CGColor;
    _arcLayer.fillColor = [UIColor clearColor].CGColor;
    _arcLayer.path = path.CGPath;
    
    _arcLayer.lineWidth = 6;
    _arcLayer.frame = self.bounds;
    [self.layer addSublayer:_arcLayer];
    
   
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 1;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    bas.removedOnCompletion = NO;
    bas.delegate = self;
    [_arcLayer addAnimation:bas forKey:@"key"];
}

// 核心动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag)
    {
        [_target performSelector:_action withObject:nil afterDelay:0.0];
    }
}

//开始绘制
- (void)startDrawRound{
    [self drawRoundView:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) withStartAngle:DEGREES_TO_RADOANS(-90) withEndAngle:DEGREES_TO_RADOANS(270) withRadius:self.frame.size.height/2-1];
    
}

//结束绘制
- (void)stopDraw{
    if (_arcLayer) {
        [_arcLayer removeAllAnimations];
        [_arcLayer removeFromSuperlayer];
//        _arcLayer = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self startDrawRound];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self stopDraw];
}


@end
