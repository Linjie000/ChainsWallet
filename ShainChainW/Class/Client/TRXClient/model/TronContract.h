//
//  TronContract.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/14.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FreezeBalanceContract;
@class FreezeBalanceContract;
@class TronTransferContract;

@interface TronContract : NSObject

@end

@interface FreezeBalanceContract : NSObject
@property(nonatomic, readwrite, copy, null_resettable) NSString *owner_address;

@property(nonatomic, readwrite) int64_t frozen_balance;

@property(nonatomic, readwrite) int64_t frozen_duration;

@property(nonatomic, readwrite) int64_t resource; //0 换带宽,1 换能量

//@property(nonatomic, readwrite, copy, null_resettable) NSData *receiverAddress;
@end

@interface UnfreezeBalanceContract : NSObject

@property(nonatomic, readwrite, copy, null_resettable) NSString *owner_address;

@property(nonatomic, readwrite) int64_t resource; //0 带宽,1 能量

@end

@interface TronTransferContract : NSObject

@property(nonatomic, readwrite, copy, null_resettable) NSString *owner_address;

@property(nonatomic, readwrite, copy, null_resettable) NSString *to_address;

@property(nonatomic, readwrite) int64_t amount;

@end



NS_ASSUME_NONNULL_END
