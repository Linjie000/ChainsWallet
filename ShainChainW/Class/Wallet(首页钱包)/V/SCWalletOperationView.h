//
//  SCWalletOperationView.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCWalletOperationViewDelegate <NSObject>

- (void)SCWalletOperationViewDelegateSelect:(NSInteger)tag;

@end

@interface SCWalletOperationView : UIView
@property(weak, nonatomic) id<SCWalletOperationViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
