//
//  EOSTokenListModel.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/17.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSTokenListModel.h"

@implementation EOSSymbolList

@end

@implementation EOSSymbolListData
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"symbol_list"  : [EOSSymbolList class]};
}
@end

@implementation EOSTokenListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"err" : @"errno"};
}
@end
