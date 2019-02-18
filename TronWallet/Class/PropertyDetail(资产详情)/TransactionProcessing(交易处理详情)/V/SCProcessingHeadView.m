//
//  SCProcessingHeadView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/23.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCProcessingHeadView.h"
#import "SCQRCode.h"

@interface SCProcessingHeadView ()
@property(strong, nonatomic) UIImageView *imgView;
@property(strong, nonatomic) UIImageView *qrimgView;
@property(strong, nonatomic) UILabel *processLab;
@end

@implementation SCProcessingHeadView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 272-NAVIBAR_HEIGHT;
        [self subViews];
    }
    return self;
}

- (void)setProce:(PROCE_TYPE)proce
{
    _proce = proce;
    switch (proce) {
        case 0:
            _imgView.image = IMAGENAME(@"交易处理中..");
            _processLab.text = LocalizedString(@"交易处理中..");
            break;
        case 1:
            _imgView.image = IMAGENAME(@"交易成功");
            _processLab.text = LocalizedString(@"交易成功");
            break;
        case 2:
            _imgView.image = IMAGENAME(@"交易失败");
            _processLab.text = LocalizedString(@"交易失败");
            break;
            
        default:
            break;
    }
}

- (void)subViews
{
    _imgView = [UIImageView new];
    _imgView.size = CGSizeMake(90, 90);
    _imgView.top = 60;
    _imgView.centerX = SCREEN_WIDTH/2;
    [self addSubview:_imgView];
    
    _processLab = [UILabel new];
    _processLab.size = CGSizeMake(SCREEN_WIDTH, 30);
    _processLab.textAlignment = NSTextAlignmentCenter;
    _processLab.font = kHelFont(16);
    _processLab.top = _imgView.bottom+16;
    [self addSubview:_processLab];
    
    _qrimgView = [UIImageView new];
    _qrimgView.size = CGSizeMake(36, 36);
    _qrimgView.top = _processLab.bottom+8;
    _qrimgView.x = 15;
    _qrimgView.image = [SCQRCode qrCodeWithString:@"0" logoName:@"" size:_qrimgView.width];
    [self addSubview:_qrimgView];
    
    UIView *line = [RewardHelper addLine2];
    line.width = SCREEN_WIDTH-30;
    line.x = 15;
    line.top = _qrimgView.bottom+13;
    [self addSubview:line];
    
    self.height = line.bottom + 9;
}

@end
