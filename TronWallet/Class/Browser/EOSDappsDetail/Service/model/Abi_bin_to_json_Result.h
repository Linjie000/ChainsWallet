//
//  Abi_bin_to_json_Result.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSBaseResult.h"
#import "Abi_bin_to_json.h"
NS_ASSUME_NONNULL_BEGIN

@interface Abi_bin_to_json_Result :EOSBaseResult
@property(nonatomic , strong) Abi_bin_to_json *data;
@end

NS_ASSUME_NONNULL_END
