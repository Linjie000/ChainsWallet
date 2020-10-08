//
//  TronTransactionsModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TronTransactionsModel : NSObject

@property(strong, nonatomic) NSString *amount;
@property(strong, nonatomic) NSString *block;
@property(strong, nonatomic) NSNumber *confirmed;
@property(strong, nonatomic) NSString *data;
@property(strong, nonatomic) NSString *id;
@property(strong, nonatomic) NSString *timestamp;
@property(strong, nonatomic) NSString *transactionHash;
@property(strong, nonatomic) NSString *transferFromAddress;
@property(strong, nonatomic) NSString *transferToAddress;

//amount = 100000000;
//block = 6669425;
//confirmed = 1;
//data = "";
//id = "";    
//timestamp = 1550109483000;
//tokenName = "_";
//transactionHash = 6fe8872c3a140c713a8134afeba80e353f0c28ceb1fd76c4dfa041dc18ee6ebe;
//transferFromAddress = TAPcRJM18mxazsToa6GwKrkvkeEY1PNn1s;
//transferToAddress = TKGMJrCqQKiycKQAuh7vVRAegYa8EtdD1V;
@end

NS_ASSUME_NONNULL_END
