//
//  TransferAbi_json_to_bin_request.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferAbi_json_to_bin_request : EOSRequestManager
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;
@property(nonatomic, copy) NSString *from;
@property(nonatomic, copy) NSString *to;
@property(nonatomic, copy) NSString *memo;
@property(nonatomic, copy) NSString *quantity;





@property(nonatomic , copy) NSString *message;
@end

NS_ASSUME_NONNULL_END
