//
//  MGDShareView.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/28.
//

//这个View是跑完步后点击分享后弹出的View，是一个整体的大的透明的UIView，上面有一个占据部分的View，上方是一个大的UIImageView，用来展示截取的关于跑步信息的图片，下面是两个小的UIImageView和一个Label，两个小的UIImageView自己看逻辑来获取，最下面是取消按钮和一个放置五个按钮的view，按钮的具体逻辑自己实现就行了
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
