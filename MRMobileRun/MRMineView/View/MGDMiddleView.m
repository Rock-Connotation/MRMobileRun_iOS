//
//  MGDMiddleView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/10.
//

#import "MGDMiddleView.h"
#import <Masonry.h>

#define DOTCOLOR [UIColor colorWithRed:123/255.0 green:183/255.0 blue:196/255.0 alpha:1.0]
#define RECORDCOLOR [UIColor colorWithRed:65/255.0 green:68/255.0 blue:72/255.0 alpha:1.0]
#define BTNCOLOR [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0]

@implementation MGDMiddleView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *backView = [[UIView alloc] init];
        self.backView = backView;
        [self addSubview:backView];
        
        UIView *dotView = [[UIView alloc] init];
        self.dotView = dotView;
        _dotView.backgroundColor = DOTCOLOR;
        self.dotView.layer.masksToBounds = YES;
        self.dotView.layer.cornerRadius = 4.0;
        [self.backView addSubview:dotView];
        
        UILabel *recordLab = [[UILabel alloc] init];
        self.recordLab = recordLab;
        [self.backView addSubview:recordLab];
        
        //测试用
        _recordLab.text = @"运动记录";
        
        _recordLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        _recordLab.textAlignment = NSTextAlignmentLeft;
        if (@available(iOS 11.0, *)) {
               self.recordLab.textColor = MGDTextColor2;
           } else {
               // Fallback on earlier versions
        }
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.moreBtn = moreBtn;
        [self.backView addSubview:moreBtn];
        [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [self.moreBtn setTintColor:BTNCOLOR];
        self.moreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 12];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (kIs_iPhoneX) {
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(screenHeigth * 0.0271);
            make.width.mas_equalTo(screenWidth);
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
        }];
        
        [self setMiddleFrame];
    }else {
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(screenHeigth * 0.033);
            make.width.mas_equalTo(screenWidth);
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
        }];
        
        [self setMiddleFrame];
        
    }
}

- (void)setMiddleFrame {
    if (kIs_iPhoneX) {
        [_dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth * 0.0213);
            make.height.mas_equalTo(screenHeigth * 0.0099);
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(screenHeigth * 0.0099);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.04);
        }];
        
        [_recordLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.0827);
            make.width.mas_equalTo(screenWidth * 0.192);
            make.height.mas_equalTo(screenHeigth * 0.0271);
        }];
        
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.824);
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(screenHeigth * 0.0049);
            make.width.mas_equalTo(screenWidth * 0.136);
            make.height.mas_equalTo(screenHeigth * 0.029);
        }];
    }else {
        [_dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth * 0.0213);
            make.height.mas_equalTo(screenHeigth * 0.012);
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(screenHeigth * 0.012);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.04);
        }];
        
        [_recordLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.0827);
            make.width.mas_equalTo(screenWidth * 0.212);
            make.height.mas_equalTo(screenHeigth * 0.033);
        }];
        
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(screenWidth * 0.824);
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(screenHeigth * 0.006);
            make.width.mas_equalTo(screenWidth * 0.166);
            make.height.mas_equalTo(screenHeigth * 0.0255);
        }];
    }
}
@end
