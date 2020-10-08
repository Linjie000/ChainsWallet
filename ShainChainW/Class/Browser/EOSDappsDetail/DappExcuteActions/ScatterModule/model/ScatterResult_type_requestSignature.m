//
//  ScatterResult_type_requestSignature.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "ScatterResult_type_requestSignature.h"


@implementation ScatterResult_type_requestSignature

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"expiration" : @"transaction.expiration",
             @"ref_block_num" : @"transaction.ref_block_num",
             @"ref_block_prefix" : @"transaction.ref_block_prefix",
             @"chainId" : @"data.payload.network.chainId",
             @"actions" : @"transaction.actions",
             @"actor" : @"transaction.actions[0].authorization[0].actor",
             @"permission" : @"transaction.actions[0].authorization[0].permission"
             };
}

@end
