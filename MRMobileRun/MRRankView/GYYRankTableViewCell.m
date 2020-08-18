//
//  GYYRankTableViewCell.m
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/8/12.
//

#import "GYYRankTableViewCell.h"
#import <Masonry.h>
#import "UIImageView+WebCache.h"  //SDWebImage头文件

@interface GYYRankTableViewCell()

@property (nonatomic, strong)UIImageView *rankIcon;
@property (nonatomic, strong)UILabel *rankLab;
@property (nonatomic, strong)UIImageView *headImg;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *signLab;
@property (nonatomic, strong)UILabel *distanceLab;

@end

@implementation GYYRankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self.contentView addSubview:self.rankIcon];
    [self.contentView addSubview:self.rankLab];
    [self.contentView addSubview:self.headImg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.signLab];
    [self.contentView addSubview:self.distanceLab];
    if (@available(iOS 13.0, *)) {
        UIColor *GYYColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return COLOR_WITH_HEX(0xFCFCFC);
            }
            else {
                return COLOR_WITH_HEX(0x3C3F43);
            }
        }];
        self.contentView.backgroundColor = GYYColor;
    } else {
        self.contentView.backgroundColor = COLOR_WITH_HEX(0xFCFCFC);
    }
    
    [self.rankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(-(screenWidth / 2 - 27));
    }];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(43);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_top).offset(4);
        make.left.equalTo(self.headImg.mas_right).offset(9);
    }];
    [self.signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(1);
        make.left.equalTo(self.headImg.mas_right).offset(9);
    }];
    [self.distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLab);
        make.right.mas_equalTo(-15);
    }];
}

- (void)setRankModel:(GYYRankModel *)rankModel{
    _rankModel = rankModel;
    
    // 对图片的网络请求进行封装，对请求的图片进行缓存，如果没有请求过，进行网络请求，如果请求过，从缓存取值。 url = @"http:xxxxxxx/xxxxx/xxx.png"   转换成哈希值，存在哈希结构里。
    NSURL *url = [NSURL URLWithString:_rankModel.AvatarUrl];  //把字符串 转化为 NSUrl
//    [_headImg sd_setImageWithURL:url];
    //plaeceholder 占位图
    [_headImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"logo头像"]];
    _nameLab.text = _rankModel.Nickname;
    _signLab.text = _rankModel.Signature;
    //@"%.6f"  OC 取几位小数 .后面放几
    //@"%03ld"

   
    NSString *targetStr = [NSString stringWithFormat:@"%@%@", _rankModel.DistanceValue, _rankModel.Unit];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:targetStr];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:[targetStr rangeOfString:_rankModel.DistanceValue]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:[targetStr rangeOfString:_rankModel.Unit]];
    _distanceLab.attributedText = attributedString;
    
    if ([_rankModel.Rank integerValue] <= 3) {
        _rankLab.hidden = YES;
        _rankIcon.hidden = NO;
        
        _rankIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@", _rankModel.Rank]];
    }else{
        _rankLab.hidden = NO;
        _rankIcon.hidden = YES;

        _rankLab.text = [NSString stringWithFormat:@"%@", _rankModel.Rank];  //
    }
     
}

- (UIImageView *)rankIcon{
    if (!_rankIcon) {
        _rankIcon = [[UIImageView alloc] init];
    }
    return _rankIcon;
}

- (UILabel *)rankLab{
    if (!_rankLab) {
        _rankLab = [[UILabel alloc] init];
        if (@available(iOS 13.0, *)) {
            UIColor *rankColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                    return COLOR_WITH_HEX(0x64686F);
                }
                else {
                    return COLOR_WITH_HEX(0xFFFFFF);
                }
            }];
            self->_rankLab.textColor = rankColor;
        } else {
            _rankLab.textColor = COLOR_WITH_HEX(0x64686F);
            // Fallback on earlier versions
        }
        _rankLab.font = [UIFont systemFontOfSize:16];
    }
    return _rankLab;
}

- (UIImageView *)headImg{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 25;
    }
    return _headImg;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        if (@available(iOS 13.0, *)) {
            UIColor *rankColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                    return COLOR_WITH_HEX(0x333739);
                }
                else {
                    return COLOR_WITH_HEX(0xFFFFFF);
                }
            }];
            self->_nameLab.textColor = rankColor;
        } else {
            _nameLab.textColor = COLOR_WITH_HEX(0x333739);
            // Fallback on earlier versions
        }
        _nameLab.font = [UIFont systemFontOfSize:15];
    }
    return _nameLab;
}

- (UILabel *)signLab{
    if (!_signLab) {
        _signLab = [[UILabel alloc] init];
        _signLab.textColor = COLOR_WITH_HEX(0xA0A0A0);
        _signLab.font = [UIFont systemFontOfSize:11];
        _signLab.numberOfLines = 1;
    }
    return _signLab;
}

- (UILabel *)distanceLab{
    if (!_distanceLab) {
        _distanceLab = [[UILabel alloc] init];
        if (@available(iOS 13.0, *)) {
            UIColor *rankColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                    return COLOR_WITH_HEX(0x333739);
                }
                else {
                    return COLOR_WITH_HEX(0xA0A0A0);
                }
            }];
            self->_distanceLab.textColor = rankColor;
        } else {
            _distanceLab.textColor = COLOR_WITH_HEX(0x333739);
            // Fallback on earlier versions
        }
    }
    return _distanceLab;
}

/*
 
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
