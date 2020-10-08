//
//  PushTransactionRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PushTransactionRequest : EOSRequestManager
//api6 方法  不能用 
@property(nonatomic, copy) NSString *packed_trx;
@property(nonatomic, copy) NSString *signatureStr;

//
@property(nonatomic, copy) NSString *ref_block_prefix;
@property(nonatomic, copy) NSString *ref_block_num;
@property(nonatomic, copy) NSString *expiration;

@property(nonatomic, copy) NSString *sender;

@property(nonatomic, copy) NSString *data;
// contract
@property(nonatomic, copy) NSString *account;
// name : transfer / ask
@property(nonatomic , copy) NSString *name;
 

@property(nonatomic , copy) NSString *permission;
@end

NS_ASSUME_NONNULL_END
