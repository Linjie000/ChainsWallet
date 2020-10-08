//
//  IOSTByteWriter.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/21.
//  Copyright © 2019 onesmile. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypeChainId.h"
#import "NSObject+Extension.h"

@interface IOSTByteWriter : NSObject

- (instancetype)initWithCapacity:(int) capacity ;

- (void)ensureCapacity:(int)capacity ;

- (void)put:(Byte)b ;

- (void)putShortLE:(short)value ;

- (void)putIntLE:(int)value ;

- (void)putBytes:(NSData *)value ;

- (NSData *)toBytes ;

- (int)length ;
 
 
+ (NSData *)getBytesForSignatureAndParams:(NSDictionary *)paramsDic andCapacity:(int)capacity;
 

@end
