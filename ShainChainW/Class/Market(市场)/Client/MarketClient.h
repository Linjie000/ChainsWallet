//
//  MarketClient.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketClient : NSObject
+ (void)getMarketCurrencyDataSuccess:(void (^)(NSArray *responseObject))success;
@end

NS_ASSUME_NONNULL_END
