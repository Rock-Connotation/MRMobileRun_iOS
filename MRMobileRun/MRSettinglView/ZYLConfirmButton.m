//
//  ZYLConfirmButton.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/12/7.
//

#import "ZYLConfirmButton.h"

@implementation ZYLConfirmButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_WITH_HEX(0x64686F);
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    self.titleLabel.text = titleStr;
}
@end
