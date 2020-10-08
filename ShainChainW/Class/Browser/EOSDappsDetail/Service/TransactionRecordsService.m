//
//  TransactionRecordsService.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TransactionRecordsService.h"
#import "TransactionRecord.h"
#import "TransactionRecordsResult.h"
#import "TransactionsResult.h"

@interface TransactionRecordsService()
@property(nonatomic , assign) NSUInteger page;
@property(nonatomic , strong) NSNumber *lastPageLastBlockNum;
@property(nonatomic , strong) TransactionRecord *lastRecord;
@end


@implementation TransactionRecordsService
- (GetTransactionRecordsRequest *)getTransactionRecordsRequest{
    if (!_getTransactionRecordsRequest) {
        _getTransactionRecordsRequest = [[GetTransactionRecordsRequest alloc] init];
    }
    return _getTransactionRecordsRequest;
}

- (void)buildDataSource:(CompleteBlock)complete{
    WeakSelf(weakSelf);
    _page = 0;
    self.getTransactionRecordsRequest.page = @(_page);
    self.getTransactionRecordsRequest.pageSize = @(10);
    self.getTransactionRecordsRequest.lastPageLastBlockNum = @(0);
    [self.getTransactionRecordsRequest postOuterDataSuccess:^(id DAO, id data) {
        
        [weakSelf.dataSourceArray removeAllObjects];
        [weakSelf.responseArray removeAllObjects];
        
        TransactionRecordsResult *result = [TransactionRecordsResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TKCommonTools showToast:VALIDATE_STRING(result.msg)];
        }else{
            TransactionsResult *transactionsResult = [TransactionsResult mj_objectWithKeyValues:result.data];
            for (TransactionRecord *record in transactionsResult.actions) {
                if ([record.quantity containsString:@" "]) {
                    NSArray*quantityArr = [record.quantity componentsSeparatedByString:@" "];
                    record.amount  = quantityArr[0];
                    record.assestsType = quantityArr[1];
                }
                
                //transfer
                if ([record.transactionType isEqualToString:@"transfer"]) {
                    [weakSelf.responseArray addObject:record];
                }
            }
            if (transactionsResult.actions.count>0) {
                weakSelf.lastRecord = [transactionsResult.actions lastObject];
            }
            weakSelf.dataSourceArray = [NSMutableArray arrayWithArray:weakSelf.responseArray];
        }
        complete(@(weakSelf.dataSourceArray.count) , YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}
//
- (void)buildNextPageDataSource:(CompleteBlock)complete{
    
    WeakSelf(weakSelf);
    _page +=1;
    self.getTransactionRecordsRequest.page = @(_page);
    self.getTransactionRecordsRequest.pageSize = @(10);
    self.getTransactionRecordsRequest.lastPageLastBlockNum = self.lastRecord.blockNum;
    [self.getTransactionRecordsRequest postOuterDataSuccess:^(id DAO, id data) {
        
        [weakSelf.responseArray removeAllObjects];
        TransactionRecordsResult *result = [TransactionRecordsResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TKCommonTools showToast:VALIDATE_STRING(result.msg)]; 
        }else{
            TransactionsResult *transactionsResult = [TransactionsResult mj_objectWithKeyValues:result.data];
            for (TransactionRecord *record in transactionsResult.actions) {
                if ([record.quantity containsString:@" "]) {
                    NSArray*quantityArr = [record.quantity componentsSeparatedByString:@" "];
                    record.amount  = quantityArr[0];
                    record.assestsType = quantityArr[1];
                }
                
                if ([record.transactionType isEqualToString:@"transfer"]) {
                    [weakSelf.responseArray addObject:record];
                }
            }
            if (transactionsResult.actions.count>0) {
                weakSelf.lastRecord = [transactionsResult.actions lastObject];
            }
            [weakSelf.dataSourceArray addObjectsFromArray:weakSelf.responseArray];
        }
        complete(@(weakSelf.responseArray.count) , YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil, NO);
    }];
}
@end
