//
//  BlinkEd25519.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import  <Foundation/Foundation.h>

#include "ed25519.h"

@interface Ed25519Keypair :NSObject

@property (nonatomic,strong) NSData *publickey;//公钥32位

@property (nonatomic,strong) NSData *privatekey;//私钥64位

@end
 

@interface BlinkEd25519 :NSObject

/**
 
  生成ed25519密钥串
 
  @return Ed25519Keypair对象，保存一对密钥串
 
  */

+(Ed25519Keypair*)generateEd25519KeyPair;


/**
 
  私钥转公钥
 
  @param privatekey 私钥
  @return 公钥
  */
+ (NSString *)getPublicByPrivateKey:(NSString *)privatekey;

/**
 
  签名数据
 
  @param ed25519keypair 密钥串
 
  @param content 需要签名的数据(json格式的字符串)
 
  @return 签名后的数据
 
  */

+(NSData*)BLinkEd25519_Signature:(Ed25519Keypair*)ed25519keypair Content:(NSString*)content;

/**
 
  验证签名数据
 
  @param signatureData 签名数据
 
  @param contentData 签名前数据
 
  @param ed25519keypair ed25519密钥串
 
  @return 返回是否
 
  */

+(BOOL)BlinkEd25519_Verify:(NSData*)signatureData content:(NSData*)contentData Ed25519Keypair:(Ed25519Keypair*)ed25519keypair;

@end

