//
//  TWTopScrollView.h
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , TWTopScrollViewType) {
    TWTopScrollViewTypeDefault = 0,
    TWTopScrollViewTypeEqualWidth = 1,
};

@interface TWTopScrollView : UIView

@property(nonatomic , copy) void (^chooseBlock)(NSInteger index, NSInteger lastIndex);

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items type:(TWTopScrollViewType)type;

-(void)scrollToShow:(NSInteger)index;

@end
