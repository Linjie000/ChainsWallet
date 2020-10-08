//
//  Get_account_permission_service.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "Get_account_permission_service.h"
#import "EOSGetAccountResult.h"
#import "EOSGetAccount.h"
#import "EOSGetAccountResult.h"
#import "EOSKeys.h"
#import "EOSPermission.h"

@implementation Get_account_permission_service

-(NSString *)requestUrlPath{
    return @"/get_account";
}

-(id)parameters{
    return @{@"name" : (self.name) };
}

- (NSMutableArray *)chainAccountOwnerPublicKeyArray{
    if (!_chainAccountOwnerPublicKeyArray) {
        _chainAccountOwnerPublicKeyArray = [[NSMutableArray alloc] init];
    }
    return _chainAccountOwnerPublicKeyArray;
}

- (NSMutableArray *)chainAccountActivePublicKeyArray{
    if (!_chainAccountActivePublicKeyArray) {
        _chainAccountActivePublicKeyArray = [[NSMutableArray alloc] init];
    }
    return _chainAccountActivePublicKeyArray;
}

- (void)getAccountPermission:(CompleteBlock)complete{
    Get_account_permission_service *account_permission_service = [[Get_account_permission_service alloc]init];
    account_permission_service.name = self.name;
    WeakSelf(weakSelf);
    [account_permission_service postDataSuccess:^(id DAO, id data) {
        if (!data) {
            return ;
        }
        EOSGetAccountResult *result = [EOSGetAccountResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
          
            complete(nil , NO);
        }else{
            EOSGetAccount *model = result.data;
            for (EOSPermission *permission in model.permissions) {
                
                NSMutableArray *keysArray = [EOSKeys mj_objectArrayWithKeyValuesArray:permission.required_auth_keyArray];
                
                if ([permission.perm_name isEqualToString:@"active"]) {
                    
                    for (EOSKeys *key in keysArray) {
                        [weakSelf.chainAccountActivePublicKeyArray addObject:key.key];
                    }
                }else if ([permission.perm_name isEqualToString:@"owner"]){
                    
                    for (EOSKeys *key in keysArray) {
                        [weakSelf.chainAccountOwnerPublicKeyArray addObject:key.key];
                    }
                }
            }
            complete(nil , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}

@end
