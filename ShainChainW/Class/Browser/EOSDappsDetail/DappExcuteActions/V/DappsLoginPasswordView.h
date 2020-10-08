//
//  DappsLoginPasswordView.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DappsLoginPasswordViewDelegate<NSObject>
- (void)cancleBtnDidClick:(UIButton *)sender;
- (void)confirmBtnDidClick:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_BEGIN

@interface DappsLoginPasswordView : NSObject
@property(nonatomic, weak) id<DappsLoginPasswordViewDelegate> delegate;
@property (strong, nonatomic) UITextField *inputPasswordTF;
@end

NS_ASSUME_NONNULL_END
