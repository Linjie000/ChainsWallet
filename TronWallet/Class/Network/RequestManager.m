//
//  RequestManager.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"

@implementation RequestManager

+ (void)get:(NSString *)url parameters:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    SCLog(@"get  :%@",url);
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        SCLog(@"responseObject  :%@",responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
//            [RewardHelper showTextWithHUD:@"请检查您的网络"];
            failure(error);
        }
    }];
 
}

@end
