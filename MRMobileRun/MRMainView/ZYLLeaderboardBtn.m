//
//  ZYLLeaderboardBtn.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLLeaderboardBtn.h"
#import <Masonry.h>

@implementation ZYLLeaderboardBtn
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 100, 100);
        [self setImage:[UIImage imageNamed:@"排行榜左按钮"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        self.leaderboardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.leaderboardImageView.image = [UIImage imageNamed:@"Group 11"];
        [self addSubview:self.leaderboardImageView];
        [self.leaderboardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(24.0/1334.0*screenHeigth, 26.0/750.0*screenWidth, 32.0/1334.0*screenHeigth, 36.0/750.0*screenWidth));
        }];
    }
    return self;
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
