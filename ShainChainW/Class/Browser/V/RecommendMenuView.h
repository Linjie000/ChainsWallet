//
//  RecommendMenuView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IntroDapps;
@interface RecommendMenuView : UIView
@property(strong, nonatomic) NSArray *introDappsArray;
@property(copy, nonatomic) void(^RecommendMenu)(IntroDapps *model);
@end

NS_ASSUME_NONNULL_END
