//
//  NewsTool.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class NewsModel;
@class BSJNewsModel;
@class BSJSearchModel;
@class BitCoin86Model;
@interface NewsTool : NSObject
+ (void)getNewsDataSuccess:(void (^)(NewsModel *model))success;

+ (void)getNewsForBiShiJie:(void (^)(BSJNewsModel *model))success;

+ (void)getNewsForBiShiJieKey:(NSString *)key size:(NSInteger)size success:(void (^)(BSJSearchModel *model))success;

+ (void)getNewsForBitCoin86Page:(NSInteger)page success:(void (^)(BitCoin86Model *model))success;
@end
NS_ASSUME_NONNULL_END
