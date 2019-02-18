//
//  SCCustomPlaceHolderTextView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCCustomPlaceHolderTextView.h"


@interface SCCustomPlaceHolderTextView ()

@property (nonatomic,weak) UILabel *placehoderLabel;

@end

@implementation SCCustomPlaceHolderTextView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _config];
    }
    return self;
}

- (void)_config {
    self.font = [UIFont systemFontOfSize:14];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    self.placeholderLeftMargin = 5;
    self.placeholderTopMargin = 8;
    self.tintColor = MainColor;
}

- (UILabel *)placehoderLabel {
    if (!_placehoderLabel) {
        UILabel *placehoderLabel = [[UILabel alloc]init];
        placehoderLabel.numberOfLines = 0;
        [self addSubview:placehoderLabel];
        _placehoderLabel = placehoderLabel;
        self.placehoderColor = [UIColor lightGrayColor];
    }
    return _placehoderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _config];
    }
    return self;
}

- (void)textDidChange {
    self.placehoderLabel.hidden = self.text.length;
    if ([self.del respondsToSelector:@selector(customPlaceHolderTextViewTextDidChange:)]) {
        [self.del customPlaceHolderTextViewTextDidChange:self];
    }
}

- (void)setText:(NSString *)text{
    if (ISEqualNull(text)) {
        return;
    }
    self.placehoder = @"";
    [super setText:text];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placehoderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor{
    _placehoderColor = placehoderColor;
    self.placehoderLabel.textColor = placehoderColor;
}

- (void)setPlacehoder:(NSString *)placehoder{
    
    _placehoder = [placehoder copy];
    self.placehoderLabel.text = placehoder;
    [self setNeedsLayout];
}

- (void)setPlaceholderLeftMargin:(CGFloat)placeholderLeftMargin {
    _placeholderLeftMargin = placeholderLeftMargin;
    [self setNeedsLayout];
}

- (void)setPlaceholderTopMargin:(CGFloat)placeholderTopMargin {
    _placeholderTopMargin = placeholderTopMargin;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-25, MAXFLOAT);
    CGRect LabelFrame = [self.placehoder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.placehoderLabel.font,NSFontAttributeName, nil] context:nil];
//    CGRect LabelFrame = [RewardHelper textRect:self.placehoder width:self.placehoderLabel.frame.size.width-10 font:self.placehoderLabel.font];
    self.placehoderLabel.frame = CGRectMake(self.placeholderLeftMargin + 2, self.placeholderTopMargin, self.frame.size.width - 2 * self.placeholderLeftMargin, LabelFrame.size.height);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


@end

