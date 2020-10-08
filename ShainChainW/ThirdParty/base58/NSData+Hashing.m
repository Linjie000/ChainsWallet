//
//  NSData+Hashing.m
//  BitcoinSwift
//
//  Created by Kevin Greene on 6/19/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

#import "NSData+Hashing.h"

#import <openssl/hmac.h>
#import <openssl/ripemd.h>
#import <openssl/sha.h>
//#import "sha3.h"
#import <ethers/sha3.h>
#import <ethers/ccMemory.h>
#import <ethers/SecureData.h>
//#import "ccMemory.h"
//#import "SecureData.h"

@implementation NSData (Hashing)

- (NSData *)SHA256Hash {
  SHA256_CTX ctx;
  unsigned char hash[32];
  SHA256_Init(&ctx);
  SHA256_Update(&ctx, self.bytes, self.length);
  SHA256_Final(hash, &ctx);
  return [NSData dataWithBytes:hash length:32];
}

- (NSString *)hexadecimalString{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
    {
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    
    return [NSString stringWithString:hexString];
}

- (NSData *)RIPEMD160Hash {
  RIPEMD160_CTX ctx;
  unsigned char hash[20];
  RIPEMD160_Init(&ctx);
  RIPEMD160_Update(&ctx, self.bytes, self.length);
  RIPEMD160_Final(hash, &ctx);
  return [NSData dataWithBytes:hash length:20];
}

- (void)HMACSHA512WithKey:(NSData *)key digest:(NSMutableData *)digest {
  unsigned int length = 64;
  NSAssert(digest.length == 64, @"Invalid output length for HMACSHA512");
  HMAC(EVP_sha512(),
       key.bytes,
       (int)key.length,
       self.bytes,
       (int)self.length,
       [digest mutableBytes],
       &length);
}

- (NSData*)KECCAK256Hash {
    
    SecureData *secureData = [SecureData secureDataWithData:self];
    SecureData *kecck256Data = [secureData KECCAK256];
    
    return [kecck256Data data];
    
//    NSMutableData *hashData = [[NSMutableData alloc] initWithCapacity:32];
//    SHA3_CTX context;
//    keccak_256_Init(&context);
//    keccak_Update(&context, self.bytes, (size_t)self.length);
//    keccak_Final(&context, hashData.mutableBytes);
//    
//    CC_XZEROMEM(&context, sizeof(SHA3_CTX));
//    
//    return hashData;
}


@end
