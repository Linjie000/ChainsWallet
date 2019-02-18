//
//  TextAndImageTool.m
//  UBmercenary
//
//  Created by 林衍杰 on 2017/5/18.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import "TextAndImageTool.h"

@implementation TextAndImageTool
-(NSAttributedString *)getAttributeStringByStr:(NSString *)str withInfoNameArr:(NSArray *)nameArr andFontSize:(CGFloat)fontSize
{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:str attributes:dic];
    
    //正则表达式匹配[/*]
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    //匹配获取获取源字符串中的表情名在源字符串str中的字符范围如：［微笑］的字符范围 在字符串中@"我爱［微笑］" 的字符范围为［3，4］
    NSArray *resultArray = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    //新建数组用于储存表情
    NSMutableArray *imageArr = [[NSMutableArray alloc]initWithCapacity:resultArray.count];
    //找到相应的图片，并把图片转化为字符串
    for (NSTextCheckingResult *cr in resultArray) {
        NSRange range = [cr range];
        NSString *nameStr = [str substringWithRange:range];
        for (NSDictionary *items in nameArr) {
            if ([[items objectForKey:@"chs"] isEqualToString:nameStr]) {
                NSString *imageName = [items objectForKey:@"png"];
                UIImage *image = [UIImage imageNamed:imageName];
                NSAttributedString *imageStr = [self getStrByImage:image andFontSize: fontSize];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:imageStr,@"image",[NSValue valueWithRange:range],@"range", nil];
                [imageArr addObject:dic];
            }
        }
    }
    //用图片字符串替换源字符串中的表情文字(必需从后向前替换，否则range会不正确)
//    for (int i = (int)imageArr.count - 1 ; i >= 0 ; i-- ) {
//        NSRange range = [[imageArr[i] objectForKey:@"range"] rangeValue];
//        [attributeString replaceCharactersInRange:range withAttributedString:[imageArr[i] objectForKey:@"image"]];
//    }
    return attributeString;
}


-(NSAttributedString *)getAttributeStringByStr:(NSString *)str andFontSize:(CGFloat)fontSize
{
    return [self getAttributeStringByStr:str withInfoNameArr:[self getDefualtDataArr] andFontSize:fontSize];
}


-(NSAttributedString *)getStrByImage:(UIImage *)image andFontSize:(CGFloat)fontSize
{
    NSTextAttachment *textAttachMent = [[NSTextAttachment alloc]init];
    textAttachMent.image = image;
    textAttachMent.bounds = CGRectMake(0, 0, fontSize + 2, fontSize+ 2);
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachMent];
    return imageStr ;
    
}
-(NSArray *)getDefualtDataArr
{
    NSDictionary *rootDic1 = [self getRootDicByFlieName:@"emoticon_default"];
    NSDictionary *rootDic2 = [self getRootDicByFlieName:@"emoticon_lxh"];
    NSArray *nameArr1 = [rootDic1 objectForKey:@"emoticons"];
    NSArray *nameArr2 = [rootDic2 objectForKey:@"emoticons"];
    NSArray *arr = [nameArr1 arrayByAddingObjectsFromArray:nameArr2];
    return arr;
}
-(NSDictionary *)getRootDicByFlieName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *rootDic = [[NSDictionary alloc]initWithContentsOfFile:path];
    return rootDic;
}
@end
