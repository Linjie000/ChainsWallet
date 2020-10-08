//
//  TransactionRecord.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionRecord : NSObject
/**
 接受的返回数据type不止transfer，所以必须判断transactionType == transfer
 */
@property(nonatomic, copy) NSString *transactionType;

/**
 amount
 */
@property(nonatomic , copy) NSString *amount;

/**
 EOS .. OCT..
 */
@property(nonatomic, copy) NSString *assestsType;
/**
 amount + assestsType
 */

@property(nonatomic, copy) NSString *quantity;

/**
 付款方
 */
@property(nonatomic, copy) NSString *from;
/**
 
 收款方
 */
@property(nonatomic, copy) NSString *to;


/**
 memo
 */
@property(nonatomic, copy) NSString *memo;

/**
 过期时间
 */
@property(nonatomic, copy) NSString *expiration;

/**
 ref_block_num
 */
@property(nonatomic, strong) NSNumber *blockNum;

@property(nonatomic, copy) NSString *time;

@property(nonatomic , copy) NSString *trxid;

@property(nonatomic , copy) NSString *cpu_usage_us;

@property(nonatomic , copy) NSString *net_usage_words;

// 合约
@property(nonatomic , copy) NSString *contract;
@end

NS_ASSUME_NONNULL_END
