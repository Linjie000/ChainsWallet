//
//  RequestManager.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface RequestManager : NSObject
+ (void)get:(NSString *)url parameters:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;
+ (void)post:(NSString *)url parameters:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull error))failure;
+ (void)postData:(NSString *)url parameters:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure;
+ (void)Post:(NSString *)url parameters:(TronTransaction *)tronTransaction success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure;
+ (void)uploadHeadUrlString:(NSString *)url parameters:(TronTransaction *)tronTransaction back:(void(^)(NSDictionary * dic))block;
@end

NS_ASSUME_NONNULL_END
