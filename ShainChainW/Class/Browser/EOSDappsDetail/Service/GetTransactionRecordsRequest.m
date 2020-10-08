//
//  GetTransactionRecordsRequest.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "GetTransactionRecordsRequest.h"

@implementation GetTransactionRecordsRequest
-(NSString *)requestUrlPath{
    return [NSString stringWithFormat:@"%@/VX/GetActions", REQUEST_TRANSACTION_RECORDS];
}

-(id)parameters{
    return @{
             @"symbols"  : VALIDATE_ARRAY(self.symbols),
             @"from"  : VALIDATE_STRING(self.from),
             @"to"  : VALIDATE_NUMBER(self.to),
             @"page"  : VALIDATE_NUMBER(self.page),
             @"pageSize"  : VALIDATE_NUMBER(self.pageSize),
             @"lastPageLastBlockNum"  : VALIDATE_NUMBER(self.lastPageLastBlockNum)
             };
}
@end
