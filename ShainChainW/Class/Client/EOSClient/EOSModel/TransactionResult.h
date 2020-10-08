//
//  TransactionResult.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionResult : NSObject
@property(nonatomic, strong) NSNumber *code;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSDictionary *data;
@property(nonatomic, strong) NSArray *details;
@property(nonatomic , strong) NSString *error;
@property(nonatomic , strong) NSString *transaction_id;
@property(nonatomic , strong) NSString *tag;
@end

NS_ASSUME_NONNULL_END
