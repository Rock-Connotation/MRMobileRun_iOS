//
//  LJJInviteCancel.m
//  MRMobileRun
//
//  Created by J J on 2019/7/17.
//

#import "LJJInviteCancel.h"
#import "MRLoginViewController.h"
@implementation LJJInviteCancel

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.nameNextVC([MRLoginViewController findCurrentViewController]);
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.nameNextVC();
}

-(void)useBlockNameBlock:(VCMiss)nameNextVC
{
    self.nameNextVC = nameNextVC;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
