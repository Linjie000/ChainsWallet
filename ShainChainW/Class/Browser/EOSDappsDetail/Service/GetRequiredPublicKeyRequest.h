//
//  GetRequiredPublicKeyRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetRequiredPublicKeyRequest : EOSRequestManager
@property(nonatomic, copy) NSString *ref_block_prefix;
@property(nonatomic, copy) NSString *ref_block_num;
@property(nonatomic, copy) NSString *expiration;

@property(nonatomic, copy) NSString *sender;

@property(nonatomic, copy) NSString *data;
// contract
@property(nonatomic, copy) NSString *account;
// name : transfer / ask
@property(nonatomic , copy) NSString *name;
@property(nonatomic, strong) NSArray *available_keys;

@property(nonatomic , copy) NSString *permission;
@end

NS_ASSUME_NONNULL_END
