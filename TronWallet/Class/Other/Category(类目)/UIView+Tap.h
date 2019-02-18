//
//  UIView+Tap.h
//  UBmercenary
//
//  Created by 林衍杰 on 2017/7/4.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tap)
/**
 *  动态添加手势
 */
- (void)setTapActionWithBlock:(void (^)(void))block ;
@end
