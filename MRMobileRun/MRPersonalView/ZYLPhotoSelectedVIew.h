//
//  ZYLPhotoSelectedVIew.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLPhotoSelectedVIew : UIView <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
+ (instancetype)selectViewWithDestinationImageView:(UIImageView *)imageView delegate:(UIViewController *)delegate;

@end

NS_ASSUME_NONNULL_END
