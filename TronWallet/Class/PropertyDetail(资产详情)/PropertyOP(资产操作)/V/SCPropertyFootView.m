//
//  SCPropertyFootView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCPropertyFootView.h"

@implementation SCPropertyFootView

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.footView];
        self.width = SCREEN_WIDTH;
        self.height = 64;
    }
    return self;
}

- (void)collectionAction{
    //收款
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.block) {
            self.block(1);
        }
    });
}

- (void)transferAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.block) {
            self.block(0);
        }
    });
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [UIView new];
        _footView.size = CGSizeMake(SCREEN_WIDTH, 64);
        _footView.backgroundColor = [UIColor whiteColor];
        _footView.x = self.y = 0;
        
        WeakSelf(weakSelf);
        CGFloat w = (SCREEN_WIDTH - 30 - 11)/2;
        //收款
        UILabel *collLab = [UILabel new];
        collLab.size = CGSizeMake(w, 44);
        collLab.x = 15;
        collLab.centerY = _footView.height/2;
        collLab.backgroundColor = SCColor(252, 91, 44);
        collLab.textColor = [UIColor whiteColor];
        collLab.text = LocalizedString(@"收款");
        collLab.font = kFont(16);
        collLab.textAlignment = NSTextAlignmentCenter;
        collLab.layer.cornerRadius = 5;
        collLab.clipsToBounds = YES;
        [_footView addSubview:collLab];
        [collLab setTapActionWithBlock:^{
            [weakSelf collectionAction];
        }];
        
        //转账
        UILabel *transferLab = [UILabel new];
        transferLab.size = CGSizeMake(w, 44);
        transferLab.x = collLab.right + 11;
        transferLab.centerY = _footView.height/2;
        transferLab.backgroundColor = SCColor(252, 164, 44);
        transferLab.textColor = [UIColor whiteColor];
        transferLab.text = LocalizedString(@"转账");
        transferLab.font = kFont(16);
        transferLab.layer.cornerRadius = 5;
        transferLab.clipsToBounds = YES;
        transferLab.textAlignment = NSTextAlignmentCenter;
        [_footView addSubview:transferLab];
        [transferLab setTapActionWithBlock:^{
            [weakSelf transferAction];
        }];
    }
    return _footView;
}


@end
