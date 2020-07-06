//
// Created by RainyTunes on 11/22/15.
// Copyright (c) 2015 We.Can. All rights reserved.
//

#import "UILabel+We.h"


@implementation UILabel (We)
- (void)setFontSize:(CGFloat)fontSize{
    [self setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]];
}
@end