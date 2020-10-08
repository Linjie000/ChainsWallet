//
//  IOSTTransResult.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "IOSTTransResult.h"

@implementation Pre_tx_receipt

@end

@implementation IOSTTransResult
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"hashs" : @"hash"
             };
}
@end
