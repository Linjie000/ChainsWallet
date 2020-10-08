//
//  DappWithoutPasswordView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DappWithoutPasswordViewDelegate <NSObject>

- (void)dappWithoutPasswordViewBackgroundViewDidClick;

- (void)dappWithoutPasswordViewCancleDidClick;
- (void)dappWithoutPasswordViewConfirmBtnDidClick;
@end

@interface DappWithoutPasswordView : UIView
@property(nonatomic, weak) id<DappWithoutPasswordViewDelegate> delegate;
@property (weak, nonatomic) UITextField *passwordTF;

@property (weak, nonatomic) UIButton *savePasswordBtn;


@end
NS_ASSUME_NONNULL_END
