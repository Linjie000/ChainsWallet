//
//  RecommendDappModel.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "RecommendDappModel.h"

@implementation RecommendDappModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"bannerDapps":[BannerDapps class],
             @"introDapps":[IntroDapps class],
             @"starDapps":[StarDapps class]
             };
}

@end

@implementation BannerDapps
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"dappid" : @"id"
             };
}
@end

@implementation IntroDapps
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"dappid" : @"id"
             };
}
@end

@implementation StarDapps

@end

