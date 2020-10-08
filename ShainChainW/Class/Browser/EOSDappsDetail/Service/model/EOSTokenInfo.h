//
//  EOSTokenInfo.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/3.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSTokenInfo : NSObject

/**
 contract_name
 */
@property(nonatomic, copy) NSString *contract_name;

/**
 token_symbol
 */
@property(nonatomic, copy) NSString *token_symbol;
/**
 coinmarket_id
 */
@property(nonatomic, copy) NSString *coinmarket_id;

/**
 account_name
 */
@property(nonatomic, copy) NSString *account_name;

/**
 balance
 */
@property(nonatomic, copy) NSString *balance;

/**
 balance_usd
 */
@property(nonatomic, copy) NSString *balance_usd;
/**
 balance_cny
 */
@property(nonatomic, copy) NSString *balance_cny;

/**
 asset_price_usd
 */
@property(nonatomic, copy) NSString *asset_price_usd;

/**
 asset_price_cny
 */
@property(nonatomic, copy) NSString *asset_price_cny;

/**
 asset_price_change_in_24h
 */
@property(nonatomic, copy) NSString *asset_price_change_in_24h;
/**
 iconUrl
 */
@property(nonatomic, copy) NSString *iconUrl;

/**
 iconUrlHd
 */
@property(nonatomic, copy) NSString *iconUrlHd;

/**
 asset_market_cap_cny
 */
@property(nonatomic, copy) NSString *asset_market_cap_cny;

@property(nonatomic , assign) BOOL isRedpacket;

@end

NS_ASSUME_NONNULL_END
