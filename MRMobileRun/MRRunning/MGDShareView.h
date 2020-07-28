//
//  MGDShareView.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDShareView : UIView

- (instancetype)initWithShotImage:(NSString *)shotImage logoImage:(NSString *)logo QRcodeImage:(NSString *)QRcode;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *shotImage;

@property (nonatomic, strong) UIImageView *logoImage;

@property (nonatomic, strong) UIImageView *QRImage;

@property (nonatomic, strong) UILabel *shareLab;


@end

NS_ASSUME_NONNULL_END
