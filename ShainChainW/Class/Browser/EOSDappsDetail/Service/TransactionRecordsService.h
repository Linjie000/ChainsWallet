//
//  TransactionRecordsService.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"
#import "GetTransactionRecordsRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface TransactionRecordsService : EOSRequestManager
@property(nonatomic, strong) GetTransactionRecordsRequest *getTransactionRecordsRequest;
- (void)buildNextPageDataSource:(CompleteBlock)complete;
@end

NS_ASSUME_NONNULL_END
