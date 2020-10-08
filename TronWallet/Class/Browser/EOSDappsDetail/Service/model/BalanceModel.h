//
//  BalanceModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSBaseResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface BalanceModel : EOSBaseResult
@property(nonatomic , strong) NSNumber *code;
@property(nonatomic , copy) NSString *balance;
@property(nonatomic , copy) NSString *message;
@end

NS_ASSUME_NONNULL_END
