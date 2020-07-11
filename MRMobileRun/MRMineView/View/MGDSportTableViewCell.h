//
//  MGDSportTableViewCell.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDSportTableViewCell : UITableViewCell 

@property (nonatomic,strong) UILabel *dayLab;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) UILabel *kmLab;

@property (nonatomic,strong) UILabel *kmUnit;

@property (nonatomic,strong) UILabel *minLab;

@property (nonatomic,strong) UILabel *minUnit;

@property (nonatomic,strong) UILabel *calLab;

@property (nonatomic,strong) UILabel *calUnit;

@property (nonatomic,strong) UIView *cellView;

@property (nonatomic,strong) UIImageView *arrowView;

@end

NS_ASSUME_NONNULL_END
