//
//  BlinkEd25519.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BlinkEd25519.h"
#import "BTCBase58.h"
#include "sha512.h"
#include "ge.h"
#include <string.h>
#import "NSData+CommonCrypto.h"

@implementation Ed25519Keypair

@end

@implementation BlinkEd25519

+(Ed25519Keypair*)generateEd25519KeyPair
{
     unsigned char seed[32],publickey[32],privatekey[64];
     ed25519_create_seed(seed);
     ed25519_create_keypair(publickey, privatekey, seed);
     Ed25519Keypair *keypair = [[Ed25519Keypair alloc] init];
     keypair.publickey= [NSData dataWithBytes:publickey length:32];
     keypair.privatekey= [NSData dataWithBytes:privatekey length:64];
     return keypair;
}

+ (NSString *)getPublicByPrivateKey:(NSString *)privatekey;
{
    NSData *privatekeyDecode = BTCDataFromBase58(privatekey);
    if ((privatekeyDecode.length != 32) && (privatekeyDecode.length != 64))
    {
        [TKCommonTools showToast:@"私钥格式错误"];
    }
    Byte codeKeyByteAry[privatekeyDecode.length];
    for (int i = 0 ; i < privatekeyDecode.length; i++) {
        NSData *idata = [privatekeyDecode subdataWithRange:NSMakeRange(i, 1)];
        codeKeyByteAry[i] =((Byte*)[idata bytes])[0];
    }
    unsigned char *private_key_bytes = (unsigned char *)codeKeyByteAry;
    unsigned char public_key[32];
    ge_p3 A;
    private_key_bytes[0] &= 248;
    private_key_bytes[31] &= 63;
    private_key_bytes[31] |= 64;
    
    ge_scalarmult_base(&A, private_key_bytes);
    ge_p3_tobytes(public_key, &A);
    memmove(public_key , private_key_bytes + 32, 32);
    NSData *publickeyData= [NSData dataWithBytes:public_key length:32];
    NSString *publickey = BTCBase58StringWithData(publickeyData);
    
    return publickey;
}

+(NSData*)BLinkEd25519_Signature:(Ed25519Keypair*)ed25519keypair Content:(NSString*)content
{
    unsigned char signature[64];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    contentData = [contentData SHA256Hash];
    ed25519_sign(signature, [contentData bytes], contentData.length, [ed25519keypair.publickey bytes], [ed25519keypair.privatekey bytes]);
    return[NSData dataWithBytes:signature length:64];
}

+(BOOL)BlinkEd25519_Verify:(NSData*)signatureData content:(NSData*)contentData Ed25519Keypair:(Ed25519Keypair*)ed25519keypair
{
     return ed25519_verify([signatureData bytes], [contentData bytes], contentData.length, [ed25519keypair.privatekey bytes]);
}

@end

