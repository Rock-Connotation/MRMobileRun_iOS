//
//  MGDBaseInfoView.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDBaseInfoView : UIView

@property(nonatomic,strong) UIView *backView;

@property(nonatomic,strong) UIImageView *KmImage;

@property(nonatomic,strong) UILabel *Kmlab;

@property(nonatomic,strong) UILabel *kilometre;

@property(nonatomic,strong) UIImageView *MinImage;

@property(nonatomic,strong) UILabel *MinLab;

@property(nonatomic,strong) UILabel *minus;

@property(nonatomic,strong) UIImageView *calImage;

@property(nonatomic,strong) UILabel *CalLab;

@property(nonatomic,strong) UILabel *calories;

@end

NS_ASSUME_NONNULL_END
