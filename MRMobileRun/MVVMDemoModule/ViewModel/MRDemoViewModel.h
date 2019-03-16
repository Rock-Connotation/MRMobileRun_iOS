//
//  MRDemoViewModel.h
//  MRMobileRun
//
//  Created by liangxiao on 2019/3/5.
//

#import <Foundation/Foundation.h>
@class MRDemoModel;


NS_ASSUME_NONNULL_BEGIN

@interface MRDemoViewModel : NSObject

@property (nonatomic, copy) NSMutableArray <MRDemoModel*>*modelArray;

- (void) fetchNetWorkDataCompleted:(void (^)(void))completedBlock;

@end

NS_ASSUME_NONNULL_END
