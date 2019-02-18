//
//  SCBTHAddressChangeCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/17.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCBTHAddressChangeCell.h"

@interface SCBTHAddressChangeCell ()
@property(strong, nonatomic) UILabel *addressLab;
@property(strong, nonatomic) UILabel *addressDetailLab;

@end

@implementation SCBTHAddressChangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self subViews];
        self.selectionStyle = 0;
    }
    return self;
}

- (void)subViews
{
    _addressLab = [UILabel new];
    _addressLab.size = CGSizeMake(SCREEN_WIDTH-30, 20);
    _addressLab.x = 15;
    _addressLab.bottom = CELL_HEIGHT/2;
    _addressLab.font = kFont(14);
    _addressLab.textColor = SCTEXTCOLOR;
    _addressLab.attributedText = [self addRedPointString:@"1354qef3qw14ef65sfq1e3f1w2ef2sf"];
    [self addSubview:_addressLab];
    
    _addressDetailLab = [UILabel new];
    _addressDetailLab.size = CGSizeMake(SCREEN_WIDTH-30, 20);
    _addressDetailLab.x = 15;
    _addressDetailLab.top = CELL_HEIGHT/2;
    _addressDetailLab.font = kFont(14);
    _addressDetailLab.textColor = SCGray(150);
    _addressDetailLab.text = @"xpub 0/2";
    [self addSubview:_addressDetailLab];
    
}

//未使用过的地址
- (NSMutableAttributedString *)addRedPointString:(NSString *)str
{
    NSMutableString *mstr = [[NSMutableString alloc]initWithString:@"•"];
    [mstr appendString:str];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:mstr];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(0, 1)];
    
    return attributedStr;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.3, rect.size.width, 0.3));
}

@end
