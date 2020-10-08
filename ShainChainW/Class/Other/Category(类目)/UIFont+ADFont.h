//
//  UIFont+ADFont.h
//  UBmercenary
//
//  Created by 林衍杰 on 2018/4/16.
//  Copyright © 2018年 林衍杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (ADFont)
+ (UIFont *)adjustFontSize:(CGFloat)fontSize;
+ (UIFont *)adjustBoldFontSize:(CGFloat)fontSize;
+ (UIFont *)adjustFontSize:(CGFloat)fontSize withName:(NSString *)fontName;
@end
