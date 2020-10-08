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
    
    self.layer.cornerRadius = self.height/2;
    
    self.layer.masksToBounds = YES;
    
    //设置边框及边框颜色
    
    self.layer.borderWidth = 0;
    
    self.layer.backgroundColor =[SCGray(248) CGColor];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 39, 20)];
    _typeLab = label;
    label.centerY = self.height/2;
    label.font = SCUIFontPingFangSCRegular(13);
    [self addSubview:label];
    
    UIImageView* image =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页v"]];
    image.frame =CGRectMake(0, 0, 8, 4);
    image.right = self.width-8;
    image.centerY = self.height/2;
    [self addSubview:image];
}
    
-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
