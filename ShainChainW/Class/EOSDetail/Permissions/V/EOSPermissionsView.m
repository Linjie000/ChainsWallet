//
//  EOSPermissionsView.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSPermissionsView.h"

#define marginX 17
#define kfont1 13
#define kfont2 12

@interface EOSPermissionsView ()

@end

@implementation EOSPermissionsView

- (UILabel *)roleLab
{
    if (!_roleLab) {
        _roleLab = [[UILabel alloc]init];
        _roleLab.width = 100;
        _roleLab.height = 30;
        _roleLab.font = kFont(kfont1);
        _roleLab.textColor = SCGray(30);
    }
    return _roleLab;
}

- (UILabel *)public_keyLab
{
    if (!_public_keyLab) {
        _public_keyLab = [[UILabel alloc]init];
        _public_keyLab.height = 40;
        _public_keyLab.font = kFont(kfont1);
        _public_keyLab.textColor = SCGray(30);
        _public_keyLab.numberOfLines = 0;
        WeakSelf(weakSelf);
        [_public_keyLab setTapActionWithBlock:^{
            [RewardHelper copyToPastboard:weakSelf.public_keyLab.text];
        }];
    }
    return _public_keyLab;
}

- (UILabel *)weightLab
{
    if (!_weightLab) {
        _weightLab = [[UILabel alloc]init];
        _weightLab.width = 100;
        _weightLab.height = 30;
        _weightLab.font = kFont(kfont1);
        _weightLab.textColor = SCGray(30);
    }
    return _weightLab;
}

- (UILabel *)thresholdLab
{
    if (!_thresholdLab) {
        _thresholdLab = [[UILabel alloc]init];
        _thresholdLab.width = 150;
        _thresholdLab.height = 30;
        _thresholdLab.font = kFont(kfont2);
        _thresholdLab.textColor = SCGray(128);
        _thresholdLab.textAlignment = NSTextAlignmentRight;
    }
    return _thresholdLab;
}

- (instancetype)init
{
    if (self=[super init]) {
        self.width = SCREEN_WIDTH-30;
        
        [self subViews];
    }
    return self;
}

- (void)setPermissions:(Permissions *)permissions
{
    self.roleLab.text = permissions.perm_name;
    self.thresholdLab.text = [NSString stringWithFormat:LocalizedString(@"[权重阈值:%@]"),permissions.required_auth.threshold] ;
    
    Keys *keys = permissions.required_auth.keys[0];
    self.public_keyLab.text = keys.key;
    self.weightLab.text = keys.weight;
}

- (void)subViews
{
    CGFloat cornerRadius = 15;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.05;
    self.layer.shadowRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = NO;
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = cornerRadius;
    view.clipsToBounds = YES;
    [self addSubview:view];
    
    UILabel *lab1 = [UILabel new];
    lab1.width = 60;
    lab1.height = 30;
    lab1.font = kFont(kfont2);
    lab1.textColor = SCGray(128);
    lab1.text = LocalizedString(@"角色");
    lab1.x = marginX;
    lab1.y = marginX;
    [self addSubview:lab1];
    
    [self addSubview:self.roleLab];
    self.roleLab.centerY = lab1.centerY;
    self.roleLab.left = lab1.right+10;
    
    
    [self addSubview:self.thresholdLab];
    self.thresholdLab.centerY = lab1.centerY;
    self.thresholdLab.right = self.width-marginX;
    
    
    UIView *line = [RewardHelper addLine2];
    line.width = self.width-2*marginX;
    line.x = marginX;
    line.y = lab1.bottom+7.5;
    [self addSubview:line];
    
    UILabel *lab2 = [UILabel new];
    lab2.width = 60;
    lab2.height = 30;
    lab2.font = kFont(kfont2);
    lab2.textColor = SCGray(128);
    lab2.text = LocalizedString(@"公钥");
    lab2.x = marginX;
    lab2.y = lab1.bottom+15;
    [self addSubview:lab2];
    
    [self addSubview:self.public_keyLab];
    self.public_keyLab.width = (self.width-self.roleLab.left-marginX);
    self.public_keyLab.top = lab2.top;
    self.public_keyLab.left = self.roleLab.left;
    
    
    UILabel *lab3 = [UILabel new];
    lab3.width = 60;
    lab3.height = 30;
    lab3.font = kFont(kfont2);
    lab3.textColor = SCGray(128);
    lab3.text = LocalizedString(@"权重");
    lab3.x = marginX;
    lab3.y = lab2.bottom+33;
    [self addSubview:lab3];
    
    [self addSubview:self.weightLab];
    self.weightLab.width = (self.width-self.roleLab.left-marginX);
    self.weightLab.centerY = lab3.centerY;
    self.weightLab.left = self.roleLab.left;
    
    
    
    self.height = view.height = self.weightLab.bottom+marginX;
}

@end
