//
//  TransactionRecordsResult.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionRecordsResult : NSObject
@property(nonatomic, strong) NSString *msg;


@property(nonatomic, strong) NSNumber *code;
@property(nonatomic, strong) NSMutableDictionary *data;
@end

NS_ASSUME_NONNULL_END
