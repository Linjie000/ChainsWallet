//
//  SCReplacePicView.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/8.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCReplacePicView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SCReplacePicViewDelegate <NSObject>

@optional
- (void)SCReplacePicImage:(NSString *)imgName;

@end

@interface SCReplacePicView : UIView
@property(weak, nonatomic) id<SCReplacePicViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
