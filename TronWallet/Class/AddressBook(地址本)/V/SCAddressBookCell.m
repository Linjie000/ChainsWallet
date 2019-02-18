//
//  SCAddressBookCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/15.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCAddressBookCell.h"

#define marginX 15

@interface SCAddressBookCell ()
@property(strong, nonatomic) UILabel *nameLab;
@property(strong, nonatomic) UILabel *typeLab;
@property(strong, nonatomic) UILabel *addressLab;
@property(strong, nonatomic) UILabel *noteLab;
@property(strong, nonatomic) UIView *footView;
@property(strong, nonatomic) UIImageView *chooseImg;
@property(strong, nonatomic) YYControl *cpControl;
@end

@implementation SCAddressBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self subViews];
        self.selectionStyle = 0;
    }
    return self;
}

- (void)setNormalSelect:(BOOL)normalSelect
{
    _normalSelect = normalSelect;
    if (_normalSelect) {
        _chooseImg.image = IMAGENAME(@"选中");
    }else
    {
        _chooseImg.image = IMAGENAME(@"未选中");
    }
}

- (void)setNote:(NSString *)note
{
    _note = note;
    _noteLab.text = note;
    [self layoutIfNeeded];
}

- (void)setType:(NSString *)type
{
    _type = type;
    _typeLab.text = _type;
    [_typeLab sizeToFit];
    [self layoutIfNeeded];
}

- (void)setAddress:(NSString *)address
{
    _address = address;
    _addressLab.text = address;
    [self layoutIfNeeded];
}

- (void)subViews
{
    _nameLab = [UILabel new];
    _nameLab.font = kFont(16);
    _nameLab.width = 200;
    _nameLab.height = 30;
    _nameLab.x = marginX;
    _nameLab.text = @"刘先生";
    [self addSubview:_nameLab];
    
    _typeLab = [UILabel new];
    _typeLab.font = kFont(13);
    [self addSubview:_typeLab];
    
    
    _cpControl = [YYControl new];
    _cpControl.size = CGSizeMake(200, 18);
    [self addSubview:_cpControl];
    _addressLab = [UILabel new];
    _addressLab.font = kFont(13);
    _addressLab.textColor = SCGray(128);
    _addressLab.width = 160;
    _addressLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _addressLab.height = _cpControl.height;
    _addressLab.x = 0;
    _addressLab.centerY = _cpControl.centerY;
    [_cpControl addSubview:_addressLab];
    YYControl *cpImg = [YYControl new];
    cpImg.size = CGSizeMake(13, 13);
    cpImg.image = IMAGENAME(@"5.4复制");
    cpImg.x = _addressLab.right + 3;
    cpImg.centerY = _cpControl.height/2;
    [_cpControl addSubview:cpImg];
    _cpControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateBegan) {
            view.alpha = 0.5;
        }
        if (state==YYGestureRecognizerStateEnded) {
            view.alpha = 1;
            UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = _addressLab.text;
        }
    };
    
    _noteLab = [UILabel new];
    _noteLab.font = kFont(13);
    _noteLab.textColor = SCGray(128);
    _noteLab.numberOfLines = 0;
    [self addSubview:_noteLab];
    
    [self addSubview:self.footView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _nameLab.y = 8;
    
    _typeLab.x = marginX;
    _typeLab.y = self.nameLab.bottom+4;
    
    _cpControl.x = _typeLab.right;
    _cpControl.centerY = _typeLab.centerY;
    
    CGFloat h = [RewardHelper textHeight:_note width:SCREEN_WIDTH-2*marginX font:_noteLab.font];
    _noteLab.size = CGSizeMake(SCREEN_WIDTH-2*marginX, h);
    _noteLab.x = marginX;
    _noteLab.y = _cpControl.bottom + 9;
    
    self.footView.x = 0;
    self.footView.y = _noteLab.bottom + 10;
    
    self.height = self.footView.bottom;
}

- (UIView *)footView
{
    //选中 未选中
    if (!_footView) {
        _footView = [UIView new];
        _footView.size = CGSizeMake(SCREEN_WIDTH, 40);
        _chooseImg = [UIImageView new];
        _chooseImg.width = _chooseImg.height = 15;
        _chooseImg.image = IMAGENAME(@"未选中");
        _chooseImg.x = marginX;
        _chooseImg.centerY = _footView.height/2;
        [_footView addSubview:_chooseImg];
        
        UILabel *normal = [UILabel new];
        normal.size = CGSizeMake(120, 30);
        normal.font = kFont(13);
        normal.textColor = SCGray(128);
        normal.x =_chooseImg.right+9;
        normal.centerY = _chooseImg.centerY;
        [_footView addSubview:normal];
        normal.text = LocalizedString(@"默认地址");
        
        UIButton *del = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        del.width = 60;
        del.height = _footView.height;
        del.centerY = normal.centerY;
        del.right = SCREEN_WIDTH;
        [del setTintColor:SCGray(128)];
        [del setTitle:LocalizedString(@"删除") forState:UIControlStateNormal];
        del.titleLabel.font = kFont(13);
        [_footView addSubview:del];
        [del addTarget:self action:@selector(delAddress) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *edit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        edit.width = 60;
        edit.height = _footView.height;
        edit.right = del.left;
        edit.centerY = normal.centerY;
        [edit setTitle:LocalizedString(@"编辑") forState:UIControlStateNormal];
        [edit setTintColor:SCGray(128)];
        edit.titleLabel.font = kFont(13);
        [_footView addSubview:edit];
        [edit addTarget:self action:@selector(editAddress) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [RewardHelper addLine2];
        line.x = 0;
        [_footView addSubview:line];
        
        YYControl *chooseCon = [YYControl new];
        chooseCon.size = CGSizeMake(normal.right, _footView.height);
        chooseCon.x = chooseCon.y = 0;
        [_footView addSubview:chooseCon];
        chooseCon.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (state==YYGestureRecognizerStateEnded) {
                if ([self.delegate respondsToSelector:@selector(addressChooseNormalCell:)]) {
                    [self.delegate addressChooseNormalCell:self];
                }
            }
        };
        
    }
    return _footView;
}

- (void)delAddress
{
    if ([self.delegate respondsToSelector:@selector(addressDelectSelect:)]) {
        [self.delegate addressDelectSelect:self];
    }
}

- (void)editAddress{
    if ([self.delegate respondsToSelector:@selector(addressEditCell:)]) {
        [self.delegate addressEditCell:self];
    }
}

@end
