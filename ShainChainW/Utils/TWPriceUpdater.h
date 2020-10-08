//
//  TWPriceUpdater.h
//  TronWallet
//
//  Created by chunhui on 2018/5/23.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface TWPrice : JSONModel

@property(nonatomic , strong) NSString *tid;
@property(nonatomic , strong) NSString *name;
@property(nonatomic , strong) NSString *symbol;
@property(nonatomic , strong) NSString *rank;
@property(nonatomic , strong) NSString *price_usd;
@property(nonatomic , strong) NSString *price_btc;
@property(nonatomic , strong) NSString *h_volume_usd;
@property(nonatomic , strong) NSString *market_cap_usd;
@property(nonatomic , strong) NSString *available_supply;
@property(nonatomic , strong) NSString *total_supply;
//@property(nonatomic , strong) NSString *max_supply;
@property(nonatomic , strong) NSString *percent_change_1h;
@property(nonatomic , strong) NSString *percent_change_24h;
@property(nonatomic , strong) NSString *percent_change_7d;
@property(nonatomic , strong) NSString *last_updated;

@end

@interface TWPriceUpdater : NSObject

@property(nonatomic , strong) TWPrice *price;
@property(nonatomic , copy) void (^updatePrice)(TWPrice *price);

-(void)startUpdate;
-(void)stopUpdate;

@end
