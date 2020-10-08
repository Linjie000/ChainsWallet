//
//  SCAccountHeadView.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/3.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCAccountHeadViewDelegate <NSObject>

@optional
- (void)SCAccountHeadViewClick:(NSInteger)tag;

@end

@interface SCAccountHeadView : UIView
@property(weak, nonatomic) id<SCAccountHeadViewDelegate> headViewDelegate;
@end

NS_ASSUME_NONNULL_END
