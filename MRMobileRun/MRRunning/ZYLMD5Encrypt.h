//
//  ZYLMD5Encrypt.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLMD5Encrypt : NSObject
// MD5加密

// 32位小写
+(NSString *)MD5ForLower32Bate:(NSString *)str;
// 32位大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str;
// 16为大写
+(NSString *)MD5ForUpper16Bate:(NSString *)str;
// 16位小写
+(NSString *)MD5ForLower16Bate:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
