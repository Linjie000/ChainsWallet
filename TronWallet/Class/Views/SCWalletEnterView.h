//
//  SCWalletEnterView.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/8.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//  带输入的提示框

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *showText);
NS_ASSUME_NONNULL_BEGIN

@interface SCWalletEnterView : UIView
+ (instancetype)shareInstance;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *placeholderStr;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
@end

NS_ASSUME_NONNULL_END
