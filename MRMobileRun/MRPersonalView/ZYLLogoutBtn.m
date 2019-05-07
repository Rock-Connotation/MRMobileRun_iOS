//
//  ZYLLogoutBtn.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/12.
//

#import "ZYLLogoutBtn.h"
#import <Masonry.h>

@implementation ZYLLogoutBtn

- (instancetype)init{
    if (self = [super init]) {
        [self initBtu];
        return self;
    }
    return self;
}


- (void)initBtu{
    
    
    
    
    
    [self setTitle:@"退出登录" forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"按钮底2"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    self.contentEdgeInsets = UIEdgeInsetsMake(screenHeigth *26.0/1334.0,screenWidth *257.0/750.0, screenHeigth *38.0/1334.0, screenWidth *254.0/750.0);
    
    
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}


- (void)click{
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
