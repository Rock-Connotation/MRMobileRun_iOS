//
//  RunMainBtn.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/24.
//

#import "RunMainBtn.h"
#import <Masonry.h>
@implementation RunMainBtn
- (void)initRunBtn{
    
        self.logoImg = [[UIImageView alloc] init];
        [self addSubview:self.logoImg];
        [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.descLbl = [[UILabel alloc] init];
        [self addSubview:self.descLbl];
        [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.logoImg);
            make.top.equalTo(self.logoImg.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(48, 17));
        }];
        self.descLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        self.descLbl.textAlignment = NSTextAlignmentCenter;

}


@end
