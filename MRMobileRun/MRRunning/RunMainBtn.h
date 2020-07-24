//
//  RunMainBtn.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunMainBtn : UIButton
@property (nonatomic, strong) UIImageView *logoImg;
@property (nonatomic, strong) UILabel *descLbl;

- (void)initRunBtn;;
@end

NS_ASSUME_NONNULL_END
