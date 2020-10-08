//
//  SCOurNewsLayout.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/5.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN
#define kTitleFontSize 15
#define kTimeFontSize 14
#define kDetailFontSize 14

#define kTitleLeftPadding 15
#define kTitleTopPadding 14
#define kTimeTopPadding 6
#define kDetailTopPadding 15
#define kDetailBottomPadding 15
#define kT1ContentWidth (SCREEN_WIDTH-2*kTitleLeftPadding)

@interface SCOurNewsLayout : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) YYTextLayout *titleLayout;
@property (nonatomic, strong) YYTextLayout *timeLayout;
@property (nonatomic, strong) YYTextLayout *detailLayout;
- (instancetype)initWithModel:(NewsModel *)model;
@end

NS_ASSUME_NONNULL_END
