//
//  Abi_bin_to_jsonRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Abi_bin_to_jsonRequest : EOSRequestManager
@property(nonatomic , copy) NSString *code;
@property(nonatomic , copy) NSString *action;
@property(nonatomic , copy) NSString *binargs;
@end

NS_ASSUME_NONNULL_END
