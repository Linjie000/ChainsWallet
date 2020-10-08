//
//  Get_key_accounts_request.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "Get_key_accounts_request.h"
#import "EOSMappingResult.h"
#import "EOSAccountModel.h"

@implementation Get_key_accounts_request
- (NSString *)requestUrlPath{
    return @"/get_key_accounts";
}

- (id)parameters{
    return @{@"public_key" : (self.public_key)};
}

- (void)get_key_accounts:(CompleteBlock)complete{
    WeakSelf(weakSelf);
    NSMutableArray *tmpArr = [NSMutableArray array];
    Get_key_accounts_request *get_key_accounts_request = [[Get_key_accounts_request alloc] init];
    get_key_accounts_request.public_key = self.public_key;
    [get_key_accounts_request postRequestHistorySuccess:^(id DAO, id data) {
        
        EOSMappingResult *result = [EOSMappingResult objectWithKeyValues:data];
        if (data) {
            
            for (NSString *accountName in data[@"account_names"]) {
                // 账号状态 0 ：未导入 1 ： 已经导入 2 ：导入失败 3 :本地存在
                EOSAccountModel *model = [[EOSAccountModel alloc]init];
                model.accountName = accountName;
                [tmpArr addObject:model];
                // 检查本地是否有对应的账号
     
            }
            
            complete(tmpArr, YES);
        }else{
            [TKCommonTools showToast:LocalizedString(@"请确保公钥正确")];
            complete(nil, NO);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}

@end
