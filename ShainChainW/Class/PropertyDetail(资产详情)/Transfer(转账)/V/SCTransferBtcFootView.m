//
//  SCTransferBtcFootView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/19.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCTransferBtcFootView.h"
#import "SCUnderLineTextField.h"

@interface SCTransferBtcFootView ()
{
    NSInteger _type;
}
@property(strong, nonatomic) NSArray *textArray;
@end

@implementation SCTransferBtcFootView

- (NSArray *)textArray
{
    if (!_textArray) {
        _textArray = @[@"35",@"45"];
    }
    return _textArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        _type = 0;
        [self subViews];
        self.width = SCREEN_WIDTH;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)reset
{
    _countFee.text = @"35";
}

- (void)subViews
{
    UILabel *minerFee = [UILabel new];
    minerFee.size = CGSizeMake(80, 30);
    minerFee.text = LocalizedString(@"矿工费用");
    minerFee.font = kFont(14);
    minerFee.textAlignment = NSTextAlignmentLeft;
    minerFee.x = 15;
    minerFee.y = 5;
    [self addSubview:minerFee];
    
    UILabel *countFeeText = [UILabel new];
    countFeeText.size = CGSizeMake(40, 30);
    countFeeText.text = @"sat/b";
    countFeeText.font = kFont(14);
    countFeeText.centerY = minerFee.centerY;
    countFeeText.right = SCREEN_WIDTH-15;
    countFeeText.textColor = MainColor;
    countFeeText.textAlignment = NSTextAlignmentRight;
    [self addSubview:countFeeText];
    
    UILabel *countFee = [UILabel new];
    countFee.size = CGSizeMake(SCREEN_WIDTH-minerFee.right-15-countFeeText.width, 30);
    countFee.text = self.textArray[_type];
    countFee.font = kFont(14);
    countFee.centerY = minerFee.centerY;
    countFee.right = countFeeText.left;
    countFee.textColor = MainColor;
    countFee.textAlignment = NSTextAlignmentRight;
    _countFee = countFee;
    
    [self addSubview:countFee];
    
    SCTransferBtcDetailView *bc = [SCTransferBtcDetailView new];
    bc.top = countFee.bottom;
    [self addSubview:bc];
    self.height = bc.bottom;
    [bc setSatValue:^(NSString * _Nonnull value) {
        countFee.text = [NSString stringWithFormat:@"%@",value];
    }];
    [bc setSatType:^(NSInteger type) {
        self->_countFee.text = self.textArray[type];
    }];
}

@end

@interface SCTransferBtcDetailView ()
{
    SCUnderLineTextField *_customLab;
}
@property(strong, nonatomic) NSArray *textArray;
@end

@implementation SCTransferBtcDetailView

- (NSArray *)textArray
{
    if (!_textArray) {
        _textArray = @[@"   Regular：35 sat/b",@"   Priority：45 sat/b"];
    }
    return _textArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 140;
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    CGFloat th = 50;
    UIImageView *chooseimg = [UIImageView new];
    chooseimg.size = CGSizeMake(18, 11);
    chooseimg.image = IMAGENAME(@"1.2_icon_ok");
    chooseimg.centerY = th/2;
    chooseimg.right = SCREEN_WIDTH-60;
    for (int i=0;i<self.textArray.count;i++)
    {
        SCUnderLineTextField *tflab = [SCUnderLineTextField new];
        tflab.x = 15;
        tflab.height = th;
        tflab.width = SCREEN_WIDTH - 2*tflab.x;
        tflab.text = self.textArray[i];
        tflab.textColor = SCTEXTCOLOR;
        tflab.font = kFont(14);
        tflab.enabled = NO;
        tflab.y = i*tflab.height;
        [self addSubview:tflab];
        UIView *tapview = [UIView new];
        tapview.frame = tflab.frame;
        [self addSubview:tapview];
        tapview.tag = 99+i;
        __block UIView *v = tapview;
        [tapview setTapActionWithBlock:^{
            if (self.satType) {
                self.satType(v.tag-99);
                _customLab.text = @"";
                [v addSubview:chooseimg];
            }
        }];
        if(i==0)[tapview addSubview:chooseimg];
    }
    SCUnderLineTextField *customLab = [SCUnderLineTextField new];
    customLab.x = 15;
    customLab.height = 40;
    customLab.width = SCREEN_WIDTH-30;
    customLab.placeholder = LocalizedString(@"自定义手续费(sat/b)");
    customLab.textColor = SCTEXTCOLOR;
    customLab.font = kFont(14);
    customLab.y = self.textArray.count*50;
    customLab.keyboardType = UIKeyboardTypeNumberPad;
    [customLab addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:customLab];
    _customLab = customLab;
}

- (void)textFieldChange:(UITextField *)textField
{
    if (self.satValue) {
        self.satValue(textField.text);
    }
}

- (NSString *)formartScientificNotationWithString:(NSString *)str{
    long double num = [[NSString stringWithFormat:@"%@",str] floatValue];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterNoStyle;
    NSString * string = [formatter stringFromNumber:[NSNumber numberWithDouble:num]];
    return string;
}

@end
