//
//  MGDTopView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/9.
//

#import "MGDTopView.h"
#import <Masonry.h>
#define BACGROUNDCOLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
#define SHAWDOWCOLOR [UIColor colorWithRed:136/255.0 green:154/255.0 blue:181/255.0 alpha:0.05]

@implementation MGDTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *topView = [[UIView alloc] init];
        self.topView = topView;
        if (@available(iOS 11.0, *)) {
            self.topView.backgroundColor = MGDColor1;
        } else {
            // Fallback on earlier versions
        }
        //self.topView.backgroundColor = BACGROUNDCOLOR;
        self.topView.layer.cornerRadius = 50;
        self.topView.layer.shadowColor = SHAWDOWCOLOR.CGColor;
        self.topView.layer.shadowOffset = CGSizeMake(0,3);
        self.topView.layer.shadowOpacity = 1;
        self.topView.layer.shadowRadius = 6;
        [self addSubview:topView];
        
        UIImageView *userIcon = [[UIImageView alloc] init];
        self.userIcon = userIcon;
        self.userIcon.layer.masksToBounds = YES;
        self.userIcon.layer.cornerRadius = 36.0;
        self.userIcon.contentMode = UIViewContentModeScaleToFill;
        [self.topView addSubview:userIcon];
        
        UILabel *username = [[UILabel alloc] init];
        self.userName = username;
        [self.topView addSubview:username];
        _userName.numberOfLines = 0;
        _userName.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
       // _userName.textColor = [UIColor colorWithRed:51/255.0 green:55/255.0 blue:57/255.0 alpha:1.0];
        if (@available(iOS 11.0, *)) {
            self.userName.textColor = MGDTextColor1;
        } else {
            // Fallback on earlier versions
        }
        
        UILabel *personalSign = [[UILabel alloc] init];
        self.personalSign = personalSign;
        [self.topView addSubview:personalSign];
        _personalSign.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        _personalSign.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
        _personalSign.numberOfLines = 0;
        
        [self test];
    }
    return self;
}

- (void)test {
    //测试用数据
    _userIcon.image = [UIImage imageNamed:@"avatar"];
    _userName.text = @"你的寒王";
    _personalSign.text = @"花花世界迷人眼，没有实力你别赛脸";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (kIs_iPhoneX) {
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top);
            make.height.equalTo(@136);
        }];
        
        [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@72);
            make.width.equalTo(@72);
            make.left.mas_equalTo(self.topView.mas_left).mas_offset(16);
            make.top.mas_equalTo(self.topView.mas_top).mas_offset(48);
        }];
        
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
            make.leading.lessThanOrEqualTo(self.topView.mas_leading).mas_offset(116);
            make.top.lessThanOrEqualTo(self.topView.mas_top).mas_offset(59);
            make.width.mas_lessThanOrEqualTo(screenWidth - 116);
        }];
        
        [_personalSign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
            make.leading.lessThanOrEqualTo(self.topView.mas_leading).mas_offset(116);
            make.width.mas_lessThanOrEqualTo(screenWidth - 116);
            make.top.lessThanOrEqualTo(self.topView.mas_top).mas_offset(84);
        }];
    }else {
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top);
            make.height.mas_equalTo(111);
        }];
        
        [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@72);
            make.width.equalTo(@72);
            make.left.mas_equalTo(self.topView.mas_left).mas_offset(16);
            make.top.mas_equalTo(self.topView.mas_top).mas_offset(23);
        }];
        
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
            make.leading.lessThanOrEqualTo(self.topView.mas_leading).mas_offset(116);
            make.top.lessThanOrEqualTo(self.topView.mas_top).mas_offset(34);
            make.width.mas_lessThanOrEqualTo(screenWidth - 116);
        }];
        
        [_personalSign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
            make.leading.lessThanOrEqualTo(self.topView.mas_leading).mas_offset(116);
            make.width.mas_lessThanOrEqualTo(screenWidth - 116);
            make.top.lessThanOrEqualTo(self.topView.mas_top).mas_offset(59);
        }];
    }
}

@end
