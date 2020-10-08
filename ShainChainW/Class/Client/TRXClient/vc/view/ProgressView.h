//
//  ProgressView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressView : UIView

@property(strong, nonatomic) UIColor *usedColor;
@property(strong, nonatomic) UIColor *limitColor;

@property(strong, nonatomic) NSString *unit;//单位
@property(strong, nonatomic) NSString *left_unit;//左边单位
@property(assign, nonatomic) CGFloat usedCount;
@property(assign, nonatomic) CGFloat limitCount;

@property(assign, nonatomic) UILabel *usedTitleLab;
@property(assign, nonatomic) UILabel *limitTitleLab;

- (void)layout;

@end

NS_ASSUME_NONNULL_END
