//
//  ATOMClient.m
//  ShainChainW
//
//  Created by 林衍杰 on 2019/12/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "ATOMClient.h"

#import "ATOMBalance.h"

#define Head @"https://stargate.cosmos.network/"

#define GetBalaece_Request @"bank/balances/"

@implementation ATOMClient

//创建账号
+ (void)atom_createAccount_lib:(void(^)(NSString *privatekey,NSString *publickey))handle
{
    
}

+ (void)atom_getBalanceWithAddress:(NSString *)address handle:(void(^)(ATOMBalance *ATOMBalance))handle
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",Head,GetBalaece_Request,address];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        if (IsNilOrNull(responseObject)) {
            return ;
        }
        NSArray *array = (NSArray *)responseObject;
        ATOMBalance *account = [ATOMBalance mj_objectWithKeyValues:array[0]];
        NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@ ",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"ATOM"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        coinModel *model = [arr lastObject];
        model.totalAmount = [RewardHelper delectLastZero:[NSString stringWithFormat:@"%.4f",[account.amount floatValue]/1000000]];
        [model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"ATOM"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        handle(account);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (void)atom_getTransfersListWithAddress:(NSString *)address handle:(void(^)(ATOMBalance *ATOMBalance))handle
{
    NSString *url = [NSString stringWithFormat:@"%@bank/accounts/%@/transfers",Head,address];
    [RequestManager post:url parameters:@{} success:^(id  _Nonnull responseObject) {
        if (IsNilOrNull(responseObject)) {
            return ;
        }
        NSArray *array = (NSArray *)responseObject;
        
        handle(nil);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
