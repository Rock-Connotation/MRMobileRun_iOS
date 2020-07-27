//
//  MAMutablePolylineRenderer.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/25.
//

#import "MAMutablePolylineRenderer.h"
#import "MapPolylineModel.h"
@implementation MAMutablePolylineRenderer
- (void)creatPath{
    CGMutablePathRef path = CGPathCreateMutable();
    MapPolylineModel *overlay = self.overlay;
    if (overlay.pointArray.count > 0) {
        CGPoint point = [self glPointForMapPoint:[overlay mapPointForPointAt:0]];
        CGPathMoveToPoint(path, nil, point.x,point.y);
    }
    for (int i = 1; i < overlay.pointArray.count; i++)
       {
           CGPoint point = [self glPointForMapPoint:[overlay mapPointForPointAt:i]];
           CGPathAddLineToPoint(path, nil, point.x, point.y);
       }
       
}
- (void)fillPath:(CGPathRef)path inContext:(CGContextRef)context
{
    return;
}



@end
