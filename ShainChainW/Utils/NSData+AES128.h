//
//  NSData+AES128.h
//  TronWallet
//
//  Created by chunhui on 2018/5/24.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES128)

/**
 *  加密
 *
 *  @param key 公钥
 *
 *  @return 加密之后的NSData
 */
- (NSData *)AES128EncryptWithKey:(NSString *)key;
/**
 *  解密
 *
 *  @param key 公钥
 *
 *  @return 解密之后的NSData
 */
- (NSData *)AES128DecryptWithKey:(NSString *)key;

@end
