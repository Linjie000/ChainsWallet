//
//  BrowserManager.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrowserManager : NSObject
+ (void)getRecommendMenuDatasuccess:(void (^)(id responseObject))success;
+ (void)getcategoryData:(void (^)(id responseObject))success;
+ (void)getBrowserDappByConfigID:(NSString *)configID success:(void (^)(id responseObject))success;
+ (void)getCategoryData_Maizi_CoinTypeName:(NSString *)typeName handle:(void(^)(id responseObject))success;
@end

NS_ASSUME_NONNULL_END
