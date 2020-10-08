//
//  MarketClient.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "MarketClient.h"
#import "MarketClientModel.h"
#import "AFNetworking.h"

@implementation MarketClient

+ (void)getMarketCurrencyDataSuccess:(void (^)(NSArray *responseObject))success
{
//    http://www.qkljw.com/app/Kline/get_currency_data
//    http://api.coindog.com/api/v1/ticks/HUOBIPRO?unit=cny
    [self get:@"http://www.qkljw.com/app/Kline/get_currency_data" parameters:@{} success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            NSDictionary *dic = responseObject;
            NSArray *modelArray = [MarketClientModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            success(modelArray);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }]; 
}

+ (void)get:(NSString *)url parameters:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置响应数据的格式
    //AFHTTPResponseSerializer 返回的数据类型为二进制类型
    //AFJSONResponseSerializer 返回数据类型为json类型
    //AFXMLParserResponseSerializer xml类型
    manager.requestSerializer.timeoutInterval = 15.f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    //    [manager.requestSerializer setValue:APIKEY forHTTPHeaderField:@"api-key"];
    //    [manager.requestSerializer setValue:[ToolUtil hmac:paramer withKey:Secret] forHTTPHeaderField:@"sign"];
    //    [manager.requestSerializer setValue:BusinessID forHTTPHeaderField:@"x-auth-token"];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //        DLog(@"222%@ ------ %@",requestPath,paramer);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *dataStr =[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        
        NSData *resData = [[NSData alloc] initWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        //2.将NSData解析为NSDictionary
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:kNilOptions error:nil];
        
        success(resultDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        DLog(@"%@",error);
        //        NSError * e = [[NSError alloc] initWithDomain:error.userInfo[@"NSLocalizedDescription"] code:error.code userInfo:error.userInfo];
        //        error = e;
        failure(error);
        
        
    }];

}


@end
