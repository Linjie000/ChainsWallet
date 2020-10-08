//
//  EOSAttackClient.h
//  ShainChainW
//
//  Created by 闪链 on 2019/8/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSAttackClient : NSObject
- (void)eosTransferPassword:(NSString *)password price:(NSString *)p fromAddress:(NSString *)fromaddress toAddress:(NSString *)toaddress memo:(NSString *)m contractAddress:(NSString *)contractName actionName:(NSString *)action;
@end

NS_ASSUME_NONNULL_END
