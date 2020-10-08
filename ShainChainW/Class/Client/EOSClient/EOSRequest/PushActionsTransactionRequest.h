//
//  PushActionsTransactionRequest.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/26.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"
#import "EOSActionsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PushActionsTransactionRequest : EOSRequestManager
@property(nonatomic, copy) NSString *ref_block_prefix;
@property(nonatomic, copy) NSString *ref_block_num;
@property(nonatomic, copy) NSString *expiration;

@property(nonatomic, copy) NSArray *actions;

@property(nonatomic, copy) NSString *signatureStr;
@property(nonatomic , copy) NSString *permission;
@end

NS_ASSUME_NONNULL_END
