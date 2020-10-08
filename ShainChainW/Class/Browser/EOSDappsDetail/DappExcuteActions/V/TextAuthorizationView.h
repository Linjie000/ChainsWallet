//
//  TextAuthorizationView.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextAuthorizationView : UIView
@property(strong, nonatomic) NSString *leftStr;
@property(strong, nonatomic) NSString *rightStr;

@property(assign, nonatomic) CGFloat authorheight;
@property(copy, nonatomic) void(^backHeight)(CGFloat height);
@end

NS_ASSUME_NONNULL_END
