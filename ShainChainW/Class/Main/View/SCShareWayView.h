//
//  SCShareWayView.h
//  ShainChainW
//
//  Created by 闪链 on 2019/8/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCShareWayViewDelegate <NSObject>

- (void)SCShareWayViewClick:(NSInteger)tag;

@end

@interface SCShareWayView : UIView
@property (weak, nonatomic) id<SCShareWayViewDelegate> delegate;
@end

