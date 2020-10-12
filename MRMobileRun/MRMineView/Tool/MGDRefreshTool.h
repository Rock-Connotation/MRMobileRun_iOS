//
//  MGDRefreshTool.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/10/11.
//

#import <Foundation/Foundation.h>
#import <MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDRefreshTool : NSObject

+ (void)setUPHeader:(MJRefreshNormalHeader *)header AndFooter:(MJRefreshBackNormalFooter *)footer;
+ (void)setUPHeader:(MJRefreshNormalHeader *)header;
@end

NS_ASSUME_NONNULL_END
