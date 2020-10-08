//
//  SCWalletTipView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/15.
//  Copyright © 2019 zaker_sink. All rights reserved.
//  纯文字提示

#import <UIKit/UIKit.h>

typedef void (^ReturnBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface SCWalletTipView : UIView
+ (instancetype)shareInstance;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detailStr;
@property (nonatomic, copy) ReturnBlock returnBlock;
@end

NS_ASSUME_NONNULL_END
