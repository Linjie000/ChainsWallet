//
//  UnicornDappView.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "UnicornDappView.h"

@interface UnicornDappView ()
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation UnicornDappView

- (void)setDappModel:(UnicornDappModel *)dappModel
{
    _dappModel = dappModel;
    if ([dappModel.dappIcon containsString:@"http"]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:dappModel.dappIcon]];
    }else{
        _imageView.image = IMAGENAME(dappModel.dappIcon);
    }
}

- (instancetype)init
{
    if (self=[super init]) {
        self.width = (SCREEN_WIDTH - 20)/3;
        self.height = self.width*0.49;
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    //634 311
    _imageView = [UIImageView new];
    _imageView.size = self.size;
    [self addSubview:_imageView];
}

@end
