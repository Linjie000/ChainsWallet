//
//  SellRamAbiJsonToBinRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/8.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SellRamAbiJsonToBinRequest : EOSRequestManager
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;
@property(nonatomic, copy) NSString *account;
@property(nonatomic, strong) NSNumber *bytes;
@end

NS_ASSUME_NONNULL_END
