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
        self.width = SCREEN_WIDTH;
        self.height = 64;
    }
    return self;
}

- (void)collectionAction:(NSInteger)tag{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.block) {
            self.block(tag);
        }
    });
}

- (void)setTextArray:(NSArray *)textArray
{
    _textArray = textArray;
    [self addSubview:self.footView];
}

- (NSArray *)colorArray
{
    if (!_colorArray) {
        _colorArray = @[SCColor(252, 91, 44),SCColor(252, 164, 44),SCColor(62, 201, 73)];
    }
    return _colorArray;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [UIView new];
        _footView.size = CGSizeMake(SCREEN_WIDTH, 64);
        _footView.backgroundColor = [UIColor whiteColor];
        _footView.x = self.y = 0;
        
        WeakSelf(weakSelf);
        for(int i =0;i<self.textArray.count;i++){
            CGFloat w = (SCREEN_WIDTH - 30 - (self.textArray.count-1)*11)/self.textArray.count;
            //收款
            UILabel *collLab = [UILabel new];
            collLab.size = CGSizeMake(w, 44);
            collLab.x = 15+(i*11)+i*w;
            collLab.centerY = _footView.height/2;
            collLab.backgroundColor = self.colorArray[i];
            collLab.textColor = [UIColor whiteColor];
            collLab.text = LocalizedString(self.textArray[i]);
            collLab.font = kFont(16);
            collLab.textAlignment = NSTextAlignmentCenter;
            collLab.layer.cornerRadius = 5;
            collLab.clipsToBounds = YES;
            [_footView addSubview:collLab];
            [collLab setTapActionWithBlock:^{
                [weakSelf collectionAction:i];
            }];
        }
 
        //转账
//        UILabel *transferLab = [UILabel new];
//        transferLab.size = CGSizeMake(w, 44);
//        transferLab.x = collLab.right + 11;
//        transferLab.centerY = _footView.height/2;
//        transferLab.backgroundColor = SCColor(252, 164, 44);
//        transferLab.textColor = [UIColor whiteColor];
//        transferLab.text = LocalizedString(@"转账");
//        transferLab.font = kFont(16);
//        transferLab.layer.cornerRadius = 5;
//        transferLab.clipsToBounds = YES;
//        transferLab.textAlignment = NSTextAlignmentCenter;
//        [_footView addSubview:transferLab];
//        [transferLab setTapActionWithBlock:^{
//            [weakSelf transferAction];
//        }];
    }
    return _footView;
}


@end
