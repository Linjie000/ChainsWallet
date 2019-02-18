//
//  SCImportBITAddressType.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/19.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportBITAddressType.h"

@interface SCImportBITAddressType ()
{
    UIButton *recoverBtn1;
    UIButton *recoverBtn2;
}

@end

@implementation SCImportBITAddressType

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 66;
        
        [self subViews];
    }
    return self;
}

- (void)subViews
{

    UILabel *titlelab = [UILabel new];
    titlelab.font = kFont(14);
    titlelab.text = LocalizedString(@"设置密码");
    [titlelab sizeToFit];
    titlelab.x = 15;
    titlelab.y = 3;
    [self addSubview:titlelab];
    
    UIImageView *questionImg = [UIImageView new];
    questionImg.size = CGSizeMake(13, 13);
    questionImg.centerY = titlelab.centerY;
    questionImg.left = titlelab.right+5;
    questionImg.image = IMAGENAME(@"设置密码");
    [self addSubview:questionImg];
    [questionImg setTapActionWithBlock:^{
        //MARK: - 设置问题
    }];
    
    recoverBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [recoverBtn1 setImage:IMAGENAME(@"未选中") forState:UIControlStateNormal];
    [recoverBtn1 setImage:IMAGENAME(@"选中") forState:UIControlStateSelected];
    recoverBtn1.titleLabel.font = kFont(14);
    recoverBtn1.size = CGSizeMake(100, 40);
    recoverBtn1.top = titlelab.bottom;
    recoverBtn1.x = 16;
    recoverBtn1.tag = 114;
    recoverBtn1.selected = YES;
    [recoverBtn1 setTitle:LocalizedString(@"隔离见证") forState:UIControlStateNormal];
    [recoverBtn1 setTitle:LocalizedString(@"隔离见证") forState:UIControlStateSelected];
    [recoverBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recoverBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [recoverBtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [recoverBtn1 addTarget:self action:@selector(addressTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:recoverBtn1];
    
    recoverBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [recoverBtn2 setImage:IMAGENAME(@"未选中") forState:UIControlStateNormal];
    [recoverBtn2 setImage:IMAGENAME(@"选中") forState:UIControlStateSelected];
    recoverBtn2.titleLabel.font = kFont(14);
    recoverBtn2.size = CGSizeMake(100, 40);
    recoverBtn2.top = titlelab.bottom;
    recoverBtn2.x = recoverBtn1.right+50;
    [recoverBtn2 setTitle:LocalizedString(@"普通") forState:UIControlStateNormal];
    [recoverBtn2 setTitle:LocalizedString(@"普通") forState:UIControlStateSelected];
    [recoverBtn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [recoverBtn2 setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [recoverBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recoverBtn2 addTarget:self action:@selector(addressTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:recoverBtn2];
}

- (void)addressTypeAction:(UIButton *)btn
{
    if (btn.tag==114) {
        recoverBtn1.selected = YES;
        recoverBtn2.selected = NO;
        if (self.typeBlock) {
            self.typeBlock(Isolate);
        }
    }else
    {
        recoverBtn1.selected = NO;
        recoverBtn2.selected = YES;
        if (self.typeBlock) {
            self.typeBlock(Normal);
        }
    }
}

@end
