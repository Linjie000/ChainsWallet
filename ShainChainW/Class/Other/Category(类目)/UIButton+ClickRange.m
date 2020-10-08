
//
//  UIButton+ClickRange.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "UIButton+ClickRange.h"
#import "UIButton+ClickRange.h"
#import <objc/runtime.h>


static const char * kHitEdgeInsets = "hitEdgeInset";
static const char * kHitScale = "hitScale";
static const char * kHitWidthScale = "hitWidthScale";
static const char * kHitHeightScale = "hitWidthScale";

@implementation UIButton (ClickRange)

#pragma mark - set Method
-(void)setHitEdgeInsets:(UIEdgeInsets)hitEdgeInsets{
    NSValue *value = [NSValue value:&hitEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, kHitEdgeInsets, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setHitScale:(CGFloat)hitScale{
    CGFloat width = self.bounds.size.width * hitScale;
    CGFloat height = self.bounds.size.height * hitScale;
    self.hitEdgeInsets = UIEdgeInsetsMake(-height, -width,-height, -width);
    objc_setAssociatedObject(self, kHitScale, @(hitScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setHitWidthScale:(CGFloat)hitScale{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height * hitScale;
    self.hitEdgeInsets = UIEdgeInsetsMake(-height, -width, -height, -width);
    objc_setAssociatedObject(self, kHitScale, @(hitScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setHitHeightScale:(CGFloat)hitHeightScale{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height * hitHeightScale;
    self.hitEdgeInsets = UIEdgeInsetsMake(-height, -width, -height, -width);
    objc_setAssociatedObject(self, kHitHeightScale, @(kHitHeightScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - get method
-(UIEdgeInsets)hitEdgeInsets{
    NSValue *value = objc_getAssociatedObject(self, kHitEdgeInsets);
    UIEdgeInsets edgeInsets;
    [value getValue:&edgeInsets];
    return value ? edgeInsets:UIEdgeInsetsZero;
}

-(CGFloat)hitScale{
    return [objc_getAssociatedObject(self, kHitScale) floatValue];
}

-(CGFloat)hitWidthScale{
    return [objc_getAssociatedObject(self, kHitWidthScale) floatValue];
}

-(CGFloat)hitHeightScale{
    return [objc_getAssociatedObject(self, kHitHeightScale) floatValue];
}

#pragma mark - override super method
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //如果 button 边界值无变化  失效 隐藏 或者透明 直接返回
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden || self.alpha == 0 ) {
        return [super pointInside:point withEvent:event];
    }else{
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }
}

@end
