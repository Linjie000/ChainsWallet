//
//  ATOMClient.h
//  ShainChainW
//
//  Created by 林衍杰 on 2019/12/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ATOMBalance;
@interface ATOMClient : NSObject

+ (void)atom_getBalanceWithAddress:(NSString *)address handle:(void(^)(ATOMBalance *ATOMBalance))handle;

+ (void)atom_getTransfersListWithAddress:(NSString *)address handle:(void(^)(ATOMBalance *ATOMBalance))handle;

@end

NS_ASSUME_NONNULL_END
