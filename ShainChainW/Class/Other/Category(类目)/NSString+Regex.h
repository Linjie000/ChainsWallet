//
//  NSString+Regex.h
//  RegexTest
//
//  Created by ZongmingYin on 16/8/26.
//  Copyright © 2016年 ZongmingYin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)
/**邮箱验证*/
+ (BOOL)validateEmail:(NSString *)email;

/**手机号码验证*/
+ (BOOL)validateMobile:(NSString *)mobile;

/**QQ号*/
+ (BOOL)validQQNumber:(NSString *)textString;

/**中文字符(2-6位)*/
+ (BOOL)validChinsesStr:(NSString *)textString;

/**银行卡号验证(LUHM算法)*/
+ (BOOL)validateBankCardNo:(NSString *)cardNo;

/**验证英文字符*/
+ (BOOL)validateEnglishString:(NSString *)textString;

/**由数字和英文字母组成的字符串*/
+ (BOOL)validateStringCombineNumberWithEnChar:(NSString *)textString;

/**微信帐号支持6-20个字母、数字、下划线和减号，必须以字母开头。例如：“weixin”、“qq_123”、“qq-123”*/
+ (BOOL)validateWechatAccountWithString:(NSString *)accountStr;

-(NSString *) sha256;

@end
