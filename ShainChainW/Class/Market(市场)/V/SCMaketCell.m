//
//  SCMaketCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/3.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCMaketCell.h"
#import "SCMaketDataView.h"

#define marginX SCREEN_ADJUST_WIDTH(15)
#define kMaketNameFont 14.5
#define kMaketDetailFont 12.5
#define kCurrnetPriceFont 14
#define kMaketPriceFont 12.5
#define kPriceMarginX SCREEN_ADJUST_WIDTH(14)

@interface SCMaketCell()
//币种
@property(strong, nonatomic) UIImageView *logoImg;

@property(strong, nonatomic) YYTextLayout *maketTextLayout;
@property(strong, nonatomic) YYLabel *maketLab;

@property(strong, nonatomic) YYTextLayout *maketDetailLayout;
@property(strong, nonatomic) YYLabel *maketDetailLab;

//价格
@property(strong, nonatomic) YYTextLayout *currentPriceLayout;
@property(strong, nonatomic) YYLabel *currentPriceLab;

@property(strong, nonatomic) YYTextLayout *priceLabLayout;
@property(strong, nonatomic) YYLabel *priceLab;

//涨跌幅
@property(strong, nonatomic) SCMaketDataView *dataView;

@property(strong, nonatomic) UIView *line;
@end

@implementation SCMaketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self subViews];
        self.selectedBackgroundView= [[UIView alloc]initWithFrame:self.frame];
        
        self.selectedBackgroundView.backgroundColor= SCGray(244);
        //        [self layout];
    }
    return self;
}

- (void)setModel:(MarketClientModel *)model
{
    _model = model;
    [self layout];
}

- (void)layout{
    
    [_logoImg sd_setImageWithURL:[NSURL URLWithString:self.model.logo_url] placeholderImage:[UIImage imageWithColor:SCGray(244)]];
    
    //名称
    NSString *maketName = self.model.name;
    UIFont *maketFont = kDINMedium(kMaketNameFont);
    NSMutableAttributedString *maketText = [[NSMutableAttributedString alloc] initWithString:maketName];
    maketText.font = maketFont;
    if ([maketName containsString:@"/"]) {
        NSRange range = [maketName rangeOfString:@"/"];
        [maketText setColor:SCGray(100) range:NSMakeRange(range.location, maketName.length-range.location)];
    }
    maketText.lineBreakMode = NSLineBreakByCharWrapping;
    _maketTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(120, kMaketNameFont*2) text:maketText];
    
    NSString *maketDetailName = @"Huobi";
    UIFont *maketDetailFont = kDINRegular(kMaketDetailFont);
    NSMutableAttributedString *maketDetailText = [[NSMutableAttributedString alloc] initWithString:maketDetailName];
    maketDetailText.font = maketDetailFont;
    maketDetailText.lineBreakMode = NSLineBreakByCharWrapping;
    maketDetailText.color = SCGray(100);
    _maketDetailLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(120, kMaketDetailFont*2) text:maketDetailText];
    
    //价格
    NSString *currentPrice = self.model.close;
    UIFont *currentPriceFont = kDINMedium(kCurrnetPriceFont);
    NSMutableAttributedString *currentPriceText = [[NSMutableAttributedString alloc] initWithString:currentPrice];
    currentPriceText.font = currentPriceFont;
    currentPriceText.lineBreakMode = NSLineBreakByCharWrapping;
    currentPriceText.color = SCGray(40);
    _currentPriceLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(120, kMaketPriceFont*2) text:currentPriceText];
    
    NSString *price = [NSString stringWithFormat:@"¥%@",self.model.close_rmb];
    UIFont *priceFont = kDINMedium(kMaketPriceFont);
    NSMutableAttributedString *priceText = [[NSMutableAttributedString alloc] initWithString:price];
    priceText.font = priceFont;
    priceText.lineBreakMode = NSLineBreakByCharWrapping;
    priceText.color = SCGray(100);
    _priceLabLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(120, kMaketPriceFont*2) text:priceText];
    
    _dataView.data = self.model.rise;
    
    _maketLab.textLayout = _maketTextLayout;
    _maketDetailLab.textLayout = _maketDetailLayout;
    _currentPriceLab.textLayout = _currentPriceLayout;
    _priceLab.textLayout = _priceLabLayout;
    
    [self layoutIfNeeded];
}

- (void)subViews{
    
    _logoImg = [UIImageView new];
    _logoImg.width = SCREEN_ADJUST_WIDTH(30);
    _logoImg.height = SCREEN_ADJUST_WIDTH(30);
    [self addSubview:_logoImg];
    
    _maketLab = [YYLabel new];
    //    _maketLab.displaysAsynchronously = YES;
    [self addSubview:_maketLab];
    
    _maketDetailLab = [YYLabel new];
    //    _maketDetailLab.displaysAsynchronously = YES;
    [self addSubview:_maketDetailLab];
    
    SCMaketDataView *dataView = [SCMaketDataView new];
    _dataView = dataView;
    [self.contentView addSubview:dataView];
    
    _currentPriceLab = [YYLabel new];
    //    _currentPriceLab.displaysAsynchronously = YES;
    [self addSubview:_currentPriceLab];
    
    _priceLab = [YYLabel new];
    //    _priceLab.displaysAsynchronously = YES;
    [self addSubview:_priceLab];
    
    _line = [RewardHelper addLine2];
    [self addSubview:_line];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted
                 animated:animated];
    [_dataView setColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_dataView setColor];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _logoImg.x = marginX;
    _logoImg.centerY = CellHeight/2;
    
    _maketLab.size = _maketTextLayout.textBoundingSize;
    _maketLab.x = _logoImg.right+10;
    _maketLab.bottom = CellHeight/2+1;
    
    _maketDetailLab.size = _maketDetailLayout.textBoundingSize;
    _maketDetailLab.x = _maketLab.x;
    _maketDetailLab.top = CellHeight/2-1;
    
    _dataView.right = SCREEN_WIDTH-marginX;
    _dataView.centerY = CellHeight/2;
    
    _currentPriceLab.size = _currentPriceLayout.textBoundingSize;
    _currentPriceLab.bottom = _maketLab.bottom;
    _currentPriceLab.right = _dataView.left - kPriceMarginX;
    
    _priceLab.size = _priceLabLayout.textBoundingSize;
    _priceLab.top = _maketDetailLab.top+2;
    _priceLab.right = _currentPriceLab.right;
    
    _line.bottom = CellHeight;
}

@end
