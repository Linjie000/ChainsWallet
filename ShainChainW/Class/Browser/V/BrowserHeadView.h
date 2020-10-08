//
//  BrowserHeadView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendDappModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BrowserHeadViewDelegate <NSObject>
- (void)browserHeadViewDelegateBannerModel:(BannerDapps *)model;
- (void)browserHeadViewDelegateRecommendModel:(IntroDapps *)model;

@end

@interface BrowserHeadView : UIView
@property(strong, nonatomic) RecommendDappModel *model;
@property(weak ,nonatomic) id<BrowserHeadViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
