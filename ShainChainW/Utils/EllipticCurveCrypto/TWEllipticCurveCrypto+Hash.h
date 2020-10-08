//
//  TWEllipticCurveCrypto+Hash.h
//  TronWallet
//
//  Created by chunhui on 2018/5/25.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWEllipticCurveCrypto.h"

@interface TWEllipticCurveCrypto (Hash)

- (NSData*)hashSHA256AndSignData: (NSData*)data;
- (BOOL)hashSHA256AndVerifySignature: (NSData*)signature forData: (NSData*)data;

- (NSData*)hashSHA384AndSignData: (NSData*)data;
- (BOOL)hashSHA384AndVerifySignature: (NSData*)signature forData: (NSData*)data;

- (NSData*)encodedSignatureForHash: (NSData*)hash;
- (BOOL)verifyEncodedSignature: (NSData*)encodedSignature forHash: (NSData*)hash;

- (NSData*)hashSHA256AndSignDataEncoded: (NSData*)data;
- (BOOL)hashSHA256AndVerifyEncodedSignature: (NSData*)encodedSignature forData: (NSData*)data;

- (NSData*)hashSHA384AndSignDataEncoded: (NSData*)data;
- (BOOL)hashSHA384AndVerifyEncodedSignature: (NSData*)encodedSignature forData: (NSData*)data;

@end
