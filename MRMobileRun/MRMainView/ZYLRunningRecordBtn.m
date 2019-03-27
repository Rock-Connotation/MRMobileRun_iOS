//
//  ZYLRunningRecordBtn.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import "ZYLRunningRecordBtn.h"
#import <Masonry.h>

@implementation ZYLRunningRecordBtn
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 100, 100);
        [self setImage:[UIImage imageNamed:@"跑步记录右按钮"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        self.runningRecordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.runningRecordImageView.image = [UIImage imageNamed:@"路程按钮icon"];
        [self addSubview:self.runningRecordImageView];
        [self.runningRecordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(25.0/1334.0*screenHeigth, 28.0/750*screenWidth, 24.0/1334.0*screenHeigth, 32.0/750.0*screenWidth));
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
