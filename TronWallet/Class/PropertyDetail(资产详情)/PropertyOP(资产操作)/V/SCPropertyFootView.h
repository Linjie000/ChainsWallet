//
//  SCPropertyFootView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^propertyBlock)(NSInteger tag);
@interface SCPropertyFootView : UIView
@property(strong, nonatomic) UIView *footView;
@property(copy, nonatomic) propertyBlock block;
@end

NS_ASSUME_NONNULL_END
