//
//  UIImage+Image.h
//  SmartHome
//  Created by mac on 16/3/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+ (instancetype)imageWithOriginalName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (instancetype)imageWithRed:(float)r green:(float)g blue:(float)b alphe:(float)a
{
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    CGSize size = CGSizeMake(100, 100);
    
    // 开启位图
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    [color set];
    UIRectFill(CGRectMake(0, 0, 100, 100));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageName:(NSString *)name imageDict:(NSDictionary *)imageDict
{
    __block NSString *imageName = nil;
    [imageDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  __nonnull obj, BOOL * __nonnull stop) {
        if ([name hasPrefix:key]) {
            imageName = imageDict[key];
            *stop = YES;
        }
    }];
    return [UIImage imageNamed:imageName];
}
@end
