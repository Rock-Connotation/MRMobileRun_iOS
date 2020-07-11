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
        backView.backgroundColor = [UIColor clearColor];
        [self addSubview:backView];
        
        UIImageView *KmImage = [[UIImageView alloc] init];
        self.KmImage = KmImage;
        [self.backView addSubview:KmImage];
        //测试用数据
        _KmImage.image = [UIImage imageNamed:@"homepage_kilometer"];
        _KmImage.contentMode =  UIViewContentModeScaleAspectFit;
        
        UIImageView *MinImage = [[UIImageView alloc] init];
        self.MinImage = MinImage;
        [self.backView addSubview:MinImage];
        //测试用数据
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
        
        //测试用数据
        _Kmlab.text = @"285";
        
        _Kmlab.textAlignment = NSTextAlignmentCenter;
        _Kmlab.numberOfLines = 0;
        //字体不同，需要修改
        _Kmlab.font =  [UIFont fontWithName:@"PingFangSC-Medium" size: 24];
        _Kmlab.textColor = NUMBERTEXTCOLOR;
        
        UILabel *MinLab = [[UILabel alloc] init];
        self.MinLab = MinLab;
        [self.backView addSubview:MinLab];
        //测试用数据
        _MinLab.text = @"1083";
               
        _MinLab.textAlignment = NSTextAlignmentCenter;
        _MinLab.numberOfLines = 0;
        //字体不同，需要修改
        _MinLab.font =  [UIFont fontWithName:@"PingFangSC-Medium" size: 24];
        _MinLab.textColor = NUMBERTEXTCOLOR;
        
        UILabel *CalLab = [[UILabel alloc] init];
        self.CalLab = CalLab;
        [self addSubview:CalLab];
        //测试用数据
        _CalLab.text = @"28742";
               
        _CalLab.textAlignment = NSTextAlignmentCenter;
        _CalLab.numberOfLines = 0;
        //字体不同，需要修改
        _CalLab.font =  [UIFont fontWithName:@"PingFangSC-Medium" size: 24];
        _CalLab.textColor = NUMBERTEXTCOLOR;
        
        UILabel *kilometre = [[UILabel alloc] init];
        self.kilometre = kilometre;
        [self.backView addSubview:kilometre];
        
        //测试用数据
        _kilometre.text = @"公里";
        
        _kilometre.textAlignment = NSTextAlignmentCenter;
        _kilometre.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _kilometre.numberOfLines = 0;
        _kilometre.textColor = UNITTEXTCOLOR;
        
        UILabel *minus = [[UILabel alloc] init];
        self.minus = minus;
        [self.backView addSubview:minus];
        
        //测试用数据
        _minus.text = @"公里";
        
        _minus.textAlignment = NSTextAlignmentCenter;
        _minus.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _minus.numberOfLines = 0;
        _minus.textColor = UNITTEXTCOLOR;
        
        UILabel *calories = [[UILabel alloc] init];
        self.calories = calories;
        [self.backView addSubview:calories];
        
        //测试用数据
        _calories.text = @"公里";
               
        _calories.textAlignment = NSTextAlignmentCenter;
        _calories.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _calories.numberOfLines = 0;
        _calories.textColor = UNITTEXTCOLOR;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@117);
        make.width.mas_equalTo(screenWidth);
        make.top.mas_equalTo(self.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(-573);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    [_KmImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.right.equalTo(self.backView.mas_right).mas_offset(-280);
        make.left.equalTo(self.backView.mas_left).mas_offset(55);
        make.top.equalTo(self.backView.mas_top).mas_offset(16);
        make.bottom.equalTo(self.backView.mas_bottom).mas_offset(-61);
    }];
    
    [_Kmlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.width.equalTo(@90);
        make.right.equalTo(self.backView.mas_right).mas_offset(-256);
        make.left.equalTo(self.backView.mas_left).mas_offset(29);
        make.top.equalTo(self.backView.mas_top).mas_offset(49);
        make.bottom.equalTo(self.backView.mas_bottom).mas_offset(-40);
    }];

    [_kilometre mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.equalTo(@18);
         make.width.equalTo(@36);
         make.right.equalTo(self.backView.mas_right).mas_offset(-282);
         make.left.equalTo(self.backView.mas_left).mas_offset(57);
         make.top.equalTo(self.backView.mas_top).mas_offset(76);
         make.bottom.equalTo(self.backView.mas_bottom).mas_offset(-23);
    }];

    [_MinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.right.equalTo(self.backView.mas_right).mas_offset(-168);
        make.left.equalTo(self.backView.mas_left).mas_offset(167);
        make.top.equalTo(self.backView.mas_top).mas_offset(16);
        make.bottom.equalTo(self.backView.mas_bottom).mas_offset(-61);
    }];
    
    [_MinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.width.equalTo(@90);
        make.right.equalTo(self.backView.mas_right).mas_offset(-142);
        make.left.equalTo(self.backView.mas_left).mas_offset(143);
        make.top.equalTo(self.backView.mas_top).mas_offset(49);
        make.bottom.equalTo(self.backView.mas_bottom).mas_offset(-40);
    }];
    
    [_minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.width.equalTo(@36);
        make.right.equalTo(self.backView.mas_right).mas_offset(-169);
        make.left.equalTo(self.backView.mas_left).mas_offset(170);
        make.top.equalTo(self.backView.mas_top).mas_offset(76);
        make.bottom.equalTo(self.backView.mas_bottom).mas_offset(-23);
    }];
    
    [_calImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.right.equalTo(self.backView.mas_right).mas_offset(-56);
        make.left.equalTo(self.backView.mas_left).mas_offset(279);
        make.top.equalTo(self.backView.mas_top).mas_offset(16);
        make.bottom.equalTo(self.backView.mas_bottom).mas_offset(-61);
    }];
    
    [_CalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.width.equalTo(@90);
        make.right.equalTo(self.backView.mas_right).mas_offset(-31);
        make.left.equalTo(self.backView.mas_left).mas_offset(254);
        make.top.equalTo(self.backView.mas_top).mas_offset(49);
        make.bottom.equalTo(self.backView.mas_bottom).mas_offset(-40);
    }];
    
    [_calories mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.width.equalTo(@36);
        make.right.equalTo(self.backView.mas_right).mas_offset(-58);
        make.left.equalTo(self.backView.mas_left).mas_offset(281);
        make.top.equalTo(self.backView.mas_top).mas_offset(76);
        make.bottom.equalTo(self.backView.mas_bottom).mas_offset(-23);
    }];
}

@end
