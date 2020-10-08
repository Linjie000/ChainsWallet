//
//  BitCoin86Model.m
//  ShainChainW
//
//  Created by 林衍杰 on 2019/12/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BitCoin86Model.h"

@implementation BitCoin86DataModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"_id" : @"id",
             @"_description":@"description"
             };
}

@end

@implementation BitCoin86Model
+(NSDictionary *)mj_objectClassInArray{
    return @{@"data"  : [BitCoin86DataModel class]};
}
@end
