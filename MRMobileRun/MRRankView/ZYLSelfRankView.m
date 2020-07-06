
//
//  ZYLSelfRankView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/29.
//

#import "ZYLSelfRankView.h"
#import <Masonry.h>

@interface ZYLSelfRankView ()
@property (nonatomic, strong) UIImageView *rankImage;
@property (nonatomic, strong) UILabel *kmLab;
@property (nonatomic, strong) UILabel *rankChiLab;
@property (nonatomic, strong) UIView *bkg;
@end

@implementation ZYLSelfRankView

- (instancetype)init
{
    self = [super init];
    if (self) {
         self.bkg = [[UIView alloc] initWithFrame:CGRectMake(15, 0, screenWidth-30, 88)];
        self.bkg.backgroundColor = [UIColor whiteColor];
        self.bkg.layer.cornerRadius = self.bkg.bounds.size.height/2;
        self.bkg.layer.shadowColor = [UIColor colorWithRed:170/255.0 green:185/255.0 blue:192/255.0 alpha:0.1].CGColor;
        self.bkg.layer.shadowOffset = CGSizeMake(0,3);
        self.bkg.layer.shadowOpacity = 1;
        self.bkg.layer.shadowRadius = 6;
        [self addSubview: self.bkg];
               
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(24, 8, 72, 72)];
        self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
        self.avatar.layer.masksToBounds = YES;
        [self addSubview: self.avatar];
               
        self.nicknameLab = [[UILabel alloc] init];
        self.nicknameLab.textColor = COLOR_WITH_HEX(0x333739);
        self.nicknameLab.textAlignment = NSTextAlignmentLeft;
        self.nicknameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [self addSubview: self.nicknameLab];
               
               
        self.rangeLab = [[UILabel alloc] init];
        self.rangeLab.textColor = COLOR_WITH_HEX(0x333739);
        self.rangeLab.textAlignment = NSTextAlignmentLeft;
        self.rangeLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:26];
        [self addSubview: self.rangeLab];
               
        self.kmLab = [[UILabel alloc] init];
        self.kmLab.textColor = COLOR_WITH_HEX(0x333739);
        self.kmLab.textAlignment = NSTextAlignmentLeft;
        self.kmLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        self.kmLab.text = @"km";
        [self addSubview: self.kmLab];
               
               
               self.rankChiLab = [[UILabel alloc] init];
               self.rankChiLab.textColor = COLOR_WITH_HEX(0xB2B2B2);
               self.rankChiLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
               self.rankChiLab.textAlignment = NSTextAlignmentLeft;
               self.rankChiLab.text = @"排名";
               [self  addSubview: self.rankChiLab];
               
               [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.centerY.equalTo(self.mas_centerY);
                   make.left.equalTo(self.mas_left).mas_offset(24);
                   make.width.mas_equalTo(72);
                   make.height.mas_equalTo(72);
               }];
               
               [self.nicknameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.avatar.mas_top).mas_offset(16);
                   make.left.equalTo(self.avatar.mas_right).mas_offset(15);
                   make.width.mas_equalTo(127);
                   make.height.mas_equalTo(22);
               }];
               
               [self.rangeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.nicknameLab.mas_bottom);
                   make.left.equalTo(self.nicknameLab.mas_left);
                   make.width.mas_equalTo(70);
                   make.height.mas_equalTo(37);
               }];
               
               [self.kmLab mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.rangeLab.mas_top).mas_offset(9);
                   make.left.equalTo(self.rangeLab.mas_right);
                   make.width.mas_equalTo(40);
                   make.height.mas_equalTo(25);
               }];
               
               [self.rankChiLab mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.mas_top).mas_offset(53);
                   make.right.equalTo(self.mas_right).mas_offset(-38);
                   make.width.mas_equalTo(20);
                   make.height.mas_equalTo(14);
               }];
    }
    return self;
}

- (void)setRank:(NSInteger)rank{
    _rank = rank;
    self.rankLab = [[UILabel alloc] init];
    self.rankLab.text = [[NSNumber numberWithInteger:rank] stringValue];
    self.rankLab.textColor = COLOR_WITH_HEX(0xF06272);
    self.rankLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:25];
    [self addSubview: self.rankLab];
    [self.rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(26);
        make.right.equalTo(self.mas_right).mas_offset(-33);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(32);
    }];
}

@end
