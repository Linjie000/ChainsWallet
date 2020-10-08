//
//  ApproveAbiJsonToBinRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/9.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApproveAbiJsonToBinRequest : EOSRequestManager
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;
@property(nonatomic, copy) NSString *from;
@property(nonatomic, copy) NSString *receiver;
@property(nonatomic, copy) NSString *stake_net_quantity;
@property(nonatomic, copy) NSString *stake_cpu_quantity;
@property(nonatomic, copy) NSString *transfer;
@end

NS_ASSUME_NONNULL_END
