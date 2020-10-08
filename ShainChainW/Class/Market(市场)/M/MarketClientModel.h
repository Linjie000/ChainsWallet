//
//  MarketClientModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketClientModel : NSObject

@property(strong, nonatomic) NSString *ismysql;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *c_name;
@property(strong, nonatomic) NSString *open;
@property(strong, nonatomic) NSString *close;
@property(strong, nonatomic) NSString *rise;
@property(strong, nonatomic) NSString *url;
@property(strong, nonatomic) NSString *close_rmb;
@property(strong, nonatomic) NSString *euroPrice;
@property(strong, nonatomic) NSString *ghsPrice;
@property(strong, nonatomic) NSString *ngnPrice;
@property(strong, nonatomic) NSString *logo_url;
//coinID
@property(strong, nonatomic) NSString *coinID;
 
@end

NS_ASSUME_NONNULL_END
