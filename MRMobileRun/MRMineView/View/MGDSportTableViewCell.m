//
//  MGDSportTableViewCell.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/10.
//

#import "MGDSportTableViewCell.h"
#import <Masonry.h>

#define CELLCOLOR [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]
#define TEXTCOLOR [UIColor colorWithRed:51/255.0 green:55/255.0 blue:57/255.0 alpha:1.0]
#define UNITCOLOR [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0]

@implementation MGDSportTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self BuildUI];
        [self setFrame];
    }
    return self;
}

- (void)BuildUI {
    UILabel *dayLab = [[UILabel alloc] init];
    self.dayLab = dayLab;
    [self.contentView addSubview:dayLab];
    _dayLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
    _dayLab.textColor = TEXTCOLOR;
    _dayLab.textAlignment = NSTextAlignmentRight;
    
    UILabel *timeLab = [[UILabel alloc] init];
    self.timeLab = timeLab;
    [self.contentView addSubview:timeLab];
    _timeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 10];
    _timeLab.textColor = UNITCOLOR;
    _timeLab.textAlignment = NSTextAlignmentRight;
    
    UIView *cellView = [[UIView alloc] init];
    self.cellView = cellView;
    self.cellView.backgroundColor = CELLCOLOR;
    self.cellView.layer.cornerRadius = 12.0;
    [self.contentView addSubview:cellView];
    
    UILabel *kmLab = [[UILabel alloc] init];
    self.kmLab = kmLab;
    [self.cellView addSubview:kmLab];
    _kmLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    _kmLab.textColor = TEXTCOLOR;
    _kmLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *kmUnit = [[UILabel alloc] init];
    self.kmUnit = kmUnit;
    [self.cellView addSubview:kmUnit];
    _kmUnit.text = @"公里";
    _kmUnit.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    _kmUnit.textColor = UNITCOLOR;
    _kmUnit.textAlignment = NSTextAlignmentCenter;
    
    UILabel *minLab = [[UILabel alloc] init];
    self.minLab = minLab;
    [self.cellView addSubview:minLab];
    //测试用数据
    _minLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    _minLab.textColor = TEXTCOLOR;
    _minLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *minUnit = [[UILabel alloc] init];
    self.minUnit = minUnit;
    [self.cellView addSubview:minUnit];
    _minUnit.text = @"时间";
    _minUnit.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    _minUnit.textColor = UNITCOLOR;
    _minUnit.textAlignment = NSTextAlignmentCenter;
    
    UILabel *calLab = [[UILabel alloc] init];
    self.calLab = calLab;
    [self.cellView addSubview:calLab];
    _calLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    _calLab.textColor = TEXTCOLOR;
    _calLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *calUnit = [[UILabel alloc] init];
    self.calUnit = calUnit;
    [self.cellView addSubview:calUnit];
    _calUnit.text = @"千卡";
    _calUnit.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
    _calUnit.textColor = UNITCOLOR;
    _calUnit.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *arrowView = [[UIImageView alloc] init];
    self.arrowView = arrowView;
    [self.cellView addSubview:arrowView];
    self.arrowView.image = [UIImage imageNamed:@"arraw"];
}

- (void)setFrame {
    [_dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(17);
        make.right.mas_equalTo(self.cellView.mas_left).mas_offset(-11);
        make.height.equalTo(@24);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dayLab.mas_bottom).mas_offset(-1);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(44);
        make.width.equalTo(@25);
        make.height.equalTo(@14);
    }];
    
    [_cellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(80);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.equalTo(@60);
    }];
    
    [_kmLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView.mas_top).mas_offset(13);
        make.left.mas_equalTo(self.cellView.mas_left).mas_offset(7);
        make.width.equalTo(@70);
        make.height.equalTo(@18);
    }];
    
    [_kmUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView.mas_top).mas_offset(32);
        make.left.mas_equalTo(self.cellView.mas_left).mas_offset(23);
        make.width.equalTo(@36);
        make.height.equalTo(@14);
    }];
    
    [_minLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView.mas_top).mas_offset(13);
        make.left.mas_equalTo(self.cellView.mas_left).mas_offset(99);
        make.right.mas_equalTo(self.cellView.mas_right).mas_offset(-126);
        make.height.equalTo(@18);
    }];
    
    [_minUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView.mas_top).mas_offset(32);
        make.left.mas_equalTo(self.cellView.mas_left).mas_offset(115);
        make.right.mas_equalTo(self.cellView.mas_right).mas_offset(-144);
        make.height.equalTo(@14);
    }];
    
    [_calLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView.mas_top).mas_offset(13);
        make.right.mas_equalTo(self.cellView.mas_right).mas_offset(-34);
        make.width.equalTo(@70);
        make.height.equalTo(@18);
    }];
    
    [_calUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView.mas_top).mas_offset(32);
        make.right.mas_equalTo(self.cellView.mas_right).mas_offset(-51);
        make.width.equalTo(@36);
        make.height.equalTo(@14);
    }];
    
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView.mas_top).mas_offset(23);
        make.right.mas_equalTo(self.cellView.mas_right).mas_offset(-17);
        make.width.equalTo(@14.14);
        make.height.equalTo(@14.14);
    }];
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
