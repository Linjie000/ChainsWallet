//
//  NSString+Regex.m
//  RegexTest
//
//  Created by ZongmingYin on 16/8/26.
//  Copyright © 2016年 ZongmingYin. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

/**邮箱验证*/
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**手机号码验证*/
+ (BOOL)validateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/**QQ号*/
+ (BOOL)validQQNumber:(NSString *)textString {
    NSString *qqNumber = @"^[1-9][0-9]\\d{4,9}";
    NSPredicate *qqNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qqNumber];
    return [qqNumberPredicate evaluateWithObject:textString];
}

/**中文字符(2-6位)*/
+ (BOOL)validChinsesStr:(NSString *)textString {
    NSString *chineseStr = @"[\u4e00-\u9fa5]{2,6}";
    NSPredicate *chinsesPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseStr];
    return [chinsesPredicate evaluateWithObject:textString];
}

/**银行卡号验证(LUHM算法)*/
+ (BOOL)validateBankCardNo:(NSString *)cardNo {
    
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];// 长度
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];//最后一位
    cardNo = [cardNo substringToIndex:cardNoLength - 1];//去掉最后一位剩下的
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];// 从倒数第二位开始
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {// 长度为奇数位
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

/**验证英文字符*/
+ (BOOL)validateEnglishString:(NSString *)textString {
    NSString *string = @"^[a-zA-Z]+$";
    NSPredicate *enStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",string];
    return [enStringPredicate evaluateWithObject:textString];
}

/**由数字和英文字母组成的字符串*/
+ (BOOL)validateStringCombineNumberWithEnChar:(NSString *)textString {
    NSString *combineStr = @"^[a-zA-Z0-9]+$";
    NSPredicate *combineStrPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineStr];
    return [combineStrPredicate evaluateWithObject:textString];
}

/**微信帐号支持6-20个字母、数字、下划线和减号，必须以字母开头。例如：“weixin”、“qq_123”、“qq-123”*/
+ (BOOL)validateWechatAccountWithString:(NSString *)accountStr{
    NSString *string = @"^[a-zA-Z][a-zA-A0-9_-]{5,19}";
    NSPredicate *accountStrPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",string];
    return [accountStrPredicate evaluateWithObject:accountStr];
}


@end
