//
//  RecommendDappModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BannerDapps;
@class IntroDapps;
@class StarDapps;
NS_ASSUME_NONNULL_BEGIN

@interface RecommendDappModel : NSObject
@property(strong, nonatomic) NSArray *bannerDapps;
@property(strong, nonatomic) NSArray *introDapps;
@property(strong, nonatomic) NSArray *starDapps;
@end

@interface BannerDapps : NSObject

@property(strong, nonatomic) NSString *dappid;
@property(strong, nonatomic) NSString *dappName;
@property(strong, nonatomic) NSString *dappIntro;
@property(strong, nonatomic) NSString *dappIcon;
@property(strong, nonatomic) NSString *dappImage;
@property(strong, nonatomic) NSString *dappPicture;
@property(strong, nonatomic) NSString *dappUrl;
@property(strong, nonatomic) NSString *status;
@property(strong, nonatomic) NSString *isScatter;
@property(strong, nonatomic) NSString *chainType;
@property(strong, nonatomic) NSString *createTime;
@property(strong, nonatomic) NSString *updateTime;
@property(strong, nonatomic) NSString *weight;
@property(strong, nonatomic) NSString *introReason;
@property(strong, nonatomic) NSString *isBanner;
@property(strong, nonatomic) NSString *isIntro;
@property(strong, nonatomic) NSString *isStarDapp;
@property(strong, nonatomic) NSString *dappCategoryName;
@property(strong, nonatomic) NSString *textColor;
@property(strong, nonatomic) NSString *tagColor;

@end

@interface IntroDapps : NSObject

@property(strong, nonatomic) NSString *dappid;
@property(strong, nonatomic) NSString *dappName;
@property(strong, nonatomic) NSString *dappIntro;
@property(strong, nonatomic) NSString *dappIcon;
@property(strong, nonatomic) NSString *dappImage;
@property(strong, nonatomic) NSString *dappPicture;
@property(strong, nonatomic) NSString *dappUrl;
@property(strong, nonatomic) NSString *status;
@property(strong, nonatomic) NSString *isScatter;
@property(strong, nonatomic) NSString *chainType;
@property(strong, nonatomic) NSString *createTime;
@property(strong, nonatomic) NSString *updateTime;
@property(strong, nonatomic) NSString *weight;
@property(strong, nonatomic) NSString *introReason;
@property(strong, nonatomic) NSString *isBanner;
@property(strong, nonatomic) NSString *isIntro;
@property(strong, nonatomic) NSString *isStarDapp;
@property(strong, nonatomic) NSString *dappCategoryName;
@property(strong, nonatomic) NSString *textColor;
@property(strong, nonatomic) NSString *tagColor;

@end

@interface StarDapps : NSObject

@end

NS_ASSUME_NONNULL_END
