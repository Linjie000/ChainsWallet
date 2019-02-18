//
//  RewardHelper.m
//  UBmercenary
//
//  Created by 林衍杰 on 2017/5/19.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import "RewardHelper.h"

@implementation RewardHelper

+ (NSBundle *)bundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ResourceTwitter" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"TwitterImageCache";
    });
    return cache;
}

+ (UIImage *)imageNamed:(NSString *)name {
    if (!name) return nil;
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path = [[self bundle] pathForScaledResource:name ofType:ext];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    image = [image imageByDecoded];
    if (!image) return nil;
    [[self imageCache] setObject:image forKey:name];
    return image;
}

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* string=[dateFormat stringFromDate:[NSDate date]];
    
    return string;
    
}

+ (NSString *)stringWithTimelineDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatterFullDate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"M/d/yy"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // local time error
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60) {
        return [NSString stringWithFormat:@"%ds",(int)(delta)];
    } else if (delta < 60 * 60) {
        return [NSString stringWithFormat:@"%dm", (int)(delta / 60.0)];
    } else if (delta < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%dh", (int)(delta / 60.0 / 60.0)];
    } else if (delta < 60 * 60 * 24 * 7) {
        return [NSString stringWithFormat:@"%dd", (int)(delta / 60.0 / 60.0 / 24.0)];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

+ (NSString *)shortedNumberDesc:(NSUInteger)number {
    if (number <= 999) return [NSString stringWithFormat:@"%d",(int)number];
    if (number <= 9999) return [NSString stringWithFormat:@"%d,%3.3d",(int)(number / 1000), (int)(number % 1000)];
    if (number < 1000 * 1000) return [NSString stringWithFormat:@"%.1fK", number / 1000.0];
    if (number < 1000 * 1000 * 1000) return [NSString stringWithFormat:@"%.1fM", number / 1000.0 / 1000.0];
    return [NSString stringWithFormat:@"%.1fB", number / 1000.0 / 1000.0 / 1000.0];
}

+(void)addjustISO11:(UIScrollView *)scrollview
{
    if (@available(iOS 11.0, *)) {
        scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        [RewardHelper viewControllerWithView:scrollview].automaticallyAdjustsScrollViewInsets = NO;
    }    
}

+ (UIViewController *)viewControllerWithView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark ------- UIView

+(UIView *)addLine
{
    UIView *line = [UIView new];
    line.height = 0.3;
    line.width = SCREEN_WIDTH;
    line.x = 0;
    line.backgroundColor = SCGray(240);
    return line;
}

+(UIView *)addLine2
{
    UIView *line = [UIView new];
    line.width = kScreenWidth;
    line.height = CGFloatFromPixel(1);
//    line.backgroundColor = [UIColor colorWithWhite:0.823 alpha:0.84];
    line.backgroundColor = SCGray(240);
    return line;
}

+(CGFloat)textHeight:(NSString *)cmtText  width:(CGFloat)textwidth  font:(UIFont *)fonts
{
    CGSize s = [cmtText boundingRectWithSize:CGSizeMake(textwidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : fonts} context:nil].size;
    return s.height;
}

+(CGRect)textRect:(NSString *)cmtText  width:(CGFloat)textwidth  font:(UIFont *)fonts
{
    return [cmtText boundingRectWithSize:CGSizeMake(textwidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : fonts} context:nil];
}

+(NSString *)formattWithData:(NSInteger)time
{
    NSDate *selected = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

+ (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}


@end

