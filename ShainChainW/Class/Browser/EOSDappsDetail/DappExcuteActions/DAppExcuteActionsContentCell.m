//
//  DAppExcuteActionsContentCell.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#define DAppExcuteActionsContentCellItemHeight 44.5

#define MARGIN_10 10.0f
#define MARGIN_15 15.0f
#define MARGIN_20 20.0f
#define DEFAULT_LINE_HEIGHT 0.5f

#import "DAppExcuteActionsContentCell.h"

@interface DAppExcuteActionsContentCell()
@property(nonatomic , strong) UILabel *contractLabel;
@property(nonatomic , strong) UILabel *actionLabel;
@property(nonatomic , strong) UILabel *accountLabel;
@property(nonatomic , strong) UILabel *contentLabel;

@property(nonatomic , strong) UIView *line1;
@property(nonatomic , strong) UIView *line2;
@property(nonatomic , strong) UIView *line3;
@property(nonatomic , strong) UIView *line4;

@property(nonatomic , strong) UILabel *contractDetailLabel;
@property(nonatomic , strong) UILabel *actionDetailLabel;
@property(nonatomic , strong) UILabel *accountDetailLabel;
@property(nonatomic , strong) UITextView *contentDetailTextView;


@end


@implementation DAppExcuteActionsContentCell

- (UILabel *)contractLabel{
    if (!_contractLabel) {
        _contractLabel = [[UILabel alloc] init];
        _contractLabel.text = NSLocalizedString(@"合约名字", nil);
        _contractLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contractLabel;
}

- (UILabel *)actionLabel{
    if (!_actionLabel) {
        _actionLabel = [[UILabel alloc] init];
        _actionLabel.text = NSLocalizedString(@"动作", nil);
        _actionLabel.font = [UIFont systemFontOfSize:14];
    }
    return _actionLabel;
}

- (UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.text = NSLocalizedString(@"操作账号", nil);
        _accountLabel.font = [UIFont systemFontOfSize:14];
    }
    return _accountLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = NSLocalizedString(@"内容", nil);
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
    }
    return _line1;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
    }
    return _line2;
}

- (UIView *)line3{
    if (!_line3) {
        _line3 = [[UIView alloc] init];
    }
    return _line3;
}

- (UIView *)line4{
    if (!_line4) {
        _line4 = [[UIView alloc] init];
    }
    return _line4;
}

- (UILabel *)contractDetailLabel{
    if (!_contractDetailLabel) {
        _contractDetailLabel = [[UILabel alloc] init];
        _contractDetailLabel.textAlignment = NSTextAlignmentRight;
        _contractDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contractDetailLabel;
}

- (UILabel *)actionDetailLabel{
    if (!_actionDetailLabel) {
        _actionDetailLabel = [[UILabel alloc] init];
        _actionDetailLabel.textAlignment = NSTextAlignmentRight;
        _actionDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _actionDetailLabel;
}

- (UILabel *)accountDetailLabel{
    if (!_accountDetailLabel) {
        _accountDetailLabel = [[UILabel alloc] init];
        _accountDetailLabel.textAlignment = NSTextAlignmentRight;
        _accountDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _accountDetailLabel;
}


- (UITextView *)contentDetailTextView{
    if (!_contentDetailTextView) {
        _contentDetailTextView = [[UITextView alloc] init];
        _contentDetailTextView.font = [UIFont systemFontOfSize:14];
    }
    return _contentDetailTextView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // contract
        [self addSubview:self.contractLabel];
        self.contractLabel.sd_layout.leftSpaceToView(self, MARGIN_20).topSpaceToView(self, 0).heightIs(DAppExcuteActionsContentCellItemHeight).widthIs(150);
        
        [self addSubview:self.contractDetailLabel];
        self.contractDetailLabel.sd_layout.rightSpaceToView(self, MARGIN_20).centerYEqualToView(self.contractLabel).heightIs(DAppExcuteActionsContentCellItemHeight).widthIs(200);
        
        [self addSubview:self.line1];
        self.line1.sd_layout.leftSpaceToView(self, MARGIN_20).rightSpaceToView(self, 0).topSpaceToView(self.contractLabel, 0).heightIs(DEFAULT_LINE_HEIGHT);
        
        
        // action
        [self addSubview:self.actionLabel];
        self.actionLabel.sd_layout.leftSpaceToView(self, MARGIN_20).topSpaceToView(self.line1, 0).heightIs(DAppExcuteActionsContentCellItemHeight).widthIs(150);
        
        [self addSubview:self.actionDetailLabel];
        self.actionDetailLabel.sd_layout.rightSpaceToView(self, MARGIN_20).centerYEqualToView(self.actionLabel).heightIs(DAppExcuteActionsContentCellItemHeight).widthIs(200);
        
        [self addSubview:self.line2];
        self.line2.sd_layout.leftSpaceToView(self, MARGIN_20).rightSpaceToView(self, 0).topSpaceToView(self.actionLabel, 0).heightIs(DEFAULT_LINE_HEIGHT);
        
        
        // account
        [self addSubview:self.accountLabel];
        self.accountLabel.sd_layout.leftSpaceToView(self, MARGIN_20).topSpaceToView(self.line2, 0).heightIs(DAppExcuteActionsContentCellItemHeight).widthIs(150);
        
        [self addSubview:self.accountDetailLabel];
        self.accountDetailLabel.sd_layout.rightSpaceToView(self, MARGIN_20).centerYEqualToView(self.accountLabel).heightIs(DAppExcuteActionsContentCellItemHeight).widthIs(200);
        
        [self addSubview:self.line3];
        self.line3.sd_layout.leftSpaceToView(self, MARGIN_20).rightSpaceToView(self, 0).topSpaceToView(self.accountLabel, 0).heightIs(DEFAULT_LINE_HEIGHT);
        
        
        
        // content
        [self addSubview:self.contentLabel];
        self.contentLabel.sd_layout.leftSpaceToView(self, MARGIN_20).topSpaceToView(self.line3, 0).heightIs(DAppExcuteActionsContentCellItemHeight).widthIs(100);
        
        [self addSubview:self.contentDetailTextView];
        self.contentDetailTextView.sd_layout.leftSpaceToView(self.contentLabel, MARGIN_20).rightSpaceToView(self, MARGIN_20).topSpaceToView(self.line3, 12).heightIs(80);
        
        [self addSubview:self.line4];
        self.line4.sd_layout.leftSpaceToView(self, MARGIN_20).rightSpaceToView(self, 0).topSpaceToView(self.contentDetailTextView, 11).heightIs(DEFAULT_LINE_HEIGHT);
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)setModel:(ExcuteActions *)model{
    _model = model;
    self.contractDetailLabel.text = model.account;
    self.actionDetailLabel.text = model.name;
    if (model.authorization.count>0) {
        NSDictionary *authorizationDict = model.authorization[0];
        self.accountDetailLabel.text = authorizationDict[@"actor"];
    }
    
    NSString *contentJsonStr = [model.data mj_JSONString];
    NSString *contentJsonResultStr =[contentJsonStr stringByReplacingOccurrencesOfString:@"," withString:@",\n"];
    NSString *finalStr ;
    if (contentJsonResultStr.length>2) {
        finalStr = [contentJsonResultStr substringWithRange:NSMakeRange(1, contentJsonResultStr.length-2)];
    }
    self.contentDetailTextView.text = finalStr;
}


@end

