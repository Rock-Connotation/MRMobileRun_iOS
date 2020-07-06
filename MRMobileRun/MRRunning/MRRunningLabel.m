
//
//  MRRunningLabel.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/27.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRRunningLabel.h"

@implementation MRRunningLabel

- (instancetype)init{
    if (self = [super init]) {
        [self initRunningTimeLabel];
        return self;
    }
    return self;
}


- (void)initRunningTimeLabel{
    self.text = @"00:00:00";
    self.font = [UIFont fontWithName:@"DINAlternate-Bold" size:32 *screenWidth/414.0];
    
}
@end
