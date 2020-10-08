//
//  Sha256.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sha256 : NSObject
@property(nonatomic, strong) NSData *mHashBytesData;
// sha256result with hex encoding
@property(nonatomic, strong) NSString *sha256;
- (instancetype)initWithData:(NSData *)bytesData;

@end
NS_ASSUME_NONNULL_END
