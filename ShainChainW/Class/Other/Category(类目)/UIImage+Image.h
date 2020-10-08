//
//  UIImage+Image.h
//  SmartHome
//  Created by mac on 16/3/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

/** 加载最原始的图片，没有渲染 */
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

/** 平铺图片 */
+ (instancetype)imageWithStretchableName:(NSString *)imageName;

/**
 *  根据颜色返回图片
 */
+ (instancetype)imageWithRed:(float)r green:(float)g blue:(float)b alphe:(float)a;
/**
 *  根据图片名称字典返回图片
 */
+ (UIImage *)imageName:(NSString *)name imageDict:(NSDictionary *)imageDict;
@end
