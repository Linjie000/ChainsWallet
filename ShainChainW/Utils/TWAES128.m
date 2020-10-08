//
//  TWAES128.m
//  TronWallet
//
//  Created by chunhui on 2018/5/24.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWAES128.h"
#import "TWHexConvert.h"
#import "NSData+AES128.h"

#define IV  @"偏移量 16位长度的字符串"
#define  KEY  @"key值 16位长度的字符串"

@implementation TWAES128

/**
 *  加密
 *
 *  @param string 需要加密的string
 *
 *  @return 加密后的字符串
 */
+ (NSString *)AES128EncryptStrig:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self AES128EncryptData:data];
}

/**
 *  加密
 *
 *  @param data 需要加密的data
 *
 *  @return 加密后的字符串
 */
+ (NSString *)AES128EncryptData:(NSData *)data{
    NSData *aesData = [data AES128EncryptWithKey:KEY];
    return [TWHexConvert convertDataToHexStr:aesData];
}

/**
 *  解密
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容
 */
+ (NSString *)AES128DecryptString:(NSString *)string{
    NSData *data  = [TWHexConvert convertHexStrToData:string];
    NSData *aesData = [data AES128DecryptWithKey:KEY];
    return [[NSString alloc] initWithData:aesData encoding:NSUTF8StringEncoding];
}

/**
 *  解密
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容
 */
+ (NSData *)AES128DataDecryptString:(NSString *)string{
    NSData *data  = [TWHexConvert convertHexStrToData:string];
    return  [data AES128DecryptWithKey:KEY];
}



@end
