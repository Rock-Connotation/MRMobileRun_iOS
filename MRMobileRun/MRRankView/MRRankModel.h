//
//  MRRankModel.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/26.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MRAvatarModel.h"

@interface MRRankModel : NSObject

- (void)inquireClassRankWithData:(int )page;
- (void)inquireRankWithPage:(int )page;
- (void)getClassInformation;

@end
