//
//  ZYLSetAvatarBtn.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/12.
//

#import "ZYLSetAvatarBtn.h"

@implementation ZYLSetAvatarBtn
//更改头像的button
- (instancetype)init{
    if (self = [super init]) {
        [self initAvatarBtu];
        return self;
    }
    return self;
}

- (void)initAvatarBtu{
    
    self.frame = CGRectMake(0, 0, 60, 60);
    
    
    NSUserDefaults *user = [[NSUserDefaults alloc]init];
    NSData *data = [user objectForKey:@"myAvatar"];
    UIImage *avatarImage = [UIImage imageWithData:data];
    
    
    
    
    if (avatarImage == NULL) {
        [self setBackgroundImage:[UIImage imageNamed:@"排行榜默认头像"] forState:UIControlStateNormal];
    }
    else{
        [self setBackgroundImage:avatarImage forState:UIControlStateNormal];
        
    }
    self.clipsToBounds=YES;
    
    self.layer.cornerRadius=123.0/4.0 *screenWidth /375.0;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
