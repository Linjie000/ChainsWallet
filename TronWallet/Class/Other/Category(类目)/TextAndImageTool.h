//
//  TextAndImageTool.h
//  UBmercenary
//
//  Created by 林衍杰 on 2017/5/18.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextAndImageTool : NSObject
-(NSAttributedString *)getAttributeStringByStr:(NSString *)str withInfoNameArr:(NSArray *)nameArr andFontSize:(CGFloat)fontSize;
-(NSAttributedString *)getStrByImage:(UIImage *)image andFontSize:(CGFloat)fontSize;
-(NSAttributedString *)getAttributeStringByStr:(NSString *)str andFontSize:(CGFloat)fontSize;
@end
