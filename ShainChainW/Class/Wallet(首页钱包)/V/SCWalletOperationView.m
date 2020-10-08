//
//  SCWalletOperationView.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCWalletOperationView.h"
#import "SCButton.h"
#define marinX 15

@interface SCWalletOperationView ()

@end

@implementation SCWalletOperationView

- (instancetype)init
{
    if (self=[super init]) {
        self.width = SCREEN_WIDTH-2*marinX;
        self.height = 50;
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    CGFloat cornerRadius = 5;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = NO;
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = cornerRadius;
    view.clipsToBounds = YES;
    [self addSubview:view];
    
    NSArray *textArr = @[LocalizedString(@"转账"),LocalizedString(@"资源管理")];
    NSArray *imgArr = @[@"wallet_transfer",@"wallet_baobiaoguanli"];
    for (int i=0; i<textArr.count; i++) {
        SCButton *transferButton = [SCButton buttonWithType:UIButtonTypeCustom];
        transferButton.frame = CGRectMake(0, 0, self.width/2, self.height); 
        [transferButton setImage:IMAGENAME(imgArr[i]) forState:UIControlStateNormal];
        [transferButton setTitle:textArr[i] forState:UIControlStateNormal];
        [transferButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        transferButton.tag = 50+i;
        [self addSubview:transferButton];
        if (i) {
            transferButton.x = self.width/2;
        }
        [transferButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *line = [UIView new];
    line.size = CGSizeMake(1, 21);
    line.backgroundColor = SCGray(240);
    line.centerX = self.width/2;
    line.centerY = self.height/2;
    [self addSubview:line];
}

- (void)btnAction:(UIButton *)btn
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(SCWalletOperationViewDelegateSelect:)]) {
        [self.delegate SCWalletOperationViewDelegateSelect:btn.tag-50];
    }
}

@end
