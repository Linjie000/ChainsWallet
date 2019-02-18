//
//  SCCustomHeadView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCCustomHeadViewDelegate <NSObject>

-(void)SCCustomHeadViewBackBtnAction;
-(void)SCCustomHeadViewRightBtnAction;
@end

@interface SCCustomHeadView : UIView
@property(strong, nonatomic) UIImageView *leftBtnImg;
@property(strong, nonatomic) UILabel *titleLab;
@property(strong, nonatomic) UILabel *rightTitleLab;

@property(weak, nonatomic) id<SCCustomHeadViewDelegate> deleagte;

@end


NS_ASSUME_NONNULL_END
