//
//  SCNewsLayout.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/4.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kTitleFontSize 15
#define kDetailFontSize 14
#define kTitleLeftPadding 40
#define kTitleRightPadding 15
#define kT1ContentWidth (SCREEN_WIDTH-kTitleLeftPadding-kTitleRightPadding)

@interface SCNewsLayout : NSObject
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
@end

NS_ASSUME_NONNULL_END
