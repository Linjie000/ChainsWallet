//
//  BTCAccount.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/16.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTCAccount : NSObject

@property (strong, nonatomic) NSString *hash160;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *total_received;

@property (strong, nonatomic) NSString *total_sent;

@property (strong, nonatomic) NSString *final_balance;

@property (strong, nonatomic) NSString *n_tx;

@property (strong, nonatomic) NSArray *txs;
 

//"hash160": "9ec6142bc4aea5ba945894f34da35f120d23e26c",
//"address": "1FUX44mhQkKcVdArL5jYFoYfcLTD93pbxA",
//"n_tx": 0,
//"total_received": 0,
//"total_sent": 0,
//"final_balance": 0,
//"txs": [
//
//]
@end

NS_ASSUME_NONNULL_END
