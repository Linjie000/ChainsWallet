//
//  SCExpKeyleftView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/8.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCExpKeyleftView.h"

#define marginX 15

@implementation SCExpKeyleftView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = SCGray(244);
        
        [self subViews];
    }
    return self;
}

- (void)setKeystoreStr:(NSString *)keystoreStr
{
    _keystoreStr = keystoreStr;
    
    UIFont *detailFont = kFont(14);
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:_keystoreStr attributes:@{NSKernAttributeName:@(1)}];
    detailText.font = detailFont;
    detailText.color = SCGray(110);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [detailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailText length])];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;//防止文字存在中英文空出太多
    _textView.attributedText = detailText;
}

- (void)subViews{
    CGFloat w = SCREEN_WIDTH - 2*marginX;
    
    NSString *str1 = LocalizedString(@"离线保存");
    UILabel *t1 = [UILabel new];
    t1.size = CGSizeMake(w, 35);
    t1.top = 20;
    t1.left = marginX;
    t1.text = str1;
    t1.font = kFont(15);
    [self addSubview:t1];
    
    NSString *str11 = LocalizedString(@"切勿保存至邮箱、记事本、网盘、聊天工具等，非常危险");
    CGFloat t11h = [RewardHelper textHeight:str11 width:w font:kFont(13)];
    UILabel *t11 = [UILabel new];
    t11.size = CGSizeMake(w, t11h);
    t11.top = t1.bottom;
    t11.left = marginX;
    t11.text = str11;
    t11.font = kFont(13);
    t11.textColor = SCGray(120);
    t11.numberOfLines = 0;
    [self addSubview:t11];
    
    NSString *str2 = LocalizedString(@"请勿使用网络传输");
    UILabel *t2 = [UILabel new];
    t2.size = CGSizeMake(w, 35);
    t2.top = t11.bottom + 15;
    t2.left = marginX;
    t2.text = str2;
    t2.font = kFont(15);
    [self addSubview:t2];
    
    NSString *str22 = LocalizedString(@"请勿使用网络工具传输，一旦被黑客获取将造成不可挽回的资产损失。建议离线设备通过扫二维码方式传输");
    CGFloat t22h = [RewardHelper textHeight:str22 width:w font:kFont(13)];
    UILabel *t22 = [UILabel new];
    t22.size = CGSizeMake(w, t22h);
    t22.top = t2.bottom;
    t22.left = marginX;
    t22.text = str22;
    t22.font = kFont(13);
    t22.textColor = SCGray(120);
    t22.numberOfLines = 0;
    [self addSubview:t22];
    
    NSString *str3 = LocalizedString(@"密码管理工具保存");
    UILabel *t3 = [UILabel new];
    t3.size = CGSizeMake(w, 35);
    t3.top = t22.bottom + 15;
    t3.left = marginX;
    t3.text = str3;
    t3.font = kFont(15);
    [self addSubview:t3];
    
    NSString *str33 = LocalizedString(@"建议使用密码工具管理");
    CGFloat t33h = [RewardHelper textHeight:str33 width:w font:kFont(13)];
    UILabel *t33 = [UILabel new];
    t33.size = CGSizeMake(w, t33h);
    t33.top = t3.bottom;
    t33.left = marginX;
    t33.text = str33;
    t33.font = kFont(13);
    t33.textColor = SCGray(120);
    t33.numberOfLines = 0;
    [self addSubview:t33];
 
    UITextView *textView = [UITextView new];
    textView.backgroundColor = [UIColor whiteColor];
    textView.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 160);
    textView.x = marginX;
    textView.top = t33.bottom+20;
    textView.textContainerInset = UIEdgeInsetsMake(12, 14, 12, 14);
    textView.font = kFont(14);
    textView.bounces = NO;
    _textView = textView;
    [self addSubview:textView];
    
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 50);
    lab.top = textView.bottom+ SCREEN_ADJUST_HEIGHT(40);
    lab.centerX = textView.centerX;
    lab.layer.cornerRadius = 5;
    lab.backgroundColor = SCColor(252, 154, 50);
    lab.layer.shadowColor = [UIColor colorFromHexString:@"#fcae32"].CGColor;
    lab.layer.shadowOffset = CGSizeMake(0, 6);
    lab.layer.shadowOpacity = 0.42;
    lab.layer.shadowRadius = 5;
    lab.text = @"复制Keystore";
    lab.textColor = [UIColor whiteColor];
    lab.font = kFont(15);
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    [lab setTapActionWithBlock:^{
        [RewardHelper copyToPastboard:_keystoreStr];
    }];

    self.contentSize = CGSizeMake(SCREEN_WIDTH, lab.bottom + 10);
 
}

@end
