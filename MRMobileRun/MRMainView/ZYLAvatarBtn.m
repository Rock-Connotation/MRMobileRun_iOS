//
//  ZYLAvatarBtn.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLAvatarBtn.h"

@implementation ZYLAvatarBtn

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 60, 60);
        
        [self setBackgroundImage:[UIImage imageNamed:@"排行榜默认头像"] forState:UIControlStateNormal];
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        self.clipsToBounds=YES;
        
        self.layer.cornerRadius = self.frame.size.width/2;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
