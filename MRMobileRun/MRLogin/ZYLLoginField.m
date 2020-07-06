//
//  ZYLLoginField.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/13.
//

#import "ZYLLoginField.h"

@implementation ZYLLoginField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20];
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect{
    CGRect placeholderRect = CGRectMake(rect.origin.x+10, (rect.size.height- self.font.pointSize - 2)/2, rect.size.width, self.font.pointSize + 5);//设置距离
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.font, NSFontAttributeName, COLOR_WITH_HEX(0xB9BCBE), NSForegroundColorAttributeName, nil];
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];
}
@end
