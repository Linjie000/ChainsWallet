//
//  TypeChainId.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TypeChainId.h"

@interface TypeChainId()
{
    const NSData *mId;
}
@end

@implementation TypeChainId

- (instancetype)init {
    if (self = [super init]) {
        const Byte byte[32] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        mId = [NSData dataWithBytes:byte length:32];
    }
    return self;
}

- (const void *)getBytes {
    
    return [mId bytes];
}
- (const NSData *)chainId{
    
    return mId;
}
@end
