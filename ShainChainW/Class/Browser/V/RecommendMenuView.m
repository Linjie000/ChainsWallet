//
//  RecommendMenuView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "RecommendMenuView.h"
#import "RecommendDappModel.h"

#define BTNH 40
#define BTNY 30

@interface RecommendMenuView ()
{
    NSMutableArray *_introDappsMArray;
}
@end

@implementation RecommendMenuView

- (instancetype)init
{
    if (self = [super init]) {
       
    }
    return self;
}

- (void)setIntroDappsArray:(NSArray *)introDappsArray
{
    IntroDapps *jobmodel = [IntroDapps new];
    jobmodel.dappName = @"EOSJOB";
    jobmodel.dappUrl = @"http://unicorn.bi/eos/baccarat?ref=eosbaccasino";   // @"https://tron.linkidol.pro/";  // @"https://eosjob.io/";  https://newdex.340wan.com/trade/eosio.token-bos-eos?channel=shinechain
    jobmodel.dappIcon = @"";
    NSMutableArray *introDappsMArray = [[NSMutableArray alloc]initWithArray:introDappsArray];
    [introDappsMArray insertObject:jobmodel atIndex:0];
    
    _introDappsMArray = introDappsMArray;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         [self subViews];
    });
    NSInteger modelCount = _introDappsMArray.count;
    for (int i=0; i<modelCount; i++) {
        IntroDapps *introappmodel = _introDappsMArray[i];
        UIImageView *imagev = [self viewWithTag:i+10];
        [imagev setImageWithURL:[NSURL URLWithString:introappmodel.dappIcon] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        UILabel *textlab = [self viewWithTag:i+50];
        textlab.text = introappmodel.dappName;
    }
}

- (void)subViews
{

    WeakSelf(weakSelf);
    for (int i = 0; i<8; i++) {
        UIImageView *imagev = [UIImageView new];
        imagev.width = imagev.height = BTNH;
        imagev.layer.cornerRadius = 3;
        imagev.clipsToBounds = YES;
        imagev.tag = i+10;
        __block UIImageView *img = imagev;
        [imagev setTapActionWithBlock:^{
            [weakSelf callBackRecommendTag:img.tag-10];
        }];
        if (i<4) {
            imagev.top = 0;
            imagev.centerX = (2*i+1)*(SCREEN_WIDTH/8);
        }
        else
        {
            imagev.top = BTNH+16+30;
            imagev.centerX = (2*(i-4)+1)*(SCREEN_WIDTH/8);
        }
  
        UILabel *textlab = [UILabel new];
        textlab.width = SCREEN_WIDTH/4;
        textlab.height = 16;
        textlab.textColor = SCGray(20);
        textlab.textAlignment = NSTextAlignmentCenter;
        textlab.font  = kPFFont(12);
        textlab.centerX = imagev.centerX;
        textlab.top = imagev.bottom + 5; 
        textlab.tag = 50+i;
        [self addSubview:imagev];
        [self addSubview:textlab];
        __block UILabel *lab = textlab;
        [textlab setTapActionWithBlock:^{
            [weakSelf callBackRecommendTag:lab.tag-50];
        }];
 
        self.height = textlab.bottom;
    }
}


- (void)callBackRecommendTag:(NSInteger)tag
{
    if (self.RecommendMenu) {
        IntroDapps *model = _introDappsMArray[tag];
        self.RecommendMenu(model);
    }
}

@end
