//
//  NSObject+BGKVTool.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "NSObject+BGKVTool.h"
#import "BGTool.h"

@implementation NSObject (BGKVTool)

+ (NSString*)bg_sqlKey:(NSString* )key{
    return [NSString stringWithFormat:@"%@%@",@"BG_",key];
}

/**
 转换OC对象成数据库数据.
 */
+ (NSString*)bg_sqlValue:(id)value{
    
    if([value isKindOfClass:[NSNumber class]]) {
        return value;
    }else if([value isKindOfClass:[NSString class]]){
        return [NSString stringWithFormat:@"'%@'",value];
    }else{
        NSString* type = [NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([value class])];
        value = [BGTool getSqlValue:value type:type encode:YES];
        if ([value isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"'%@'",value];
        }else{
            return value;
        }
    }
}
@end
