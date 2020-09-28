//
//  GYYRankHeaderMainView.m
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/8/14.
//

#import "GYYRankHeaderMainView.h"
#import "GYYRankModel.h"
#import <Masonry.h>
#import "UIImageView+WebCache.h"

@interface GYYRankHeaderMainView()

@property (nonatomic, strong)UIImageView *headImg;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *distanceLab;
@property (nonatomic, strong)UILabel *rankLab;


@end

@implementation GYYRankHeaderMainView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 49; //圆角
        
        self.layer.shadowColor = [COLOR_WITH_HEX(0xAAB9C0) colorWithAlphaComponent:0.1].CGColor;    //阴影的颜色
        self.layer.shadowOffset = CGSizeMake(0, 3);  //偏移量
        self.layer.shadowOpacity = 1;                //不透明度
        self.layer.shadowRadius = 6;                 //阴影半径  阴影
        
        //    self.clipsToBounds = YES; //default is NO;
        //    self.layer.masksToBounds = YES; //default is NO;
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews{
    [self addSubview:self.headImg];
    [self addSubview:self.rankLab];
    [self addSubview:self.nameLab];
    [self addSubview:self.distanceLab];
   
    if (@available(iOS 13.0, *)) {
        UIColor *GYYColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return COLOR_WITH_HEX(0xFFFFFF);
            }
            else {
                return COLOR_WITH_HEX(0x4A4D52);
            }
        }];
        self.backgroundColor = GYYColor;
    } else {
        self.backgroundColor = COLOR_WITH_HEX(0xFFFFFF);
    }
    UILabel *tipLab = [[UILabel alloc] init];
    [self addSubview:tipLab];
    tipLab.text = @"排名";
    tipLab.textColor = COLOR_WITH_HEX(0xB2B2B2);
    tipLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rankLab);
        make.bottom.mas_equalTo(-21);
    }];
    
    
    [self.rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-33);
        make.top.mas_equalTo(21);
    }];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(9);
        make.size.mas_equalTo(CGSizeMake(72, 72));
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_top).offset(8);
        make.left.equalTo(self.headImg.mas_right).offset(15);
    }];
    [self.distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab);
        make.bottom.mas_equalTo(-13);
    }];
}

- (void)setRankModel:(GYYRankModel *)rankModel{
    _rankModel = rankModel;
    
    // 对图片的网络请求进行封装，对请求的图片进行缓存，如果没有请求过，进行网络请求，如果请求过，从缓存取值。 url = @"http:xxxxxxx/xxxxx/xxx.png"   转换成哈希值，存在哈希结构里。
    NSURL *url = [NSURL URLWithString:_rankModel.AvatarUrl];  //把字符串 转化为 NSUrl
    NSLog(@"GYY%@",_rankModel.AvatarUrl);
    [_headImg sd_setImageWithURL:url];
    //plaeceholder 占位图
    //[_headImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"logo头像"]];
    _nameLab.text = _rankModel.Nickname;
    
    NSString *unit;
    if (!_rankModel.Unit) {
        unit = @"km";
    }else{
        unit = _rankModel.Unit;
    }
    NSString *targetStr = [NSString stringWithFormat:@"%@%@", _rankModel.DistanceValue, unit];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:targetStr];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:26] range:[targetStr rangeOfString:_rankModel.DistanceValue]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] range:[targetStr rangeOfString:unit]];
    _distanceLab.attributedText = attributedString;
    _rankLab.text = [NSString stringWithFormat:@"%@", _rankModel.Rank];
}

- (UILabel *)rankLab{
    if (!_rankLab) {
        _rankLab = [[UILabel alloc] init];
        _rankLab.textColor = COLOR_WITH_HEX(0xF06272);
        _rankLab.font =[UIFont fontWithName:@"PingFangSC-Medium" size:25];
    }
    return _rankLab;
}

- (UIImageView *)headImg{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 36;
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
        _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _nameLab;
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
                    return COLOR_WITH_HEX(0xFFFFFF);
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
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
