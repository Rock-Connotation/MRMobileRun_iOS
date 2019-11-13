//
//  ZYLNicknameTextField.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/12.
//

#import "ZYLNicknameTextField.h"
#import <Masonry.h>

@implementation ZYLNicknameTextField

- (instancetype)init{
    if (self = [super init]) {
        [self initTextField];
        return self;
    }
    return self;
}

- (void)initTextField{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *nickname = [user objectForKey:@"nickname"];
    self.textAlignment = NSTextAlignmentRight;
    self.font =[UIFont fontWithName:@"DINAlternate-Bold" size:16.0*screenWidth/414.0];
    self.text = nickname;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
