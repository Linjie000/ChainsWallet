//
//  NewsModel.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "NewsModel.h"
@implementation LivesModel

@end

@implementation ListModel
+(NSDictionary *)objectClassInArray{
    return @{@"lives"  : [LivesModel class]};
}
@end

@implementation NewsModel
+(NSDictionary *)objectClassInArray{
    return @{@"list"  : [ListModel class]};
}
@end
