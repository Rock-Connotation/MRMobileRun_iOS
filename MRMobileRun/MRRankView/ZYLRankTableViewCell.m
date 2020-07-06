//
//  ZYLRankTableViewCell.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/27.
//

#import "ZYLRankTableViewCell.h"
#import <Masonry.h>

@interface ZYLRankTableViewCell ()
@property (nonatomic, strong) UIImageView *rankImage;
@property (nonatomic, strong) UILabel *rankLab;
@property (nonatomic, strong) UILabel *kmLab;
@end


@implementation ZYLRankTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar = [[UIImageView alloc] init];
        self.avatar.layer.cornerRadius = 50/2;
        self.avatar.layer.masksToBounds = YES;
        [self.contentView addSubview: self.avatar];
        
        self.nicknameLab = [[UILabel alloc] init];
        self.nicknameLab.textColor = COLOR_WITH_HEX(0x333739);
        self.nicknameLab.textAlignment = NSTextAlignmentLeft;
        self.nicknameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [self.contentView addSubview: self.nicknameLab];
        
        self.signLab = [[UILabel alloc] init];
        self.signLab.textColor = COLOR_WITH_HEX(0xA0A0A0);
        self.signLab.textAlignment = NSTextAlignmentLeft;
        self.signLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        [self.contentView addSubview: self.signLab];
        
        self.rangeLab = [[UILabel alloc] init];
        self.rangeLab.textColor = COLOR_WITH_HEX(0x333739);
        self.rangeLab.textAlignment = NSTextAlignmentRight;
        self.rangeLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        [self.contentView addSubview: self.rangeLab];
        
        self.kmLab = [[UILabel alloc] init];
        self.kmLab.textColor = COLOR_WITH_HEX(0x333739);
        self.kmLab.textAlignment = NSTextAlignmentLeft;
        self.kmLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        self.kmLab.text = @"km";
        [self.contentView addSubview: self.kmLab];
        
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).mas_offset(43);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        
        [self.nicknameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatar.mas_top).mas_offset(4);
            make.left.equalTo(self.avatar.mas_right).mas_offset(9);
            make.width.mas_equalTo(127);
            make.height.mas_equalTo(21);
        }];
        
        [self.signLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nicknameLab.mas_bottom);
            make.left.equalTo(self.nicknameLab.mas_left);
            make.width.mas_equalTo(228);
            make.height.mas_equalTo(16);
        }];
        
        [self.rangeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatar.mas_top);
            make.right.equalTo(self.contentView.mas_right).mas_offset(-43);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(24);
        }];
        
        [self.kmLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.rangeLab.mas_bottom);
            make.left.equalTo(self.rangeLab.mas_right).mas_offset(5);
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(17);
        }];
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView;
{
    NSString *Identifier = @"status";
    ZYLRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[ZYLRankTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    return (ZYLRankTableViewCell *)cell;
}

- (void)setRank:(NSInteger)rank{
    _rank = rank;
    if (rank < 3) {
        self.rankImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"rank_%ld",rank+1]]];
        [self.contentView addSubview: self.rankImage];
        [self.rankImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).mas_offset(15);
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(24);
        }];
    }else{
        self.rankLab = [[UILabel alloc] init];
        self.rankLab.text = [[NSNumber numberWithInteger:rank+1] stringValue];
        self.rankLab.textColor = COLOR_WITH_HEX(0x64686F);
        self.rankLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [self.contentView addSubview: self.rankLab];
        [self.rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).mas_offset(15);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(22);
        }];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
