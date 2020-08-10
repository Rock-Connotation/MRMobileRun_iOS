//
//  GYYHealthTableViewCell.m
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/7/9.
//

#import "GYYHealthTableViewCell.h"
#import <Masonry.h>

@interface GYYHealthTableViewCell()

@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UILabel *dataLab;
@property (nonatomic, strong)UIView *redBarView;
@property (nonatomic, strong)UILabel *redBarTitleLab;
@property (nonatomic, strong)UIView *grayBarView;
@property (nonatomic, strong)UILabel *grayBarTitleLab;
@property (nonatomic, strong)UILabel *yesterdaydataLab;


@end

@implementation GYYHealthTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone; //点击时没有阴影效果
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
    }
    return self;
}

//创建子视图
- (void)createSubviews{
    //先添加视图，再约束。防止崩溃
    //或者按顺序添加
    //一定要addSubview之后
    [self.contentView addSubview:self.iconView];  //如果不用self   不走getter方法
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.dataLab];
    [self.contentView addSubview:self.redBarView];
    [self.redBarView addSubview:self.redBarTitleLab];
    [self.contentView addSubview:self.grayBarView];
    [self.grayBarView addSubview:self.grayBarTitleLab];
    [self.grayBarView addSubview:self.yestodaydataLab];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-(screenWidth / 2 - 27.5));
        make.centerY.equalTo(self.titleLab);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(41);
    }];
    
    [self.dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(22);
    }];
    
    [self.redBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(0);
        make.bottom.mas_equalTo(-56);
    }];
    [self.redBarTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    
    [self.grayBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(0);
        make.bottom.mas_equalTo(-19);
    }];
    [self.grayBarTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    [self.yesterdaydataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setRunDataDic:(NSDictionary *)runDataDic{  //Setter
    _runDataDic = runDataDic;
    NSLog(@"++++%@", _runDataDic);
    
    _iconView.image = [UIImage imageNamed:_runDataDic[@"icon"]];
    _titleLab.text = _runDataDic[@"title"];
    
    NSString *countStr = _runDataDic[@"todayData"];
    NSString *unitStr = _runDataDic[@"unit"];
    NSString *targetStr = [countStr stringByAppendingString:unitStr];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:targetStr];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0x333739) range:[targetStr rangeOfString:countStr]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xA0A0A0) range:[targetStr rangeOfString:unitStr]];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:24] range:[targetStr rangeOfString:countStr]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:14] range:[targetStr rangeOfString:unitStr]];

    _dataLab.attributedText = attributedString;
    
    float todayCount = [_runDataDic[@"todayData"] floatValue];
    float yesterdayCount = [_runDataDic[@"yesterdayData"] floatValue];
    
    if (todayCount != 0 && yesterdayCount != 0) {
        if (todayCount > yesterdayCount) {
            [_redBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(screenWidth - 40);
            }];
            
            [_grayBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((yesterdayCount / todayCount) * (screenWidth - 40) > (screenWidth - 40) * 0.4 ? (yesterdayCount / todayCount) * (screenWidth - 40) : (screenWidth - 40) * 0.4);
            }];
        }else{
            [_grayBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(screenWidth - 40);
            }];
            
            [_redBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((todayCount / yesterdayCount) * (screenWidth - 40) > (screenWidth - 40) * 0.25 ? (todayCount / yesterdayCount) * (screenWidth - 40) : (screenWidth - 40) * 0.25);
            }];
        }
    }else{
        if (todayCount == 0) {
            [_redBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((screenWidth - 40) * 0.25);
            }];
        }else{
            [_redBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(screenWidth - 40);
            }];
        }
        
        if (yesterdayCount == 0) {
            [_grayBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((screenWidth - 40) * 0.4);
            }];
        }else{
            [_grayBarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(screenWidth - 40);
            }];
        }
    }
    
    _redBarTitleLab.text = _runDataDic[@"todayTitle"];
    _grayBarTitleLab.text = _runDataDic[@"yesterdayTitle"];
    
    
    NSString *yesCountStr = _runDataDic[@"yesterdayData"];
    NSString *yesTargetStr = [yesCountStr stringByAppendingString:unitStr];
    NSMutableAttributedString *yesAttributedString = [[NSMutableAttributedString alloc] initWithString:yesTargetStr];
    
    [yesAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:14] range:[yesTargetStr rangeOfString:yesCountStr]];
    [yesAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:10] range:[yesTargetStr rangeOfString:unitStr]];
    
    
    
    _yesterdaydataLab.attributedText = yesAttributedString;
}

#pragma mark ======== 懒加载 ========
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = COLOR_WITH_HEX(0x64686F);
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    }
    return _titleLab;
}

- (UILabel *)dataLab{
    if (!_dataLab) {
        _dataLab = [[UILabel alloc] init];
    }
    return _dataLab;
}

- (UIView *)redBarView{
    if (!_redBarView) {
        _redBarView = [[UIView alloc] init];
        _redBarView.backgroundColor = COLOR_WITH_HEX(0xFF5C77);
        _redBarView.layer.masksToBounds = YES;
        _redBarView.layer.cornerRadius = 6.0;
    }
    return _redBarView;
}

- (UILabel *)redBarTitleLab{ //Getter
    if (!_redBarTitleLab) {
        _redBarTitleLab = [[UILabel alloc] init];
        _redBarTitleLab.textColor = [UIColor whiteColor];
        _redBarTitleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _redBarTitleLab;
}

- (UIView *)grayBarView{
    if (!_grayBarView) {
        _grayBarView = [[UIView alloc] init];
        _grayBarView.backgroundColor = COLOR_WITH_HEX(0xE1E4E5);
        _grayBarView.layer.masksToBounds = YES;  //开启圆角
        _grayBarView.layer.cornerRadius = 6.0;   //圆角大小  半径
    }
    return _grayBarView;
}

- (UILabel *)grayBarTitleLab{ //Getter
    if (!_grayBarTitleLab) {
        _grayBarTitleLab = [[UILabel alloc] init];
        _grayBarTitleLab.textColor = COLOR_WITH_HEX(0xA0A0A0);
        _grayBarTitleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _grayBarTitleLab;
}

- (UILabel *)yestodaydataLab{
    if (!_yesterdaydataLab) {
        _yesterdaydataLab = [[UILabel alloc] init];
        _yesterdaydataLab.textColor = COLOR_WITH_HEX(0xA0A0A0);
    }
    return _yesterdaydataLab;
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
