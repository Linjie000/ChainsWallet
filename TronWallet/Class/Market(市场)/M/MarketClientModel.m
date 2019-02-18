//
//  MarketClientModel.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "MarketClientModel.h"

@implementation MarketClientModel

- (NSString *)name
{
    _coinID = [self coinIDWithName:_name];
    return _name;
}

- (NSString *)coinIDWithName:(NSString *)str
{
    if ([str isEqualToString:@"BTC"]) {
        return @"1";
    }
    if ([str isEqualToString:@"ETH"]) {
        return @"2";
    }
    if ([str isEqualToString:@"LTC"]) {
        return @"5";
    }
    if ([str isEqualToString:@"XRP"]) {
        return @"3";
    }
    if ([str isEqualToString:@"ETC"]) {
        return @"15";
    }
    if ([str isEqualToString:@"BCH"]) {
        return @"4";
    }
    if ([str isEqualToString:@"EOS"]) {
        return @"10";
    }
    if ([str isEqualToString:@"OMG"]) {
        return @"21";
    }
    if ([str isEqualToString:@"DASH"]) {
        return @"12";
    }
    return @"";
}

@end
