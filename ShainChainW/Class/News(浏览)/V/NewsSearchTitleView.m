//
//  NewsSearchTitleView.m
//  ShainChainW
//
//  Created by 闪链 on 2019/7/31.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "NewsSearchTitleView.h"

@implementation NewsSearchTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self __loadUI];
    }
    return self;
}

- (void)__loadUI {
    
    //将搜索条放在一个UIView上  uitextfield
    UITextField *searchView = [[UITextField alloc]initWithFrame:self.bounds];
    [searchView becomeFirstResponder ];
    searchView.font =[ UIFont systemFontOfSize:13.5]; 
    searchView.placeholder = LocalizedString(@"请输入关键词");
    searchView.layer.cornerRadius = 3.5;
    searchView.returnKeyType = UIReturnKeySearch; 
    searchView.tintColor = MainColor;
    self.searchView = searchView;
    [self addSubview:searchView];
}

- (CGSize)intrinsicContentSize{
    return UILayoutFittingExpandedSize;
}

@end
