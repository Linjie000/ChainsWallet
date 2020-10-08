//
//  SCContactView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCContactView.h"
#import "SCScanController.h"

#define marginX 15

@interface SCContactView ()
{
    UILabel *_typeLab;
}

@end

@implementation SCContactView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 200;
        [self subViews];
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    self.placeHolderTextView.text = @"";
}

- (void)setContaceType:(ADDRESS_TYPE_STRING)contaceType
{
    _contaceType = contaceType;
    switch (contaceType) {
        case ADDRESS_TYPE_STRING_BTC:
            _typeLab.text = @"BTC";
            break;
        case ADDRESS_TYPE_STRING_ETH:
            _typeLab.text = @"ETH";
            break;
        case ADDRESS_TYPE_STRING_EOS:
            _typeLab.text = @"EOS";
            break;
        case ADDRESS_TYPE_STRING_TRON:
            _typeLab.text = @"TRON";
            break;
        case ADDRESS_TYPE_STRING_IOST:
            _typeLab.text = @"IOST";
            break;
            case ADDRESS_TYPE_STRING_ATOM:
            _typeLab.text = @"ATOM";
            break;
        default:
            break;
    }
}

- (void)subViews
{
    UIView *bgView = [UIView new];
    bgView.size = CGSizeMake(SCREEN_WIDTH,300);
    
    UIImageView *img = [UIImageView new];
    img.size = CGSizeMake(40, 40);
    img.x = 9;
    img.top = 0;
    img.image = IMAGENAME(@"-");
    [self addSubview:img];
    [img setTapActionWithBlock:^{
        self.hidden = YES;
        if (self.HidenBlock) {
            self.HidenBlock();
        }
    }];
    
    UILabel *lab = [UILabel new];
    lab.font = kHelFont(16.5);
    lab.textColor = SCTEXTCOLOR;
    lab.size = CGSizeMake(100, 30);
    lab.y = -3;
    lab.left = img.right;
    [self addSubview:lab];
    _typeLab = lab;
    
    UILabel *addressT = [UILabel new];
    addressT.font = kFont(16);
    addressT.textColor = SCOrangeColor;
    addressT.text = LocalizedString(@"添加地址");
    [addressT sizeToFit];
    addressT.y = lab.bottom;
    addressT.left = img.right;
    [self addSubview:addressT];
 
    SCCustomPlaceHolderTextView *placeHolderTextView = [[SCCustomPlaceHolderTextView alloc] init];
    [self addSubview:placeHolderTextView];
    _placeHolderTextView = placeHolderTextView;
    placeHolderTextView.placeholderFont = kFont(15);
    placeHolderTextView.font = kFont(15);
//    placeHolderTextView.del = self;
    placeHolderTextView.x = marginX;
    placeHolderTextView.y = addressT.bottom+8;
    placeHolderTextView.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 145);
    placeHolderTextView.layer.borderColor = SCGray(220).CGColor;
    placeHolderTextView.layer.borderWidth = 0.6;
    placeHolderTextView.placehoder = LocalizedString(@"请输入有效的地址");
    placeHolderTextView.placehoderColor = SCGray(180);
    placeHolderTextView.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4);
    placeHolderTextView.placeholderTopMargin = 4;
    placeHolderTextView.placeholderLeftMargin = 4;
    [self addSubview:placeHolderTextView];
    
    //扫一扫
    YYControl *qrAction = [YYControl new];
    qrAction.size = CGSizeMake(26, 26);
    qrAction.image = IMAGENAME(@"扫一扫-icon");
    qrAction.right = SCREEN_WIDTH-marginX;
    qrAction.y = 0;
    [self addSubview:qrAction];
    qrAction.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateBegan) {
            view.alpha = 0.6;
        }
        if (state==YYGestureRecognizerStateEnded) {
            view.alpha = 1;
            [self scan];
        }
    };
}

- (void)scan{
    //扫一扫
  
    SCScanController *sc = [SCScanController new];
    sc.addressType = self.contaceType;
    WeakSelf(weakSelf);
    [sc setBlock:^(NSString *address, NSString *brand) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.placeHolderTextView.text = address;
        });
    }];
    [[RewardHelper viewControllerWithView:self] presentViewController:sc animated:YES completion:nil];
}

@end
