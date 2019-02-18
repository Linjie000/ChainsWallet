//
//  NSString+JSON.h
//  ToolKit
//
//  Created by iwm on 2017/9/25.
//  Copyright © 2017年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

+ (NSString *)json_stringWithArray:(NSArray *)array;
+ (NSString *)json_stringWithDic:(NSDictionary *)dic;

@end
