//
//  TWPriceUpdater.m
//  TronWallet
//
//  Created by chunhui on 2018/5/23.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWPriceUpdater.h"



@implementation TWPriceUpdater{
    BOOL _doing;
}

-(void)startUpdate
{
    NSURL *url = [NSURL URLWithString:@"https://api.coinmarketcap.com/v1/ticker/tron/"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *error1 = nil;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        TWPrice *price = [[TWPrice alloc]initWithDictionary:[array firstObject] error:&error1];
        if (price) {
            self.price = price;
            if (_updatePrice) {
                _updatePrice(price);
            }
        }
        if (_doing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startUpdate];
            });
        }
    }];
    [task resume];
}

-(void)stopUpdate
{
    _doing = NO;
}

@end


@implementation TWPrice

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"id":@"tid",@"tid":@"id",
                                                                  @"h_volume_usd":@"24h_volume_usd",
                                                                  @"24h_volume_usd":@"h_volume_usd"
                                                                  }];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
