//
//  UIView+Layer.h
//  UBmercenary
//
//  Created by 林衍杰 on 2017/7/4.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layer)

- (void)setLayerCornerRadius:(CGFloat)cornerRadius
                 borderWidth:(CGFloat)borderWidth
                 borderColor:(UIColor *)borderColor;


/**
 *  边角半径
 */
@property (nonatomic, assign) CGFloat layerCornerRadius;
/**
 *  边线宽度
 */
@property (nonatomic, assign) CGFloat layerBorderWidth;
/**
 *  边线颜色
 */
@property (nonatomic, strong) UIColor *layerBorderColor;
@end
