//
//  SCTransferFootView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCTransferFootView : UIView
@property(strong, nonatomic) UISlider *slider;
@property(strong, nonatomic) UILabel *sliderValue;

@property(strong, nonatomic) UITextField *gaweiField;
@property(strong, nonatomic) UITextField *gasField;
@end

NS_ASSUME_NONNULL_END
