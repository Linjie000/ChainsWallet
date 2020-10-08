//
//  EosByteWriter.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeChainId.h"
#import "NSObject+Extension.h"

@interface EosByteWriter : NSObject

- (instancetype)initWithCapacity:(int) capacity ;

- (void)ensureCapacity:(int)capacity ;

- (void)put:(Byte)b ;

- (void)putShortLE:(short)value ;

- (void)putIntLE:(int)value ;

- (void)putLongLE:(long)value ;

- (void)putBytes:(NSData *)value ;

- (NSData *)toBytes ;

- (int)length ;

- (void)putString:(NSString *)value ;

- (void)putCollection:(NSArray *)collection ;

- (void)putVariableUInt:(long)val ;


+ (NSData *)getBytesForSignature:(TypeChainId *)chainId andParams:(NSDictionary *)paramsDic andCapacity:(int)capacity;



// ExcuteMultipleActions
+ (NSData *)getBytesForSignatureExcuteMultipleActions:(TypeChainId *)chainId andParams:(NSDictionary *)paramsDic andCapacity:(int)capacity;




@end
