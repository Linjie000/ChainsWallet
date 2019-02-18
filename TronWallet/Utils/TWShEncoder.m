//
//  TWShEncoder.m
//  TronWallet
//
//  Created by chunhui on 2018/5/22.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWShEncoder.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import <openssl/bn.h>
#import "BTCData.h"
#import "NS+BTCBase58.h"

@implementation TWShEncoder

+(NSString *)encode58Check:(NSData *)data
{
//        
//    NSData *d256 = [self sha256:data];
//    d256 = [self sha256:d256];
    
    NSMutableData *msha256Data = BTCSHA256(data);
    msha256Data = BTCSHA256(msha256Data);
    
    char *inputCheck = (char *)malloc(data.length + 4);
    
    const char * bytes = (const char *)[data bytes];
    for (int i = 0 ; i < data.length; i++) {
        inputCheck[i] = (const char)bytes[i];
    }
    const char *d256Bytes = (const char *)[msha256Data bytes];
    for (int i = 0 ; i < 4; i++) {
        inputCheck[i+data.length] = (const char)d256Bytes[i];
    }
    
    NSData *endata = [[NSData alloc] initWithBytes:inputCheck length:data.length+4];
    
    return [endata base58String];
    
    
    /*
     byte[] hash0 = Hash.sha256(input);
     byte[] hash1 = Hash.sha256(hash0);
     byte[] inputCheck = new byte[input.length + 4];
     System.arraycopy(input, 0, inputCheck, 0, input.length);
     System.arraycopy(hash1, 0, inputCheck, input.length, 4);
     return Base58.encode(inputCheck);
     
     public static void (Object src,
     int srcPos,
     Object dest,
     int destPos,
     int length)
     
     */
    
//    void *bytes = [data bytes];
//    const char *cstr = [str UTF8String];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
//    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
//    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
//    CC_SHA1(cstr,  strlen(cstr), digest);
//    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
//        [result appendFormat:@"%02x", digest[i]];
//    }
//    return result;
    
//    return @"";
}

//+(NSData *)sha256:(NSData *)data
//{
//    const void *bytes = [data bytes];
//    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
//    CC_SHA256(bytes, (CC_LONG)data.length, digest);
//    return [[NSData alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
//}




@end
