//
//  Abi_json_to_bin_Result.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSBaseResult.h"
#import "Abi_json_to_bin.h"
NS_ASSUME_NONNULL_BEGIN

@interface Abi_json_to_bin_Result : EOSBaseResult
@property(nonatomic , strong) Abi_json_to_bin *data;
@end

NS_ASSUME_NONNULL_END
