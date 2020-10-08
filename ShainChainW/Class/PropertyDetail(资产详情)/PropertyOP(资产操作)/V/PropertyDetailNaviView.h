//
//  PropertyDetailNaviView.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PropertyDetailNaviViewDelegate <NSObject>

-(void)SCCustomHeadViewBackBtnAction;
-(void)SCCustomHeadViewRightBtnAction;
@end

@interface PropertyDetailNaviView : UIView
@property(strong, nonatomic) UIImageView *leftBtnImg;
@property(strong, nonatomic) UIImageView *coinImg;
@property(strong, nonatomic) UILabel *titleLab;
@property(strong, nonatomic) UILabel *rightTitleLab;

@property(weak, nonatomic) id<PropertyDetailNaviViewDelegate> deleagte;

@end

NS_ASSUME_NONNULL_END
