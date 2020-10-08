//
//  EOSPermissionsView.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSPermissionsView : UIView
@property (strong, nonatomic) UILabel *roleLab;
@property (strong, nonatomic) UILabel *public_keyLab;
@property (strong, nonatomic) UILabel *weightLab;
@property (strong, nonatomic) UILabel *thresholdLab;
@property (strong, nonatomic) Permissions *permissions;
@end

NS_ASSUME_NONNULL_END
