//
//  NSString+pinyin.m
//  ToolKit
//
//  Created by chunhui on 15/6/28.
//  Copyright (c) 2015年 chunhui. All rights reserved.
//

#import "NSString+pinyin.h"

@implementation NSString (pinyin)

-(NSString *)pinyinString
{
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0,(__bridge CFStringRef)self);
    
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);//kCFStringTransformToLatin
    
    //去掉音调
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    return (__bridge_transfer NSString *)string;
}

@end
