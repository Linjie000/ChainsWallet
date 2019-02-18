//
//  TWMainSearchHeader.m
//  TronWallet
//
//  Created by chunhui on 2018/5/19.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainSearchHeader.h"

@interface TWMainSearchHeader()<UITextFieldDelegate>

@property(nonatomic , strong) UITextField *textField;

@end

@implementation TWMainSearchHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textField = [[UITextField alloc] initWithFrame:self.bounds];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.returnKeyType = UIReturnKeySearch;
        
        [self addSubview:_textField];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = CGRectInset(self.bounds, 10, 5);
    self.textField.frame = frame;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (_doSearch && textField.text.length > 0) {
        _doSearch(textField.text);
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
