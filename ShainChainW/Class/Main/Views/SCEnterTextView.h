//
//  SCEnterTextView.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/19.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock2)(NSString *showText);
typedef void (^CancleBlock2)();


@interface SCEnterTextView : UIView
+ (instancetype)shareInstance; 
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *placeholderStr;
@property (strong, nonatomic) UITextField *tf;
@property (nonatomic, copy) ReturnTextBlock2 returnTextBlock;
@property (nonatomic, copy) CancleBlock2 cancleBlock;
@end
