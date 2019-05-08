//
//  MRTabBarView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
@class MRTabBarView;

@protocol MRTabBarViewDelegate <NSObject>

- (void)tabBarView:(MRTabBarView *_Nullable)view didSelectedItemAtIndex:(NSInteger) index;

@end
NS_ASSUME_NONNULL_BEGIN

@interface MRTabBarView : UIView

@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray<NSString *> *textArray;
@property (strong, nonatomic) NSMutableArray *labArray;
@property (assign, nonatomic) id<MRTabBarViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
