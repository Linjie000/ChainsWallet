//
//  SCTransferFootView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCTransferFootView.h"
#import "SCUnderLineTextField.h"
#import "SCCustomPlaceHolderTextView.h"
#define marginX 15

@interface SCTransferFootView ()
<UITextFieldDelegate>
{
    CGFloat _minValue;
    CGFloat _maxValue;
    CGFloat _gasValue;
}
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UISlider *slider;
@property(strong, nonatomic) UILabel *sliderValue;

@property(strong, nonatomic) UITextField *gaweiField;
@property(strong, nonatomic) UITextField *gasField;
@property(strong, nonatomic) SCCustomPlaceHolderTextView *hexTF;//十六进制数据
@end

@implementation SCTransferFootView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 260;
        self.backgroundColor = [UIColor whiteColor];
        [self subViews];
        
        _minValue = 1.35;
        _maxValue = 88.00;
        _gasValue = 6000;
        
        [self _config];
    }
    return self;
}

- (void)subViews
{
    UILabel *minerFee = [UILabel new];
    minerFee.size = CGSizeMake(80, 30);
    minerFee.text = LocalizedString(@"矿工费用");
    minerFee.font = kFont(16);
    minerFee.x = marginX;
    minerFee.y = 5;
    [self addSubview:minerFee];
 
    [self addSubview:self.scrollView];
    self.scrollView.top = minerFee.bottom;
    
    UISwitch *sw = [UISwitch new];
    sw.right = SCREEN_WIDTH-marginX;
    sw.bottom = self.height - 14;
    [self addSubview:sw];
    [sw addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    sw.onTintColor = MainColor;
    
    UILabel *advancedlab = [UILabel new];
    advancedlab.font = kFont(16);
    advancedlab.text = LocalizedString(@"高级模式");
    advancedlab.textColor = SCGray(128);
    [advancedlab sizeToFit];
    advancedlab.centerY = sw.centerY;
    advancedlab.right = sw.left-5;
    [self addSubview:advancedlab];
}

- (void)_config
{
    _slider.minimumValue = _minValue;
    _slider.maximumValue = _maxValue;
    _slider.value = (_slider.maximumValue-_slider.minimumValue)/2;
    
    _gaweiField.text = [NSString stringWithFormat:@"%.2f",_slider.value];
    _gasField.text = [NSString stringWithFormat:@"%.2f",_gasValue];
    
    _sliderValue.text = [NSString stringWithFormat:@"%.2f gwei",_slider.value];
}

#pragma mark - 输入变化
- (void)textFieldDidChange:(UITextField *)tf
{
    if ([tf.text floatValue]>_maxValue) {
        _maxValue = [tf.text floatValue];
        _slider.maximumValue = _maxValue;
    }
    if ([tf.text floatValue]<_minValue) {
        _minValue = [tf.text floatValue];
        _slider.minimumValue = _minValue;
    }
    _slider.value = [tf.text floatValue];
    _sliderValue.text = [NSString stringWithFormat:@"%.2f gwei",_slider.value];
}

#pragma mark - 滚动条滚动
- (void)sliderValueChange:(UISlider *)slider
{
    CGFloat value = slider.value;
    _sliderValue.text = [NSString stringWithFormat:@"%.2f gwei",value];
    _gaweiField.text = [NSString stringWithFormat:@"%.2f",value];
}

- (void)switchChange:(UISwitch *)sw
{
    if (sw.on) {
        [_scrollView scrollToRightAnimated:YES];
    }else
    {
        [_scrollView scrollToLeftAnimated:YES];
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.size = CGSizeMake(SCREEN_WIDTH, 170);
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, _scrollView.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
        
        //左边view
        UIView *leftView = [UIView new];
        leftView.size = CGSizeMake(SCREEN_WIDTH, 100);
        leftView.x = leftView.y = 0;
        [_scrollView addSubview:leftView];
        
        _slider = [UISlider new];
        _slider.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 30);
        _slider.tintColor = MainColor;
        _slider.top = 25;
        _slider.centerX = SCREEN_WIDTH/2;
        [_slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [leftView addSubview:_slider];
        
        
        _sliderValue = [UILabel new];
        _sliderValue.size = CGSizeMake(200, 30);
        _sliderValue.font = kPFFont(15);
        _sliderValue.centerX = SCREEN_WIDTH/2;
        _sliderValue.textAlignment = NSTextAlignmentCenter;
        _sliderValue.y = _slider.bottom+10;
        [leftView addSubview:_sliderValue];
        
        //右边view
        UIView *rightView = [UIView new];
        rightView.size = CGSizeMake(SCREEN_WIDTH, 150);
        rightView.y = 0;
        rightView.x = SCREEN_WIDTH;
        [_scrollView addSubview:rightView];
        
        _gaweiField = [UITextField new];
        _gaweiField.size = CGSizeMake(SCREEN_WIDTH-100, 40);
        _gaweiField.y = 0;
        _gaweiField.x = marginX;
        _gaweiField.font = kPFFont(15);
        _gaweiField.textColor = SCGray(128);
        _gaweiField.keyboardType = UIKeyboardTypeDecimalPad;
        _gaweiField.delegate = self;
        [_gaweiField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [rightView addSubview:_gaweiField];
        
        _gasField = [UITextField new];
        _gasField.size = CGSizeMake(SCREEN_WIDTH-100, 40);
        _gasField.x = marginX;
        _gasField.y = _gaweiField.bottom;
        _gasField.font = kPFFont(15);
        _gasField.textColor = SCGray(128);
        _gasField.keyboardType = UIKeyboardTypeDecimalPad;
        _gasField.delegate = self;
        [rightView addSubview:_gasField];
        
        UILabel *gawei = [UILabel new];
        gawei.size = CGSizeMake(80, 30);
        gawei.text = @"gawei";
        gawei.font = kFont(16);
        gawei.right = SCREEN_WIDTH - marginX;
        gawei.centerY = _gaweiField.centerY;
        gawei.textColor = SCGray(128);
        gawei.textAlignment = NSTextAlignmentRight;
        [rightView addSubview:gawei];
        
        UILabel *gas = [UILabel new];
        gas.size = CGSizeMake(80, 30);
        gas.text = @"gas";
        gas.font = kFont(16);
        gas.right = SCREEN_WIDTH - marginX;
        gas.centerY = _gasField.centerY;
        gas.textColor = SCGray(128);
        gas.textAlignment = NSTextAlignmentRight;
        [rightView addSubview:gas];
        
        _hexTF = [SCCustomPlaceHolderTextView new];
        _hexTF.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 65);
        _hexTF.x = marginX;
        _hexTF.top = gas.bottom+20;
        _hexTF.layer.borderColor = SCGray(222).CGColor;
        _hexTF.layer.borderWidth = 0.5;
        _hexTF.placeholderTopMargin = 9;
        _hexTF.placeholderLeftMargin = 5;
        _hexTF.textContainerInset = UIEdgeInsetsMake(9, 5, 9, 5);
        _hexTF.placehoder = LocalizedString(@"16进制数据");
        [rightView addSubview:_hexTF];
        
        UIView *line1 = [RewardHelper addLine2];
        line1.width = SCREEN_WIDTH-2*marginX;
        line1.x = marginX;
        line1.top = _gaweiField.bottom;
        [rightView addSubview:line1];
        UIView *line2 = [RewardHelper addLine2];
        line2.width = SCREEN_WIDTH-2*marginX;
        line2.x = marginX;
        line2.top = _gasField.bottom;
        [rightView addSubview:line2];
    }
    return _scrollView;
}

@end
