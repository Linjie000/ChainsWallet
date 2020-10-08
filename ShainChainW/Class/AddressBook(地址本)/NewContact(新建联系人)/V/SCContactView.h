//
//  SCContactView.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomPlaceHolderTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCContactView : UIView
@property(nonatomic) ADDRESS_TYPE_STRING contaceType;
@property (nonatomic, weak) SCCustomPlaceHolderTextView *placeHolderTextView;
@property (nonatomic, copy) void(^HidenBlock)(void);
@end

NS_ASSUME_NONNULL_END
