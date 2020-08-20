//
//  MGDBaseInfoView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/9.
//

#import "MGDBaseInfoView.h"
#import <Masonry.h>

#define NUMBERTEXTCOLOR [UIColor colorWithRed:65/255.0 green:68/255.0 blue:72/255.0 alpha:1.0]
#define UNITTEXTCOLOR [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0]

@implementation MGDBaseInfoView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *backView = [[UIView alloc] init];
        self.backView = backView;
        self.backView.backgroundColor = [UIColor clearColor];
        [self addSubview:backView];
        
        UIImageView *KmImage = [[UIImageView alloc] init];
        self.KmImage = KmImage;
        [self.backView addSubview:KmImage];
        _KmImage.image = [UIImage imageNamed:@"homepage_kilometer"];
        _KmImage.contentMode =  UIViewContentModeScaleAspectFit;
        
        UIImageView *MinImage = [[UIImageView alloc] init];
        self.MinImage = MinImage;
        [self.backView addSubview:MinImage];
        _MinImage.image = [UIImage imageNamed:@"homepage_time"];
        _MinImage.contentMode =  UIViewContentModeScaleAspectFit;
        
        UIImageView *CalImage = [[UIImageView alloc] init];
        self.calImage = CalImage;
        [self.backView addSubview:CalImage];
        //测试用数据
        _calImage.image = [UIImage imageNamed:@"homepage_consume"];
        _calImage.contentMode =  UIViewContentModeScaleAspectFit;
        
        UILabel *KmLab = [[UILabel alloc] init];
        self.Kmlab = KmLab;
        [self.backView addSubview:KmLab];
        _Kmlab.textAlignment = NSTextAlignmentCenter;
        _Kmlab.numberOfLines = 0;
        //字体不同，需要修改
        _Kmlab.font =  [UIFont fontWithName:@"Impact" size: 24];
        
        UILabel *MinLab = [[UILabel alloc] init];
        self.MinLab = MinLab;
        [self.backView addSubview:MinLab];
        _MinLab.textAlignment = NSTextAlignmentCenter;
        _MinLab.numberOfLines = 0;
        //字体不同，需要修改
        _MinLab.font =  [UIFont fontWithName:@"Impact" size: 24];
        
        UILabel *CalLab = [[UILabel alloc] init];
        self.CalLab = CalLab;
        [self addSubview:CalLab];
        _CalLab.textAlignment = NSTextAlignmentCenter;
        _CalLab.numberOfLines = 0;
        //字体不同，需要修改
        _CalLab.font =  [UIFont fontWithName:@"Impact" size: 24];
        
        UILabel *kilometre = [[UILabel alloc] init];
        self.kilometre = kilometre;
        [self.backView addSubview:kilometre];
        _kilometre.text = @"公里";
        _kilometre.textAlignment = NSTextAlignmentCenter;
        _kilometre.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _kilometre.numberOfLines = 0;
        _kilometre.textColor = UNITTEXTCOLOR;
        
        UILabel *minus = [[UILabel alloc] init];
        self.minus = minus;
        [self.backView addSubview:minus];
        _minus.text = @"分";
        _minus.textAlignment = NSTextAlignmentCenter;
        _minus.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _minus.numberOfLines = 0;
        _minus.textColor = UNITTEXTCOLOR;
        
        UILabel *calories = [[UILabel alloc] init];
        self.calories = calories;
        [self.backView addSubview:calories];
        _calories.text = @"千卡";
        _calories.textAlignment = NSTextAlignmentCenter;
        _calories.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _calories.numberOfLines = 0;
        _calories.textColor = UNITTEXTCOLOR;
        
        
        if (@available(iOS 11.0, *)) {
            self.Kmlab.textColor = MGDTextColor1;
            self.MinLab.textColor = MGDTextColor1;
            self.CalLab.textColor = MGDTextColor1;
           } else {
               // Fallback on earlier versions
        }
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(screenHeigth * 0.1441);
        make.width.mas_equalTo(screenWidth);
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
    }];
        
    [_KmImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(55);
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(16);
    }];
        
    [_Kmlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.width.equalTo(@90);
        make.top.lessThanOrEqualTo(self.backView.mas_top).mas_offset(49);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(29);
    }];
    
    [_kilometre mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.width.equalTo(@36);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(57);
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(76);
    }];

    [_MinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(167);
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(16);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-168);
    }];
        
    [_MinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(143);
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(49);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-142);
    }];
    
    [_minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(170);
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(76);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-169);
    }];
    
    [_calImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-56);
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(16);
    }];
        
    [_CalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.width.equalTo(@90);
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(49);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-31);
    }];

    [_calories mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.width.equalTo(@36);
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(76);
        make.right.mas_equalTo(self.backView.mas_right).mas_offset(-58);
    }];
        
}

@end
