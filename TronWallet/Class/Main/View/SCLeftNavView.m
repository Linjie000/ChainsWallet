//
//  SCLeftNavView.m
//  SCWallet
//
//  Created by zaker_sink on 2018/12/9.
//  Copyright © 2018 zaker_sink. All rights reserved.
//

#import "SCLeftNavView.h"

@interface SCLeftNavView()
{
    UILabel *_typeLab;
}
@end

@implementation SCLeftNavView

- (void)setWalletType:(NSString *)walletType
{
    _walletType = walletType;
    _typeLab.text = walletType;
}

-(void)layout{

    //设置圆角边框
    
    self.layer.cornerRadius = 13.5;
    
    self.layer.masksToBounds = YES;
    
    //设置边框及边框颜色
    
    self.layer.borderWidth = 1;
    
    self.layer.borderColor =[ [UIColor grayColor] CGColor];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, 40, 20)];
    _typeLab = label;
    label.font = kFont(14);
    [self addSubview:label];
    
    UIImageView* image =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页v"]];
    image.frame =CGRectMake(40, 0, 11, 6);
    image.centerY = 13;
    [self addSubview:image];
}
    
-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
