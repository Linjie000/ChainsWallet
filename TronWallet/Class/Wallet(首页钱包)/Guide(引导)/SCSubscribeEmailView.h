//
//  SCSubscribeEmailView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/23.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCEditNameTextField.h"
#import "SCCustomPlaceHolderTextView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapBlock)(NSString *str);

@interface SCSubscribeEmailView : UIView

@property(assign, nonatomic) BOOL showBgView;

@property(strong, nonatomic) SCEditNameTextField *emailTF;
@property(strong, nonatomic) SCCustomPlaceHolderTextView *detailTV;
@property(copy, nonatomic) TapBlock block;
@end

NS_ASSUME_NONNULL_END
