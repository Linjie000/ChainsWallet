//
//  SCShareWalletView.h
//  ShainChainW
//
//  Created by 闪链 on 2019/8/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "BSJNewsModel.h"
#import "BSJSearchModel.h"
@protocol SCShareWalletViewDelegate <NSObject>
- (void)SCShareWalletViewClick:(NSInteger)tag;
@end

@interface SCShareWalletView : UIView
+ (instancetype)shareInstance;
@property (nonatomic, strong) BSJButtomsModel *model;
@property (nonatomic, strong) BSJSearchExpressModel *searchModel;
@property (weak, nonatomic) id<SCShareWalletViewDelegate> delegate;
@property (strong, nonatomic) UIImageView *shareViewImg;
@end
