//
//  MGDTabBar.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/8/21.
//

#import "MGDTabBar.h"

@implementation MGDTabBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = MGDColor3;
        } else {
            // Fallback on earlier versions
        }
        [self setUI];
    }
    return self;
}
#pragma 设置UI布局
- (void)setUI{
    self.centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //设置button大小为图片尺寸
    UIImage *normalImage = [UIImage imageNamed:@"begin"];
    if (@available(iOS 11.0, *)) {
        [self.centerBtn setBackgroundColor:RunBackColor];
    } else {
        // Fallback on earlier versions
    }
    self.centerBtn.layer.cornerRadius = 32;
    [self.centerBtn setImage:normalImage forState:UIControlStateNormal];
    self.centerBtn.adjustsImageWhenHighlighted = NO;
   //设置图片位置居中显示
    if (kIs_iPhoneX) {
        self.centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 64)/2, -32 + 19, 64, 64);
    }else {
        self.centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 64)/2, -32 + 13, 64, 64);
    }
    
    [self addSubview:self.centerBtn];
}
//解决超出superView点击无效问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (!view){
        //转换坐标
        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
        //判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)){
            //返回按钮
            return self.centerBtn;
        }
    }
    return view;
}

-(CGSize)sizeThatFits:(CGSize)size{
    CGSize sizeThatFits = [super sizeThatFits:size];
    if (kIs_iPhoneX) {
        sizeThatFits.height = 83;
    }else {
        sizeThatFits.height = 49;
    }
  return sizeThatFits;
}

@end

