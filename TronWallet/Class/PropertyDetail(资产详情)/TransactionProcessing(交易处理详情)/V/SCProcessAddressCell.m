//
//  SCProcessAddressCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/23.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCProcessAddressCell.h"

@interface SCProcessAddressCell ()
@property(strong, nonatomic) UILabel *titleLab;
@property(strong, nonatomic) UILabel *code;
@property(strong, nonatomic) YYControl *cpControl;
@end

@implementation SCProcessAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    _titleLab = [UILabel new];
    _titleLab.size = CGSizeMake(200, 30);
    _titleLab.x = 15;
    _titleLab.font = kHelFont(16);
    _titleLab.text = LocalizedString(@"付款地址:");
    [self addSubview:_titleLab];
    
    _cpControl = [YYControl new];
    _cpControl.size = CGSizeMake(230, 18);
    _cpControl.x = 15;
    [self addSubview:_cpControl];
    UILabel *code = [UILabel new];
    code.width = 180;
    code.height = 18;
    code.x = code.y = 0;
    code.textColor = SCGray(128);
    code.font = kHelFont(14);
    code.lineBreakMode = NSLineBreakByTruncatingMiddle;
    code.text = @"x8309794ihhrojwoejgroWAH-sgh_134";
    _code = code;
    [_cpControl addSubview:_code];
    YYControl *cpImg = [YYControl new];
    cpImg.size = CGSizeMake(13, 13);
    cpImg.image = IMAGENAME(@"5.4复制");
    cpImg.x = code.right + 5;
    cpImg.centerY = _cpControl.height/2;
    [_cpControl addSubview:cpImg];
    _cpControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateBegan) {
            view.alpha = 0.5;
        }
        if (state==YYGestureRecognizerStateEnded) {
            view.alpha = 1;
            UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = _code.text;
        }
    };
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLab.bottom = HEIGHT/2;
    _cpControl.top = HEIGHT/2;
}

@end
