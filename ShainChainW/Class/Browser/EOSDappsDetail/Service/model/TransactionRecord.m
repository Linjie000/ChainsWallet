//
//  TransactionRecord.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TransactionRecord.h"
 

@implementation TransactionRecord
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"transactionType" : @"doc.name",
             @"from" : @"doc.data.from",
             @"to" : @"doc.data.to",
             @"quantity" : @"doc.data.quantity",
             @"memo" : @"doc.data.memo",
             @"expiration" : @"doc.data.expiration",
             @"contract" : @"doc.account"
             };
}


@end

