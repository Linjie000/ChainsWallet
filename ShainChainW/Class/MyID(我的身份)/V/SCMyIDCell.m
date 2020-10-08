//
//  SCMyIDCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/15.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCMyIDCell.h"

@interface SCMyIDCell ()
{
    UILabel *_strLab;
}

@end

@implementation SCMyIDCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self subViews];
        self.selectionStyle = 0;
    }
    return self;
}

- (void)setStr:(NSString *)str
{
    _str = str;
    _strLab.text = str;
}

- (void)subViews
{
    _strLab = [UILabel new];
    _strLab.size = CGSizeMake(100, HEIGHT);
    _strLab.y = 0;
    _strLab.x = 15;
    _strLab.font = kFont(15.5);
    _strLab.textColor = SCTEXTCOLOR;
    [self addSubview:_strLab];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, SCGray(240).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.3, rect.size.width, 0.3));
}

@end
