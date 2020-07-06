//
//  ZYLCountdownView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2020/4/7.
//

#import "ZYLCountdownView.h"
#import <Masonry.h>
@implementation ZYLCountdownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_WITH_HEX(0x64686F);
        
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.font = [UIFont fontWithName:@"Impact" size:160*kRateY];
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.numberOfLines = 1;
        [self addSubview: self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).mas_offset(-130*kRateY);
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(200*kRateX);
            make.height.mas_equalTo(200*kRateY);
        }];
        
        self.startButton = [[UIButton alloc]init];
        self.startButton.titleLabel.textColor = [UIColor whiteColor];
        self.startButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC" size:16*kRateX];
        [self.startButton setTitle:@"直接开始" forState:UIControlStateNormal];
        self.startButton.backgroundColor = COLOR_WITH_HEX(0xFFFFFF);
        [self addSubview: self.startButton];
        [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).mas_offset(-229*kRateY);
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(168*kRateX);
            make.height.mas_equalTo(52*kRateY);
        }];
    }
    return self;
}

@end
