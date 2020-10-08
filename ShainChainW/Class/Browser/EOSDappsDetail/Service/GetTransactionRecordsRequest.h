//
//  GetTransactionRecordsRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetTransactionRecordsRequest : EOSRequestManager

@property(nonatomic , strong) NSMutableArray *symbols;

@property(nonatomic, copy) NSString *from;

@property(nonatomic, copy) NSString *to;

@property(nonatomic, copy) NSNumber *page;

@property(nonatomic, copy) NSNumber *pageSize;


/**
 上页最后一条记录的blockNum,如果是第一页，则不传
 */
@property(nonatomic, copy) NSNumber *lastPageLastBlockNum;
@end

NS_ASSUME_NONNULL_END
