//
//  UILabel+Tap.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "UILabel+Tap.h"
#import <objc/runtime.h>
/**
 *  动态添加手势
 */
static const char *ActionHandlerTapGestureKey2;

@implementation UILabel (Tap)

- (void)setTapActionWithBlock:(void (^)(void))block {
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &ActionHandlerTapGestureKey2);
    
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &ActionHandlerTapGestureKey2, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &ActionHandlerTapGestureKey2, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized)  {
        void(^action)(void) = objc_getAssociatedObject(self, &ActionHandlerTapGestureKey2);
        if (action)  {
            action();
        }
    }
}
@end
