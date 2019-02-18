//
//  UIBarButtonItem+SetUpBarButtonItem.h
//  ZQMicroBlog
//
//  Created by Jimmy on 15/11/25.
//  Copyright (c) 2015年 Cooperation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SetUpBarButtonItem)
+ (UIBarButtonItem *)barButtonWithImage:(NSString *)image highligthedImage:(NSString *)highImage selector:(SEL)selector target:(id)target;
@end
