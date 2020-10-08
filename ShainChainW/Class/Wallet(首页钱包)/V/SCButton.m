//
//  SCButton.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCButton.h"

@interface SCButton ()
 
@end
@implementation SCButton

+(instancetype)buttonWithType:(UIButtonType)buttonType{
    SCButton *ccButton = [super buttonWithType:buttonType];
    if (ccButton) {
        ccButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        ccButton.titleLabel.font = kPFFont(14);
    }
    return ccButton;
}

//重设image的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat selfh = self.height;
    CGFloat imgh = self.frame.size.height-26;
    CGFloat y = (selfh-imgh)/2;
    return CGRectMake(40,y,imgh , imgh);
}

//重设title的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat selfh = self.height;
    CGFloat imgh = self.frame.size.height-22;
    return CGRectMake(40+imgh+13,0,100 , selfh);
}


@end
