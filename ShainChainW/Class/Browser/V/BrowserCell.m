//
//  BrowserCell.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BrowserCell.h"
#import "BrowserModel.h"

#define marginX 16

@interface BrowserCell ()
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subTitle;
@property (strong, nonatomic) UILabel *provider;
@end

@implementation BrowserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.selectedBackgroundView= [[UIView alloc]initWithFrame:self.frame];
        
        self.selectedBackgroundView.backgroundColor= SCGray(244);
        [self setupview];
    }
    return self;
}

- (void)setModel:(BrowserModel *)model
{
    _model = model;
 
    [_imgView setImageWithURL:[NSURL URLWithString:model.img] options:YYWebImageOptionSetImageWithFadeAnimation];
    _title.text = model.title;
    _subTitle.text = model.subTitle;
    _provider.text = model.provider;
}

- (void)setupview
{
    _imgView = [UIImageView new];
    _imgView.width = _imgView.height = 55;
    _imgView.layer.cornerRadius = 5;
    _imgView.clipsToBounds = YES;
    _imgView.x = marginX;
    _imgView.centerY = CELL_H/2;
    [self addSubview:_imgView];
    
    _title = [UILabel new];
    _title.width = SCREEN_WIDTH-2*marginX-_imgView.right;
    _title.height = 25;
    _title.x = _imgView.right+marginX;
    _title.y = _imgView.top;
    _title.font = kBoldFont(14);
    [self addSubview:_title];
    
    _subTitle = [UILabel new];
    _subTitle.width = SCREEN_WIDTH-2*marginX-_imgView.right;
    _subTitle.height = 13;
    _subTitle.x = _imgView.right+marginX;
    _subTitle.y = _title.bottom;
    _subTitle.font = kFont(12);
    [self addSubview:_subTitle];
    
    _provider = [UILabel new];
    _provider.width = SCREEN_WIDTH-2*marginX-_imgView.right;
    _provider.height = 13;
    _provider.x = _imgView.right+marginX;
    _provider.y = _subTitle.bottom+4;
    _provider.font = kFont(12);
    _provider.textColor = SCGray(128);
    [self addSubview:_provider];
    
}

@end
