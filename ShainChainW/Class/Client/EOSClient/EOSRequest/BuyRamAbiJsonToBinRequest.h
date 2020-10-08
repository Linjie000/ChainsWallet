//
//  BuyRamAbiJsonToBinRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/8.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuyRamAbiJsonToBinRequest : EOSRequestManager
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;
@property(nonatomic, copy) NSString *payer;
@property(nonatomic, copy) NSString *receiver;
@property(nonatomic, copy) NSString *quant;
@end

NS_ASSUME_NONNULL_END
