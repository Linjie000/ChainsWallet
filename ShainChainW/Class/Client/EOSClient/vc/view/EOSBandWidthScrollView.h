//
//  EOSBandWidthScrollView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EOSBandWidthScrollViewDelegaet <NSObject>

- (void)EOSBandWidthScrollViewNet:(CGFloat)count Cpu:(CGFloat)cpu freezeType:(NSInteger)type;

@end

@interface EOSBandWidthScrollView : UIView
@property(strong, nonatomic) UIScrollView *freezeScrollView;
@property(strong, nonatomic) UILabel *usedResourceLab;
@property(strong, nonatomic) UILabel *coinNameLab;
@property(strong, nonatomic) UILabel *priceLab;
@property(weak, nonatomic) id<EOSBandWidthScrollViewDelegaet> delegate;
@property(assign, nonatomic) NSInteger type; //0买1卖
@property(strong, nonatomic) EOSAccount *eosAccount;
@end

NS_ASSUME_NONNULL_END
