//
//  LJJInviteViewModel.h
//  MRMobileRun
//
//  Created by J J on 2019/4/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LJJInviteRunVC;
@class LJJInviteRunView;
@class LJJInviteSearchResultViewController;
@interface LJJInviteViewModel : NSObject

- (void)setHistoryViewByTheHistoryNet:(id)responseObject;
- (void)setHisrotyViewWhenNoHistoryWithViewController:(LJJInviteRunVC *)VC andView:(LJJInviteRunView *)View;
- (void)setSearchResponseObject:(id)responseObject;

@end

NS_ASSUME_NONNULL_END
