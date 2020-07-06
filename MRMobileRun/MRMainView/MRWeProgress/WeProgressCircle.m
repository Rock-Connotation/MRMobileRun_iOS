//
//  ProgressCircle.m
//  test
//
//  Created by RainyTunes on 16/12/5.
//  Copyright © 2016年 We.Can. All rights reserved.
//

#import "WeProgressCircle.h"
#import "Masonry.h"
@interface WeProgressCircle ()
@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation WeProgressCircle

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeProgressCircle" owner:self options:nil];
        UIView *v = (UIView *)[nib objectAtIndex:0];
        v.frame = frame;
        [self addSubview:v];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeProgressCircle" owner:self options:nil];
        UIView *v = (UIView *)[nib objectAtIndex:0];
        v.frame = self.bounds;
        [self addSubview:v];
    }
    return self;
}

- (void)startAnimation {
    double height = self.frame.size.height;
    double width = self.frame.size.width;

    //    if (height != 185) {
    //        [NSException raise:@"circle frame error" format:@"circle height is %lf, but expected 185",height];
    //    }
    //    if (width != 189.5) {
    //        [NSException raise:@"circle frame error" format:@"circle width is %lf, but expected 189.5",width];
    //    }
    double remainAngle = 1080 / 180 * M_PI;
    double nowAngle = 0;
    self.layer.anchorPoint = CGPointMake(0.488126649, 0.5);
    [self rotateWithNowAngle:nowAngle remainAngle:remainAngle];
}

- (void)rotateWithNowAngle:(double)nowAngle remainAngle:(double)remainAngle{
    if (remainAngle >= M_PI_2) {
        remainAngle = remainAngle - M_PI_2;
        nowAngle = nowAngle + M_PI_2;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeRotation(nowAngle);
        } completion:^(BOOL finished) {
            [self rotateWithNowAngle:nowAngle remainAngle:remainAngle];
        }];
    } else {
        nowAngle = nowAngle + remainAngle;
        remainAngle = 0;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeRotation(nowAngle);
        } completion:nil];
    }
}

- (void)stopAnimation;
{
    NSLog(@"停止动画");
    [self.view.layer removeAllAnimations];
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
