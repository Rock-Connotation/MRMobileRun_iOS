//
//  MGDShareModel.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDShareModel : NSObject

//分享标题 只分享文本是也用这个字段
@property (nonatomic,copy) NSString *title;
//描述内容
@property (nonatomic,copy) NSString *descr;
//缩略图
@property (nonatomic,strong) id thumbImage;
//链接
@property (nonatomic,copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
