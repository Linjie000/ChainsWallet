//
//  GetTransactionByIdRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetTransactionByIdRequest : EOSRequestManager
@property(nonatomic , copy) NSString *transactionId;
@end

NS_ASSUME_NONNULL_END
