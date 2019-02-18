//
//  UIImageView+Tap.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/18.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "UIImageView+Tap.h"
#import <objc/runtime.h>
/**
 *  动态添加手势
 */
static const char *ActionHandlerTapGestureKey3;

@implementation UIImageView (Tap)

- (void)setTapActionWithBlock:(void (^)(void))block {
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &ActionHandlerTapGestureKey3);
    
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &ActionHandlerTapGestureKey3, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &ActionHandlerTapGestureKey3, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized)  {
        void(^action)(void) = objc_getAssociatedObject(self, &ActionHandlerTapGestureKey3);
        if (action)  {
            action();
        }
    }
}

@end
