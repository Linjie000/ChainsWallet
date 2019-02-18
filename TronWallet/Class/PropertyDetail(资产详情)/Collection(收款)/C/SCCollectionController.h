//
//  SCCollectionController.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomHeadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCollectionHeadView : UIView
@property(strong, nonatomic) CAGradientLayer *gradientLayer;//背景
@property(strong, nonatomic) UILabel *nameLab;
@property(strong, nonatomic) UILabel *addressLab;
@property(strong, nonatomic) UIImageView *qrcode; //二维码
@property(strong, nonatomic) YYControl *addressControl;
@property(strong, nonatomic) walletModel *wallet;
@end

@interface SCCollectionController : SCBaseViewController
@property(strong, nonatomic) UIImageView *headImg;
@property(strong, nonatomic) SCCollectionHeadView *collectionHeadView;
@end

NS_ASSUME_NONNULL_END
