//
//  EOSRAMScrollView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EOSRAMScrollViewDelegaet <NSObject>

- (void)EOSRAMScrollViewFreeze:(CGFloat)Count freezeType:(NSInteger)type; 

@end

@interface EOSRAMScrollView : UIView
@property(strong, nonatomic) UIScrollView *freezeScrollView;
@property(strong, nonatomic) UILabel *usedResourceLab;
@property(strong, nonatomic) UILabel *coinNameLab;
@property(strong, nonatomic) UILabel *priceLab;
@property(strong, nonatomic) UIView *freezeView;
@property(strong, nonatomic) UITextField *freezeTf;
@property(strong, nonatomic) UIButton *confirm;
@property(assign, nonatomic) NSInteger untype;
@property(weak, nonatomic) id<EOSRAMScrollViewDelegaet> delegate;
@property(assign, nonatomic) NSInteger type; //0买1卖
@end

NS_ASSUME_NONNULL_END
