//
//  TransferService.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"
#import "TransactionResult.h"

typedef NS_OPTIONS(NSUInteger, PushTransactionType) {
    PushTransactionTypeTransfer ,// 转账
    PushTransactionTypeRedPacket ,//发红包
    PushTransactionTypeApprove,//押币
    PushTransactionTypeAskQustion,//提问(场景:DApp 有问必答)
    PushTransactionTypeAnswer,//回答问题(场景:DApp 有问必答)
    PushTransactionTypeRegisteVoteSystem,//投票前需要将自己注册到投票系统
};

@protocol TransferServiceDelegate<NSObject>
- (void)pushTransactionDidFinish:(TransactionResult *)result;
@end

@interface TransferService : EOSRequestManager
@property(nonatomic, weak) id<TransferServiceDelegate> delegate;

@property(nonatomic, copy) NSString *action;

@property(nonatomic, copy) NSString *sender;

@property(nonatomic, copy) NSString *code;// contract
@property(nonatomic, copy) NSString *binargs;

// available_keys
@property(nonatomic, strong) NSArray *available_keys;

@property (nonatomic) PushTransactionType pushTransactionType;
// pushTransaction
- (void)pushTransaction;

@property(nonatomic , copy) NSString *password;

@property(nonatomic , copy) NSString *permission;

@property(nonatomic, copy) NSString *ref_block_num;

@end

