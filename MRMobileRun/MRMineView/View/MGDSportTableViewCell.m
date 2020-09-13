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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)BuildUI {
    UILabel *dayLab = [[UILabel alloc] init];
    self.dayLab = dayLab;
    [self.contentView addSubview:dayLab];
    _dayLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
    _dayLab.textAlignment = NSTextAlignmentRight;
    
    UILabel *timeLab = [[UILabel alloc] init];
    self.timeLab = timeLab;
    [self.contentView addSubview:timeLab];
    _timeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 10];
    _timeLab.textColor = UNITCOLOR;
    _timeLab.textAlignment = NSTextAlignmentRight;
    
    UIView *cellView = [[UIView alloc] init];
    self.cellView = cellView;
    self.cellView.layer.cornerRadius = 12.0;
    self.cellView.layer.shadowColor = [UIColor colorWithRed:136/255.0 green:154/255.0 blue:181/255.0 alpha:0.05].CGColor;
    self.cellView.layer.shadowOffset = CGSizeMake(0,3);
    self.cellView.layer.shadowOpacity = 1;
    self.cellView.layer.shadowRadius = 6;
    [self.contentView addSubview:cellView];
    
    UILabel *kmLab = [[UILabel alloc] init];
    self.kmLab = kmLab;
    [self.cellView addSubview:kmLab];
    _kmLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
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
    
    if (@available(iOS 11.0, *)) {
        self.contentView.backgroundColor = MGDColor3;
        self.dayLab.textColor = MGDTextColor1;
        self.cellView.backgroundColor = MGDColor1;
        self.kmLab.textColor = MGDTextColor1;
        self.minLab.textColor = MGDTextColor1;
        self.calLab.textColor = MGDTextColor1;
       } else {
           // Fallback on earlier versions
    }
}

- (void)setFrame {
        [_dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.right.mas_equalTo(self.cellView.mas_left).mas_offset(-screenWidth * 0.0293);
            make.left.mas_equalTo(self.mas_left).mas_offset(screenWidth * 0.022);
            make.height.mas_equalTo(screenHeigth * 0.036);
        }];
        
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dayLab.mas_bottom).mas_offset(-1);
            make.right.mas_equalTo(self.dayLab);
            make.left.mas_equalTo(self.mas_left).mas_offset(screenWidth * 0.0773);
            make.height.equalTo(@14);
        }];
        
        [_cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(screenWidth * 0.2133);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(screenHeigth * 0.09);
        }];
    
        CGFloat w = screenWidth * 0.7867;
        CGFloat h = screenHeigth * 0.09;
        
        [_kmLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cellView.mas_top).mas_offset(h * 0.2167);
            make.left.mas_equalTo(self.cellView.mas_left).mas_offset(w * 0.0237);
            make.width.mas_equalTo(w * 0.2373);
            make.height.mas_equalTo(h * 0.3);
        }];
        
        [_kmUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cellView.mas_top).mas_offset(h * 0.5333);
            make.left.mas_equalTo(self.cellView.mas_left).mas_offset(w * 0.078);
            make.width.mas_equalTo(w * 0.122);
            make.height.mas_equalTo(h * 0.2333);
        }];
        
        [_minLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.kmLab);
            make.left.mas_equalTo(self.cellView.mas_left).mas_offset(w * 0.3356);
            make.width.mas_equalTo(self.kmLab);
            make.height.mas_equalTo(self.kmLab);
        }];
        
        [_minUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.kmUnit);
            make.left.mas_equalTo(self.cellView.mas_left).mas_offset(w * 0.3898);
            make.width.mas_equalTo(self.kmUnit);
            make.height.mas_equalTo(self.kmUnit);
        }];
        
        [_calLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.kmLab);
            make.left.mas_equalTo(self.cellView.mas_left).mas_offset(w * 0.6475);
            make.width.mas_equalTo(self.kmLab);
            make.height.mas_equalTo(self.kmLab);
        }];
        
        [_calUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.kmUnit);
            make.left.mas_equalTo(self.cellView.mas_left).mas_offset(w * 0.7051);
            make.width.mas_equalTo(self.kmUnit);
            make.height.mas_equalTo(self.kmUnit);
        }];
        
        [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cellView.mas_top).mas_offset(h * 0.3833);
            make.bottom.mas_equalTo(self.cellView.mas_bottom).mas_offset(-h * 0.3833);
            make.right.mas_equalTo(self.cellView.mas_right).mas_offset(-w * 0.0576);
            make.left.mas_equalTo(self.cellView.mas_left).mas_offset(w * 0.8949);
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
