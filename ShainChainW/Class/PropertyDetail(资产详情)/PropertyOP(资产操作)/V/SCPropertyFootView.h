//
//  SCPropertyFootView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , SCBUTTONTYPE) {
    SCBUTTONTYPE_Coll = 0 ,
    SCBUTTONTYPE_Tran ,
    SCBUTTONTYPE_Resource
};

NS_ASSUME_NONNULL_BEGIN
typedef void(^propertyBlock)(SCBUTTONTYPE tag);
@interface SCPropertyFootView : UIView
@property(strong, nonatomic) NSArray *colorArray;
@property(strong, nonatomic) UIView *footView;
@property(strong, nonatomic) NSArray *textArray;
@property(copy, nonatomic) propertyBlock block;
@end

NS_ASSUME_NONNULL_END
