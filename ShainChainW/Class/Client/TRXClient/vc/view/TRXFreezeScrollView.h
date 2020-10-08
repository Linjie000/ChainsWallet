//
//  TRXFreezeScrollView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TRXFreezeScrollViewDelegaet <NSObject>

- (void)TRXFreezeScrollViewFreeze:(NSInteger)trxCount freezeType:(NSInteger)type;
- (void)TRXFreezeScrollViewUnFreezeType:(NSInteger)type;

@end

@interface TRXFreezeScrollView : UIView
@property(strong, nonatomic) UIScrollView *freezeScrollView;
@property(strong, nonatomic) UILabel *usedResourceLab;
@property(strong, nonatomic) UILabel *coinNameLab;
@property(weak, nonatomic) id<TRXFreezeScrollViewDelegaet> delegate;
@end

NS_ASSUME_NONNULL_END
