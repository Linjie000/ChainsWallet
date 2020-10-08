//
//  TransactionsResult.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionsResult : NSObject
@property(nonatomic, strong) NSMutableArray *actions;
@property(nonatomic , strong) NSNumber *pageSize;
@property(nonatomic , strong) NSNumber *page;
@property(nonatomic , strong) NSNumber *hasMore;
@end

NS_ASSUME_NONNULL_END
