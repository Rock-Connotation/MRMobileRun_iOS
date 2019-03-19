//
//  UIButton+TabBarBtu.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/11/26.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "UIButton+TabBarBtu.h"
#import "MRHomePageTabBar.h"
@implementation UIButton (TabBarBtu)
- (void)changeBtuStyle:(MRHomePageTabBar *)tabBar andBtuAry:(NSArray *)btuAry{
    int num = 0;
    UIButton *btu = [[UIButton alloc]init];
    for (btu in btuAry) {
        if (btu.selected == YES) {
            break;
        }
        num++;
    }
    switch (num) {
        case 0:
            
            break;
            
        default:
            break;
    }
}
@end
