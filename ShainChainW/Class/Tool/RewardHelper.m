//
//  RewardHelper.m
//  UBmercenary
//
//  Created by 林衍杰 on 2017/5/19.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import "RewardHelper.h"
#import "BTCBase58.h"
#import "Sha256.h"
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

- (NSString *)getNowTimeTimestamp{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
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

+ (NSString *)getNowTimeTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0]; 
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
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
    if (IsNilOrNull(cmtText)) {
        return CGRectZero;
    }
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

+ (void)shareSomthingImg:(UIImage *)img controller:(UIViewController *)contro
{
    NSString *shareText = LocalizedString(@"收款二维码") ;
    UIImage *shareImage = img;
    NSArray *activityItems = [[NSArray alloc] initWithObjects:shareText, shareImage, nil];
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        SCLog(@"%@",activityType);
        if (completed) {
            SCLog(@"分享成功");
        } else {
            SCLog(@"分享失败");
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    vc.completionWithItemsHandler = myBlock;
    
    [contro presentViewController:vc animated:YES completion:nil];
}

+ (void)copyToPastboard:(NSString *)str
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = str;
    [TKCommonTools showToast:LocalizedString(@"已复制到粘贴板")];
}

//是否trx地址格式
+ (BOOL)isTronAddress:(NSString *)str
{
    if ([str isEqualToString:@""]||!str) {
        return NO;
    }
    if (str.length==34&& [str hasPrefix:@"T"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isATOMAddress:(NSString *)str
{
    if (IsStrEmpty(str)) {
        return NO;
    }
    if (str.length!=45) {
        return NO;
    }
    if ([[str.lowercaseString substringToIndex:7] isEqualToString:@"cosmos1"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isBTCAddress:(NSString *)str
{
    NSMutableData *c = BTCDataFromBase58(str);
    NSData *e1 = [c subdataWithRange:NSMakeRange(c.length-4, 4)];
    NSData *e2 = [c subdataWithRange:NSMakeRange(0, c.length-4)];
    Sha256 *s1 = [[Sha256 alloc]initWithData:e2];
    Sha256 *s2 = [[Sha256 alloc]initWithData:s1.mHashBytesData];
    NSData *result = [s2.mHashBytesData subdataWithRange:NSMakeRange(0, 4)];
    if ([result isEqualToData:e1]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isETHAddress:(NSString *)str
{
//    第一步,先判断地址非空和是否0x开头
    if (IsStrEmpty(str)||![str hasPrefix:@"0x"]) {
        return NO;
    }
    NSString *newstr = [str stringByReplacingOccurrencesOfString:@"0x" withString:@""];
//   判断是否长度是40位（去掉0x）
    if (newstr.length==40) {
        return YES;
    }
    return NO;
}

//+ (ADDRESS_TYPE_STRING)isAddressTye:(NSString *)address
//{
//
//}

+ (NSString *)delectLastZero:(NSString *)string
{
    //找出 .
    NSRange pointRange = NSMakeRange(0, 0);
    NSInteger length = 4;
    if ([string containsString:@"."]) {
        pointRange = [string rangeOfString:@"."];
        length = 5;
    }
    
    while([string hasSuffix:@"0"]) {
        if (string.length<=length+pointRange.location) {
            break;
        }
        NSRange range = NSMakeRange(string.length-1, 1);
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return string;
}

+ (NSString *)coinNameWithCoinNumber:(NSNumber *)coinNumber
{
    if ([coinNumber isEqualToNumber:@(195)]) {
        return @"Tron";
    }
    if ([coinNumber isEqualToNumber:@(60)]) {
        return @"ETH";
    }
    if ([coinNumber isEqualToNumber:@(0)]) {
        return @"BTC";
    }
    if ([coinNumber isEqualToNumber:@(194)]) {
        return @"EOS";
    }
    if ([coinNumber isEqualToNumber:@(291)]) {
        return @"IOST";
    }
    if ([coinNumber isEqualToNumber:@(118)]) {
        return @"ATOM";
    }
    return @"";
}

+ (NSNumber *)coinNumberWithCoinName:(NSString *)coinName
{
    if ([coinName isEqualToString:@"Tron"]) {
        return @(195);
    }
    if ([coinName isEqualToString:@"ETH"]) {
        return @(60);
    }
    if ([coinName isEqualToString:@"BTC"]) {
        return @(0);
    }
    if ([coinName isEqualToString:@"EOS"]) {
        return @(194);
    }
    if ([coinName isEqualToString:@"IOST"]) {
        return @(291);
    }
    if ([coinName isEqualToString:@"ATOM"]) {
        return @(118);
    }
    return @(0);
}

+ (ADDRESS_TYPE_STRING)typeNamecoin:(NSString *)coinName
{
    if ([coinName isEqualToString:@"BTC"]) {
        return ADDRESS_TYPE_STRING_BTC;
    }
    if ([coinName isEqualToString:@"ETH"]) {
        return ADDRESS_TYPE_STRING_ETH;
    }
    if ([coinName isEqualToString:@"EOS"]) {
        return ADDRESS_TYPE_STRING_EOS;
    }
    if ([coinName isEqualToString:@"Tron"]) {
        return ADDRESS_TYPE_STRING_TRON;
    }
    if ([coinName isEqualToString:@"IOST"]) {
        return ADDRESS_TYPE_STRING_IOST;
    }
    if ([coinName isEqualToString:@"ATOM"]) {
        return ADDRESS_TYPE_STRING_ATOM;
    }
    return ADDRESS_TYPE_STRING_ALL;
}


+ (void)getColorHexWithWalletID:(NSNumber *)number handle:(void(^)(NSString *colorHexString1, NSString *colorHexString2))completion
{
    NSString *_colorHexString1;
    NSString *_colorHexString2;
    if ([number isEqualToNumber:@(195)]) {
        _colorHexString1 = @"#3d1648";
        _colorHexString2 = @"#1e0d23";
    }
    if ([number isEqualToNumber:@(60)]) {
        _colorHexString1 = @"#42cbd0";
        _colorHexString2 = @"#6393ff";
    }
    if ([number isEqualToNumber:@(0)]) {
        _colorHexString1 = @"#fc8c32";
        _colorHexString2 = @"#fcae32";
    }
    if ([number isEqualToNumber:@(194)]||[number isEqualToNumber:@(291)]) {
        _colorHexString1 = @"#3d1648";
        _colorHexString2 = @"#1e0d23";
    }
    if ([number isEqualToNumber:@(118)]) {
        _colorHexString1 = @"#5C5C5C";
        _colorHexString2 = @"#3D3D3D";
    }
    completion(_colorHexString1,_colorHexString2);
}

+ (NSDictionary *)clearEmptyObject:(NSDictionary *)dic{
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionaryWithDictionary: dic];
    for(id key in [newDictionary allKeys]){
        id value = [newDictionary objectForKey: key];
        if([value isKindOfClass: [NSNull class]]){
            [newDictionary removeObjectForKey: key];
        }
        if([value isKindOfClass: [NSString class]]){
            if(IsStrEmpty(value)){
                [newDictionary removeObjectForKey: key];
            }
        }
        if([value isKindOfClass: [NSArray class]] || [value isKindOfClass: [NSMutableArray class]]){
            if([value count] == 0){
                [newDictionary removeObjectForKey: key];
            }
        }
        if([value isKindOfClass: [NSSet class]] || [value isKindOfClass: [NSMutableSet class]]){
            if([value count] == 0){
                [newDictionary removeObjectForKey: key];
            }
        }
    }
    return newDictionary;
}

+(NSString *)changeStringToDate:(NSString *)string {
    
    //带有T和Z的时间格式，是前端没有处理包含时区的，强转后少了8个小时，date是又少了8个小时，所有要加16个小时。
    
    NSString *str =[string stringByReplacingOccurrencesOfString:@"T"withString:@" "];
    
    NSString *sss =[str substringToIndex:19];
    
//    NSString *str1 =[sss stringByReplacingOccurrencesOfString:@".000" withString:@""];
    
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    
    [dateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [dateFromatter setTimeZone:timeZone];
    
    NSDate *date = [dateFromatter dateFromString:sss];
    
    NSDate *newdate = [[NSDate date] initWithTimeInterval:8 * 60 * 60 sinceDate:date];//
    
    NSDate *newdate1 = [[NSDate date] initWithTimeInterval:8 * 60 * 60 sinceDate:newdate];
    
    NSString *newstr =[NSString stringWithFormat:@"%@",newdate1];
    //为了适应 tron它们时间戳
    NSInteger timestamp = [self timeSwitchTimestamp:[newstr substringToIndex:19] andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    return [newstr substringToIndex:19];
    
}

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}

@end

