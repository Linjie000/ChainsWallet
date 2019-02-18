//
//  UILabel+Tap.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Tap)
/**
 *  动态添加手势
 */
- (void)setTapActionWithBlock:(void (^)(void))block ;
@end

NS_ASSUME_NONNULL_END
