//
//  RewardHelper.h
//  UBmercenary
//
//  Created by 林衍杰 on 2017/5/19.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

typedef NS_ENUM(NSInteger,ADDRESS_TYPE_STRING) {
    ADDRESS_TYPE_STRING_ALL = 0,
    ADDRESS_TYPE_STRING_BTC,
    ADDRESS_TYPE_STRING_ETH,
    ADDRESS_TYPE_STRING_EOS,
    ADDRESS_TYPE_STRING_TRON,
    ADDRESS_TYPE_STRING_IOST,
    ADDRESS_TYPE_STRING_ATOM
};


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

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)aStr;
//删除字典中空值
+ (NSDictionary *)clearEmptyObject:(NSDictionary *)dic;
//分享
+ (void)shareSomthingImg:(UIImage *)img controller:(UIViewController *)contro;
//复制地址
+ (void)copyToPastboard:(NSString *)str;

+ (BOOL)isTronAddress:(NSString *)str;
+ (BOOL)isBTCAddress:(NSString *)str;
+ (BOOL)isETHAddress:(NSString *)str;
+ (BOOL)isATOMAddress:(NSString *)str;

+(NSString *)changeStringToDate:(NSString *)string;
//什么类型的地址
+ (ADDRESS_TYPE_STRING)isAddressTye:(NSString *)address;

//把最后的一些0删除
+ (NSString *)delectLastZero:(NSString *)string;

+ (NSString *)coinNameWithCoinNumber:(NSNumber *)coinNumber;
+ (NSNumber *)coinNumberWithCoinName:(NSString *)coinName;
+ (ADDRESS_TYPE_STRING)typeNamecoin:(NSString *)coinName;

+ (void)getColorHexWithWalletID:(NSNumber *)number handle:(void(^)(NSString *colorHexString1, NSString *colorHexString2))completion;
@end
