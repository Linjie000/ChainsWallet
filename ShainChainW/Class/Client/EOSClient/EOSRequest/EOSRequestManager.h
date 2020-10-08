//
//  EOSRequestManager.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "EOSHttpUrl.h"
#define REQUEST_APIPATH [NSString stringWithFormat: @"/api_oc_blockchain-v1.3.0%@", [self requestUrlPath]]
#define eosnewyork_APIPATH [NSString stringWithFormat: @"/v1/chain%@", [self requestUrlPath]]
#define eoshistory_APIPATH [NSString stringWithFormat: @"/v1/history%@", [self requestUrlPath]]
//#define eosnewyork_appkey
typedef void (^RequestSuccessBlock)(id DAO, id data);
typedef void (^RequestFailedBlock)(id DAO, NSError *error);
typedef void(^CompleteBlock)(id service , BOOL isSuccess);
@interface EOSRequestManager : NSObject
// 接口返回数据
@property(nonatomic, strong) NSMutableArray *responseArray;

// 控件数据源
@property(nonatomic, strong) NSMutableArray *dataSourceArray;

- (NSString *)requestUrlPath;
- (id)parameters;
/**
 构建数据源
 
 @param complete 数据构建成功的回调
 */
- (void)buildDataSource:(CompleteBlock)complete;
- (void)postOuterDataSuccess:(RequestSuccessBlock)success  failure:(RequestFailedBlock)failure;
- (void)postDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;
- (void)getDataSusscess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;
- (void)postRequestDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;
- (void)getRequestDataSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;
- (void)postRequestHistorySuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;

- (void)postEosparkRequestSuccess:(RequestSuccessBlock)success failure:(RequestFailedBlock)failure;
@end
 
