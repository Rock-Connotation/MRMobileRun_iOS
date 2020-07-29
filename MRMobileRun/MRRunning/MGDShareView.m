//
//  MGDShareView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/28.
//

#import "MGDShareView.h"
#import <Masonry.h>

@implementation MGDShareView

- (instancetype)initWithShotImage:(NSString *)shotImage logoImage:(NSString *)logo QRcodeImage:(NSString *)QRcode {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor greenColor];
        _backView.layer.shadowOpacity = 1;
        _backView.layer.shadowRadius = 6;
        [self addSubview:_backView];
        
        _shotImage = [[UIImageView alloc] init];
        _shotImage.backgroundColor = [UIColor blueColor];
        [self.backView addSubview:_shotImage];
        
        _logoImage = [[UIImageView alloc] init];
        _logoImage.backgroundColor = [UIColor lightGrayColor];
        _logoImage.layer.cornerRadius = 6;
        [self.backView addSubview:_logoImage];
        
        _QRImage = [[UIImageView alloc] init];
        _QRImage.backgroundColor = [UIColor lightGrayColor];
        _QRImage.layer.cornerRadius = 6;
        [self.backView addSubview:_QRImage];
        
        _shareLab = [[UILabel alloc] init];
        _shareLab.textAlignment = NSTextAlignmentLeft;
        _shareLab.numberOfLines = 0;
        _shareLab.text = @"长按识别二维码\n加入约跑和我一起跑步";
        [self.backView addSubview:_shareLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (kIs_iPhoneX) {
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(67);
            make.left.mas_equalTo(self.mas_left).mas_offset(15);
            make.right.mas_equalTo(self.mas_right).mas_offset(-15);
            make.height.equalTo(@566);
        }];
        
        [_shotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top);
            make.left.mas_equalTo(self.backView.mas_left);
            make.right.mas_equalTo(self.backView.mas_right);
            make.height.equalTo(@489);
        }];
        
        [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(11);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(12);
            make.height.equalTo(@54);
            make.width.equalTo(@54);
        }];
        
        [_QRImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(self.backView.mas_right).mas_offset(-15);
            make.width.equalTo(@54);
            make.height.equalTo(@54);
        }];
        
        [_shareLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(23);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(81);
            make.width.equalTo(@125);
            make.height.equalTo(@34);
        }];
        _shareLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        
    }else {
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(40);
            make.left.mas_equalTo(self.mas_left).mas_offset(41);
            make.right.mas_equalTo(self.mas_right).mas_offset(-42);
            make.height.equalTo(@486);
        }];
        
        [_shotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top);
            make.left.mas_equalTo(self.backView.mas_left);
            make.right.mas_equalTo(self.backView.mas_right);
            make.height.equalTo(@415);
        }];
        
        [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(9);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(10);
            make.height.equalTo(@46);
            make.width.equalTo(@46);
        }];
        
        [_QRImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(8);
            make.right.mas_equalTo(self.backView.mas_right).mas_offset(-12);
            make.width.equalTo(@46);
            make.height.equalTo(@46);
        }];
        
        [_shareLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(68);
            make.width.equalTo(@135);
            make.height.equalTo(@28);
        }];
        _shareLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 10];
    }
}

@end
