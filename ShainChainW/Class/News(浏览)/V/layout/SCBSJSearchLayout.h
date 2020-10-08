//
//  SCBSJSearchLayout.h
//  ShainChainW
//
//  Created by 闪链 on 2019/7/31.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSJSearchModel.h"

#define kTitleFontSize 15
#define kDetailFontSize 14
#define kTitleLeftPadding 40
#define kTitleRightPadding 15
#define kT1ContentWidth (SCREEN_WIDTH-kTitleLeftPadding-kTitleRightPadding)

@interface SCBSJSearchLayout : NSObject
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat topViewHeight;  //顶部高度

@property (nonatomic, assign) CGFloat bottomViewHeight;  //底部高度

@property (nonatomic, assign) CGFloat titlePadding;
@property (nonatomic, strong) NSMutableAttributedString *detailText;
@property (nonatomic, strong) YYTextLayout *titleLayout;
@property (nonatomic, strong) YYTextLayout *detailLayout;

@property (nonatomic, assign) BOOL userLike;
@property (nonatomic, assign) BOOL userNotLike;
@property (nonatomic, assign) NSInteger userLikeCount;
@property (nonatomic, assign) NSInteger userNotLikeCount;

- (instancetype)initWithModel:(BSJSearchExpressModel *)model heightLightText:(NSString *)text;
@property (nonatomic, strong) BSJSearchExpressModel *model;
@property (nonatomic, strong) NSString *heightLightText;
@end
