//
//  UnstakeEosAbiJsonTobinRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/9.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnstakeEosAbiJsonTobinRequest : EOSRequestManager
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;
@property(nonatomic, copy) NSString *from;
@property(nonatomic, copy) NSString *receiver;
@property(nonatomic, copy) NSString *unstake_net_quantity;
@property(nonatomic, copy) NSString *unstake_cpu_quantity;
@end

NS_ASSUME_NONNULL_END
