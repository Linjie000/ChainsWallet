//
//  SCChooseWalletView.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCChooseWalletViewDelegate <NSObject>

- (void)SCChooseWalletViewSelectWallet:(walletModel *)walletModel;

@end

@interface SCChooseWalletView : UIView
+ (instancetype)shareInstance;
- (void)hide;
@property (weak, nonatomic) id<SCChooseWalletViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
