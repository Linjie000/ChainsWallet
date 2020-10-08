//
//  UIFont+ADFont.m
//  UBmercenary
//
//  Created by 林衍杰 on 2018/4/16.
//  Copyright © 2018年 林衍杰. All rights reserved.
//

#import "UIFont+ADFont.h"

@implementation UIFont (ADFont)

+ (UIFont *)adjustFontSize:(CGFloat)fontSize {
    
    
    if ([UIScreen mainScreen].bounds.size.width > 375) {
        fontSize = fontSize + 0.8;
    }else if ([UIScreen mainScreen].bounds.size.width == 375){
        fontSize = fontSize;
    }else if ([UIScreen mainScreen].bounds.size.width == 320){
        fontSize = fontSize - 0.3;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

+ (UIFont *)adjustFontSize:(CGFloat)fontSize withName:(NSString *)fontName {
    
    if ([UIScreen mainScreen].bounds.size.width > 375) {
        fontSize = fontSize + 0.5;
    }else if ([UIScreen mainScreen].bounds.size.width == 375){
        fontSize = fontSize;
    }else if ([UIScreen mainScreen].bounds.size.width == 320){
        fontSize = fontSize - 0.5;
    }  
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    return font;
}


@end
