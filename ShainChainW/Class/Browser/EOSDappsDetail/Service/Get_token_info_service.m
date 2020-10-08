//
//  Get_token_info_service.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/3.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "Get_token_info_service.h"
#import "GetTokenInfoResult.h"

@implementation Get_token_info_service
-(NSString *)requestUrlPath{ 
    return [NSString stringWithFormat:@"%@/get_token_info", REQUEST_PERSONAL_BASEURL];
}

-(id)parameters{
    return @{
             @"accountName" : VALIDATE_STRING(self.accountName),
             @"ids" : VALIDATE_ARRAY(self.ids)
             
             };
}

- (void)get_token_info:(CompleteBlock)complete{
    WeakSelf(weakSelf);
    Get_token_info_service *get_token_info_request = [Get_token_info_service new];
    get_token_info_request.accountName = self.accountName;
    [get_token_info_request postOuterDataSuccess:^(id DAO, id data) {
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        GetTokenInfoResult *result = [GetTokenInfoResult mj_objectWithKeyValues:data];
        [weakSelf.responseArray addObjectsFromArray:result.data];
        [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
        complete(result, YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}
@end
