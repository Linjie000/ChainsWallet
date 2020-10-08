//
//  TextAuthorizationView.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TextAuthorizationView.h"

@interface TextAuthorizationView ()
@property(strong, nonatomic) UILabel *leftLab;
@property(strong, nonatomic) UILabel *rightLab;
@end

@implementation TextAuthorizationView

- (void)setLeftStr:(NSString *)leftStr
{
    _leftStr = leftStr;
    self.leftLab.text = leftStr;
}

- (void)setRightStr:(NSString *)rightStr
{
    _rightStr = rightStr;
    self.rightLab.text = rightStr;
    
    [self setNeedsDisplay];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self loadView];
        self.width = SCREEN_WIDTH;
    }
    return self;
}

- (UILabel *)leftLab
{
    if (!_leftLab) {
        _leftLab = [[UILabel alloc]init];
        _leftLab.width = 80;
        _leftLab.height = 40;
        _leftLab.x = 15;
        _leftLab.font = kFont(13);
        _leftLab.textColor = SCGray(128);
    }
    return _leftLab;
}

- (UILabel *)rightLab
{
    if (!_rightLab) {
        _rightLab = [[UILabel alloc]init];
        _rightLab.font = kFont(13);
        _rightLab.height = 40;
        _rightLab.numberOfLines = 0;
    }
    return _rightLab;
}


- (void)loadView
{
    [self addSubview:self.leftLab];
    [self addSubview:self.rightLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.rightLab.x = self.leftLab.right;
    self.rightLab.width = SCREEN_WIDTH - self.leftLab.right - 15;
    CGFloat h = [RewardHelper textRect:self.rightStr width:self.rightLab.width font:self.rightLab.font].size.height;
    self.rightLab.height = h>self.rightLab.height?h:self.rightLab.height;
    self.height = self.rightLab.height;
 
}

@end
