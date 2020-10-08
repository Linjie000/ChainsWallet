//
//  NSMutableAttributedString+ChangeTextAttributed.m
//  ZQMicroBlog
//
//  Created by Jimmy on 15/12/1.
//  Copyright (c) 2015年 Cooperation. All rights reserved.
//

#import "NSMutableAttributedString+ChangeTextAttributed.h"
#import "TextAndImageTool.h"
#define URL_EXPRESSION @"http://t.cn/[a-zA-Z0-9]+"
#define AT_IN_WEIBO_EXPRESSION @"(@[\u4e00-\u9fa5a-zA-Z0-9_-]+)"
#define TOPIC_IN_WEIBO_EXPRESSION @"(#[^#]+#)"
#define Emotion @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
@implementation NSMutableAttributedString (ChangeTextAttributed)
+ (NSMutableAttributedString *)text:(NSMutableAttributedString *)str withPatter:(NSString *)pattern
{
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arr = [regex matchesInString:[str string] options:0 range:NSMakeRange(0, str.length)];
    NSString *sss = nil;
    
    for (NSTextCheckingResult *b in arr) {
        sss = [[str string] substringWithRange:b.range];
        [str addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:b.range];
        if ([pattern isEqualToString:AT_IN_WEIBO_EXPRESSION]) {
            [str addAttributes:@{NSLinkAttributeName:@"userName"} range:b.range];
        }else if ([pattern isEqualToString:TOPIC_IN_WEIBO_EXPRESSION]){
            [str addAttributes:@{NSLinkAttributeName:@"topic"} range:b.range];
        }else {
            [str addAttributes:@{NSLinkAttributeName:sss} range:b.range];
        }
        
    }
    //设置字体
    [str addAttributes:@{NSFontAttributeName:CellFont} range:NSMakeRange(0, str.length)];
    return str;
}
+ (NSMutableAttributedString *)changeTextAttributed:(NSString *) text
{
    if (!text) {
        return nil;
    }
    NSArray *expressions = [NSArray arrayWithObjects:AT_IN_WEIBO_EXPRESSION,URL_EXPRESSION,TOPIC_IN_WEIBO_EXPRESSION, nil];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]initWithString:text];
    result = [[NSMutableAttributedString alloc]initWithAttributedString: [[TextAndImageTool alloc] getAttributeStringByStr:text andFontSize:20]];
    for (NSString *str in expressions) {

        result = [self text:result withPatter:str];
    }
    
    return result;
}
@end
