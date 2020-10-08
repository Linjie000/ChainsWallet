//
//  AccountAuthorizationView.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureForMessageModel.h"
#import "SCUnderLineTextField.h"
NS_ASSUME_NONNULL_BEGIN
@class AccountAuthorizationView;
@protocol AccountAuthorizationViewDelegate<NSObject>
- (void)accountAuthorizationViewConfirmBtnDidClick:(AccountAuthorizationView *)view;
@end

@interface AccountAuthorizationView : UIView
@property(nonatomic, weak) id<AccountAuthorizationViewDelegate> delegate;
@property(strong, nonatomic) SignatureForMessageModel *model;
@property(strong, nonatomic) SCUnderLineTextField *passwordtf;
@end

NS_ASSUME_NONNULL_END
