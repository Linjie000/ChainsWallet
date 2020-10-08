//
//  NewsTool.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "NewsTool.h"
#import "NewsModel.h"
#import "BSJNewsModel.h"
#import "BSJSearchModel.h"
#import "BitCoin86Model.h"

@implementation NewsTool

+ (void)getNewsDataSuccess:(void (^)(NewsModel *model))success
{
    NSString *url = @"http://api.coindog.com/live/list";
    [RequestManager get:url parameters:nil success:^(id  _Nonnull responseObject) {
        NewsModel *model = [NewsModel mj_objectWithKeyValues:responseObject];
        success(model);
     } failure:^(NSError * _Nonnull error) {
        
    }];
}

/**
  币世界资讯
  @param
  */
+ (void)getNewsForBiShiJie:(void (^)(BSJNewsModel *model))success
{
 
    NSString *url = [NSString stringWithFormat:@"https://iapi.bishijie.com/v3/newsFlash?size=30&client=M&signature=9d8a0918e32a334288b4f07e221579dd&ts=1576135821"];
    [RequestManager get:url parameters:nil success:^(id  _Nonnull responseObject) {
        BSJNewsModel *model = [BSJNewsModel mj_objectWithKeyValues:responseObject];
        success(model);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

/**
  币世界资讯
  @param
  */
+ (void)getNewsForBiShiJieKey:(NSString *)key size:(NSInteger)size success:(void (^)(BSJSearchModel *model))success
{
    NSString *url = [NSString stringWithFormat:@"https://www.bishijie.com/api/newsv17/search?key=%@&size=%ld",key,size];
    [RequestManager get:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(id  _Nonnull responseObject) {
        BSJSearchModel *model = [BSJSearchModel mj_objectWithKeyValues:responseObject];
        success(model);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

/**
  bitcoin86
  @param
  */
+ (void)getNewsForBitCoin86Page:(NSInteger)page success:(void (^)(BitCoin86Model *model))success
{
    NSString *url = [NSString stringWithFormat:@"http://www.bitcoin86.com/index.php?s=live&c=api&m=news_list&keyword=&page=%ld&pagesize=15",page];
    [RequestManager get:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:@{} success:^(id  _Nonnull responseObject) {
        BitCoin86Model *model = [BitCoin86Model mj_objectWithKeyValues:responseObject];
        success(model);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
