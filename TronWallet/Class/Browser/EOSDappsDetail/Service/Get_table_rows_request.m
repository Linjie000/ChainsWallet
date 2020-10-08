//
//  Get_table_rows_request.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "Get_table_rows_request.h"

@implementation Get_table_rows_request
-(NSString *)requestUrlPath{
    return @"/get_table_rows";
}

-(id)parameters{
    return @{@"json":[NSNumber numberWithBool:YES],@"code":VALIDATE_STRING(self.code),@"scope":VALIDATE_STRING(self.scope),@"table":VALIDATE_STRING(self.table),@"table_key":@"",@"lower_bound":@"",@"upper_bound":@"",@"limit":@10};
}
@end
