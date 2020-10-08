//
//  Abi_json_to_binRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Abi_json_to_binRequest : EOSRequestManager
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;
@property(nonatomic , strong) NSDictionary *args;
@end

NS_ASSUME_NONNULL_END
