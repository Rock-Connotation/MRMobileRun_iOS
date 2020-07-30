//
//  MGDDataView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/27.
//

#import "MGDDataView.h"
#import <Masonry.h>
#define DOTCOLOR [UIColor colorWithRed:123/255.0 green:183/255.0 blue:196/255.0 alpha:1.0]
#define DESCCOLOR  [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0]

@implementation MGDDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //整体View
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backView];
        
        //速度View
        _speedBackView = [[UIView alloc] init];
        _speedBackView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:_speedBackView];
        
        //速度View上的控件
        _speedDotView = [[UIView alloc] init];
        _speedDotView.backgroundColor = DOTCOLOR;
        _speedDotView.layer.masksToBounds = YES;
        _speedDotView.layer.cornerRadius = 4.0;
        [self.speedBackView addSubview:_speedDotView];
        
        _speed = [[UILabel alloc] init];
        _speed.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        _speed.textAlignment = NSTextAlignmentLeft;
        _speed.text = @"速度";
        [self.speedBackView addSubview:_speed];
        
        _speedLab = [[UILabel alloc] init];
        _speedLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 28];
        _speedLab.textAlignment = NSTextAlignmentCenter;
        [self.speedBackView addSubview:_speedLab];
        
        _descSpeed = [[UILabel alloc] init];
        _descSpeed.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
        _descSpeed.textAlignment = NSTextAlignmentCenter;
        _descSpeed.tintColor = DESCCOLOR;
        _descSpeed.text = @"最快速度";
        [self.speedBackView addSubview:_descSpeed];
        
        //步频View
        _paceBackView = [[UIView alloc] init];
        _paceBackView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:_paceBackView];
        
        //步频View上的控件
        _paceDotView = [[UIView alloc] init];
        _paceDotView.backgroundColor = DOTCOLOR;
        _paceDotView.layer.masksToBounds = YES;
        _paceDotView.layer.cornerRadius = 4.0;
        [self.paceBackView addSubview:_paceDotView];
        
        _pace = [[UILabel alloc] init];
        _pace.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        _pace.textAlignment = NSTextAlignmentLeft;
        _pace.text = @"步频";
        [self.paceBackView addSubview:_pace];
        
        _paceLab = [[UILabel alloc] init];
        _paceLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 28];
        _paceLab.textAlignment = NSTextAlignmentCenter;
        [self.paceBackView addSubview:_paceLab];
        
        _descPace = [[UILabel alloc] init];
        _descPace.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
        _descPace.textAlignment = NSTextAlignmentCenter;
        _descPace.text = @"最高步频";
        _descPace.tintColor = DESCCOLOR;
        [self.paceBackView addSubview:_descPace];
        
        //颜色适配
        if (@available(iOS 11.0, *)) {
            self.speedLab.tintColor = bottomTitleColor;
            self.paceLab.tintColor = bottomTitleColor;
            self.pace.tintColor = bottomTitleColor;
            self.speed.tintColor = bottomTitleColor;
        } else {
                   // Fallback on earlier versions
        }
        
        [self test];
        
    }
    return self;
}

//位置约束
- (void)layoutSubviews {
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.equalTo(@699);
    }];
    
    
    [_paceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.equalTo(@308);
    }];
    
    
    [_speedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.paceBackView.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.equalTo(@308);
    }];
    
    [_speedDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speedBackView.mas_top).mas_offset(7);
        make.left.mas_equalTo(self.speedBackView.mas_left).mas_offset(15);
        make.width.equalTo(@8);
        make.height.equalTo(@8);
    }];
    
    [_speed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speedBackView.mas_top);
        make.left.mas_equalTo(self.speedBackView.mas_left).mas_offset(29);
        make.width.equalTo(@32);
        make.height.equalTo(@22);
    }];
    
    [_speedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speed.mas_bottom);
        make.left.mas_equalTo(self.speed.mas_right).mas_offset(82);
        make.width.equalTo(@90);
        make.height.equalTo(@34);
    }];
    
    [_descSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speedLab.mas_bottom);
        make.left.mas_equalTo(self.speedBackView.mas_left).mas_offset(166);
        make.width.equalTo(@44);
        make.height.equalTo(@16);
    }];
    
    
    
    [_paceDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.paceBackView.mas_top).mas_offset(7);
        make.left.mas_equalTo(self.paceBackView.mas_left).mas_offset(15);
        make.width.equalTo(@8);
        make.height.equalTo(@8);
    }];
    
    [_pace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.paceBackView.mas_top);
        make.left.mas_equalTo(self.paceBackView.mas_left).mas_offset(29);
        make.width.equalTo(@32);
        make.height.equalTo(@22);
    }];
    
    [_paceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pace.mas_bottom);
        make.left.mas_equalTo(self.pace.mas_right).mas_offset(82);
        make.width.equalTo(@90);
        make.height.equalTo(@34);
    }];
    
    [_descPace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.paceLab.mas_bottom);
        make.left.mas_equalTo(self.paceBackView.mas_left).mas_offset(166);
        make.width.equalTo(@44);
        make.height.equalTo(@16);
    }];

}

- (void)test {
    _paceLab.text = @"193";
    _speedLab.text = @"5.42";
}

@end
