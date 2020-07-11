//
//  MGDTopView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/9.
//

#import "MGDTopView.h"
#import <Masonry.h>

@implementation MGDTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *topView = [[UIView alloc] init];
        self.topView = topView;
        self.topView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
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
        _userName.textColor = [UIColor colorWithRed:51/255.0 green:55/255.0 blue:57/255.0 alpha:1.0];
        
        UILabel *personalSign = [[UILabel alloc] init];
        self.personalSign = personalSign;
        [self.topView addSubview:personalSign];
        _personalSign.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        _personalSign.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
        _personalSign.numberOfLines = 0;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-676);
        make.height.equalTo(@136);
        make.width.mas_equalTo(screenWidth);
    }];
    
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@72);
        make.width.equalTo(@72);
        make.right.mas_equalTo(self.userName.mas_left).mas_offset(-28);
        make.left.mas_equalTo(self.topView.mas_left).mas_offset(16);
        make.top.mas_equalTo(self.topView.mas_top).mas_offset(48);
        make.bottom.mas_equalTo(self.topView.mas_bottom).mas_offset(-16);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.width.equalTo(@127);
        make.right.mas_equalTo(self.topView.mas_right).mas_offset(-132);
        make.left.mas_equalTo(self.topView.mas_left).mas_offset(116);
        make.top.mas_equalTo(self.topView.mas_top).mas_offset(59);
        make.bottom.mas_equalTo(self.topView.mas_bottom).mas_offset(-52);
    }];
    
    [_personalSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.width.equalTo(@212);
        make.right.mas_equalTo(self.topView.mas_right).mas_offset(-47);
        make.left.mas_equalTo(self.topView.mas_left).mas_offset(116);
        make.top.mas_equalTo(self.topView.mas_top).mas_offset(84);
        make.bottom.mas_equalTo(self.topView.mas_bottom).mas_offset(-34);
    }];
    
    
    //测试头像
    _userIcon.image = [UIImage imageNamed:@"avatar"];
    
    //测试昵称
    _userName.text = @"你的寒王";
    
    //测试签名
    _personalSign.text = @"花花世界迷人眼,没有实力你别赛脸!";
}


- (void)setUser:(User *)user {
    _user = user;
    
}




@end
