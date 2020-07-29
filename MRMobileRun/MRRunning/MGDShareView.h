//
//  MGDShareView.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MGDShareView;

@protocol MGDShareViewDelegate <NSObject>

- (NSArray *_Nullable)platformImageArray:(NSString *_Nullable)imageArray;

- (NSArray *_Nullable)platformTitleArray:(NSString *_Nullable)titleArray;

@end

@interface MGDShareView : UIView

- (instancetype)initWithShotImage:(NSString *)shotImage logoImage:(NSString *)logo QRcodeImage:(NSString *)QRcode;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *popView;

@property (nonatomic, strong) UIImageView *shotImage;

@property (nonatomic, strong) UIImageView *logoImage;

@property (nonatomic, strong) UIImageView *QRImage;

@property (nonatomic, strong) UILabel *shareLab;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIView *bottomView;


@end

NS_ASSUME_NONNULL_END
