//
//  RewardHelper.h
//  UBmercenary
//
//  Created by 林衍杰 on 2017/5/19.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

@interface RewardHelper : NSObject

/// Image resource bundle
+ (NSBundle *)bundle;

/// Image cache
+ (YYMemoryCache *)imageCache;

/// Get image from bundle with cache.
+ (UIImage *)imageNamed:(NSString *)name;

/// Convert date to friendly description.
+ (NSString *)stringWithTimelineDate:(NSDate *)date;

/// Convert number to friendly description.
+ (NSString *)shortedNumberDesc:(NSUInteger)number;

+(void)addjustISO11:(UIScrollView *)scrollview;

+ (UIViewController *)viewControllerWithView:(UIView *)view;

+(void)showTextWithHUD:(NSString *)string;

+(UIView *)addLine;
+(UIView *)addLine2;

+(CGFloat)textHeight:(NSString *)cmtText  width:(CGFloat)textwidth  font:(UIFont *)fonts;
+(CGRect)textRect:(NSString *)cmtText  width:(CGFloat)textwidth  font:(UIFont *)fonts;
//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp;
//时间戳转时间字符串  yyyy-MM-dd
+ (NSString *)formattWithData:(NSInteger)time;
//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)aStr;
@end
