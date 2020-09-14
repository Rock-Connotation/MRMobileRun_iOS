//
//  UIImage+SVGTool.h
//  SVGProject
//
//  Created by 栗子 on 2018/9/7.
//  Copyright © 2018年 http://www.cnblogs.com/Lrx-lizi/    https://github.com/lrxlizi/     https://blog.csdn.net/qq_33608748. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SVGTool)

/**
 @param name svg name  xxx.svg
 @param size image size
 @return svg image
 */
+(UIImage *)svgImgNamed:(NSString *)name size:(CGSize)size;


/**
 @param name svg name  -->xxx.svg
 @param size image size
 @param color image color
 @return svg image
 */
+ (UIImage *)svgImageNamed:(NSString *)name size:(CGSize)size imageColor:(UIColor *)color;

@end
