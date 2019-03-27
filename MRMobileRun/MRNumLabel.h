//
//  MRNumLabel.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRNumLabel : UILabel

- (void)setFontWithSize:(float)size andFloatTitle:(double)title;
//这个是涉及到浮点数的时候使用

- (void)setFontWithSize:(float)size andIntTitle:(int)title;
//这个是涉及到整数的时候使用

@end
