//
//  SCCustomPlaceHolderTextView.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//  输入框

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SCCustomPlaceHolderTextView;
@protocol SCCustomPlaceHolderTextViewDelegate <NSObject>
/** 文本改变回调*/
- (void)customPlaceHolderTextViewTextDidChange:(SCCustomPlaceHolderTextView *)textView;
@end

@interface SCCustomPlaceHolderTextView : UITextView
@property (nonatomic, weak) id <SCCustomPlaceHolderTextViewDelegate> del;
@property (nonatomic,copy) NSString *placehoder;
@property (nonatomic,strong) UIColor *placehoderColor;
@property (nonatomic, assign) CGFloat placeholderTopMargin;
@property (nonatomic, assign) CGFloat placeholderLeftMargin;
@property (nonatomic, strong) UIFont *placeholderFont;

@end

NS_ASSUME_NONNULL_END
