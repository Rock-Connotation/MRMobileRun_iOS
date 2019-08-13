//
//  LJJInviteViewModel.h
//  MRMobileRun
//
//  Created by J J on 2019/4/3.
//

#import <Foundation/Foundation.h>
#import "LJJSearchedView.h"
NS_ASSUME_NONNULL_BEGIN
@class LJJInviteSearchResultViewController;
@interface LJJInviteViewModel : NSObject

- (void)setHistoryViewByTheHistoryNet:(id)responseObject;
- (void)setSearchResponseObject:(id)responseObject;
- (void)setHisrotyViewWithViewControllerAndView:(LJJSearchedView *)View;

@end

NS_ASSUME_NONNULL_END
