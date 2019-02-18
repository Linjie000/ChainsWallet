//
//  NSString+JSON.m
//  ToolKit
//
//  Created by iwm on 2017/9/25.
//  Copyright © 2017年 chunhui. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

+ (NSString *)json_stringWithArray:(NSArray *)array {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:kNilOptions
                                                         error:&error];
    
    if (!jsonData) {
#if DEBUG
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
#endif
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (NSString *)json_stringWithDic:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:kNilOptions
                                                         error:&error];
    if (!jsonData) {
#if DEBUG
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
#endif
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
