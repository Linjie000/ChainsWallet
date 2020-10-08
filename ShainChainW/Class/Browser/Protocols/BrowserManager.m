//
//  BrowserManager.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BrowserManager.h"
#import "BrowserModel.h"
#import "AFNetworking.h"
#import "LabelIDsModel.h"
#import "RecommendDappModel.h"

@implementation BrowserManager
 
+ (void)getBrowserDappByConfigID:(NSString *)configID success:(void (^)(id responseObject))success
{
    NSString *url = [NSString stringWithFormat:@"https://api6.pocketeos.top/api_oc_personal/v1.0.0/get_dapp_by_config_id?id=%@",configID];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            NSMutableArray *marry = [NSMutableArray new];
            for (NSDictionary *dic in responseObject[@"data"]) {
                BrowserModel *model = [[BrowserModel alloc]init];
                model.img = dic[@"dappIcon"];
                model.title = dic[@"dappName"];
                model.ID = dic[@"id"];
                model.subTitle = dic[@"dappIntro"];
                model.url = dic[@"dappUrl"];
                [marry addObject:model];
            }
            success(marry);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//获取banner 图 推荐
+ (void)getRecommendMenuDatasuccess:(void (^)(id responseObject))success
{
//    https://api6.pocketeos.top/api_oc_personal/v1.0.0/recommend_dapp
    [RequestManager get:@"https://api6.pocketeos.top/api_oc_personal/v1.0.0/recommend_dapp" parameters:@{} success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            RecommendDappModel *models = [RecommendDappModel mj_objectWithKeyValues:responseObject[@"data"]];
            success(models);
        }
    } failure:^(NSError * _Nonnull error) {
        success(nil);
    }];
}

//获取种类
+ (void)getcategoryData:(void (^)(id responseObject))success
{
//    https://api6.pocketeos.top/api_oc_personal/v1.0.0/category_config
    NSString *url = @"https://api6.pocketeos.top/api_oc_personal/v1.0.0/category_config";
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            NSArray *arr = responseObject[@"data"];
            NSMutableArray *models = [LabelIDsModel mj_objectArrayWithKeyValuesArray:arr];
            success(models);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
 
}

+ (void)getCategoryData_Maizi_CoinTypeName:(NSString *)typeName handle:(void(^)(id responseObject))success
{
    NSString *url = [NSString stringWithFormat:@"https://api.medishares.net/apiDapp/getList?v=1.0&code=582cdc0176a329f0d3c6bbac099962d0&time=%@&limit=99999&market=mathwallet&page=0&tagID=0&type=%@",[RewardHelper getNowTimeTimestamp],typeName];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        success(nil);
    }];
}

@end
