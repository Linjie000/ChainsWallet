//
//  GetTransactionByIdRequest.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "GetTransactionByIdRequest.h"

@implementation GetTransactionByIdRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/VX/GetTransactionById/%@", REQUEST_HISTORY_HTTP, self.transactionId];
}
@end
