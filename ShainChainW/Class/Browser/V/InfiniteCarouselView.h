//
//  BrowserHeadView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RecommendDappModel.h"

@interface InfiniteCarouselView : UIView

/**  RecommendDappModel 数组 */
@property (nonatomic, strong) NSArray *bannerDappsArray;

/** 自动滚动间隔时间,默认0.1s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 图片圆角大小 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 占位图 */
@property (nonatomic, copy) NSString *placeholder;

/** 监听点击 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/** 监听滚动 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);
/**  url string 信号 */
//@property (strong, nonatomic) RACSignal *imageURLSignal;

@end
