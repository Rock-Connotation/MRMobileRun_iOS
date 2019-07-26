//
//  LJJInviteOk.h
//  MRMobileRun
//
//  Created by J J on 2019/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJJInviteOk : UIView
typedef void(^voidBlock)(void);//参数的个数和类型自己定
@property(nonatomic,copy) voidBlock voidBlock;
-(void)useBlockNameBlock:(voidBlock)voidBlock;
@end

NS_ASSUME_NONNULL_END
