//
//  ZYLSelfRankView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLSelfRankView : UIView
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nicknameLab;
@property (nonatomic, strong) UILabel *rangeLab;
@property (nonatomic, strong) UILabel *rankLab;
@property (nonatomic, assign) NSInteger rank;
@end

NS_ASSUME_NONNULL_END
