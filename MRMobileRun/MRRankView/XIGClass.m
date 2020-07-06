//
//  XIGClass.m
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/20.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "XIGClass.h"

@implementation XIGClass
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"XIGView" owner:self options:nil] firstObject];
        view.frame = frame;
        [self addSubview:view];
    }
    
    return self;
}
-(void)setKindLabel:(NSString *)kind{
    _recordKindLabel.text = kind;
    _diffKindLabel.text = kind;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
