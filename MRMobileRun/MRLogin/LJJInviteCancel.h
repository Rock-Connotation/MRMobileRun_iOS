//
//  LJJInviteCancel.h
//  MRMobileRun
//
//  Created by J J on 2019/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJJInviteCancel : UIView
typedef void(^VCMiss)(void);//参数的个数和类型自己定
@property(nonatomic,strong)VCMiss nameNextVC;
-(void)useBlockNameBlock:(VCMiss)nameNextVC;
@end

NS_ASSUME_NONNULL_END
