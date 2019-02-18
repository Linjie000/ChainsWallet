//
//  TWTransferTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWTransferTableViewCell.h"
#import "TWShEncoder.h"

@interface TWTransferTableViewCell()

@property(nonatomic , strong) NSDictionary *transaction;

@end

@implementation TWTransferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHash)];
    [self.hashLabel addGestureRecognizer:gesture];
    
    gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onFrom)];
    [self.fromLabel addGestureRecognizer:gesture];
    
    gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTo)];
    [self.toLabel addGestureRecognizer:gesture];
}

-(void)onHash
{
    NSString *hash = _transaction[@"hash"];
    [self paste:hash title:@"HASH"];
}

-(void)onFrom
{
    NSString *hash = _transaction[@"transferFromAddress"];
    [self paste:hash title:@"FROM Address"];
}

-(void)onTo
{
    NSString *hash = _transaction[@"transferToAddress"];
    [self paste:hash title:@"TO Address"];
}

-(void)paste:(NSString *)content title:(NSString *)title
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = content;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
    
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = [NSString stringWithFormat:@"%@ has copied to pasteboard",title];
    hud.label.textColor = [UIColor whiteColor];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindData:(NSDictionary *)transaction
{
 
    NSString *from = transaction[@"transferFromAddress"];
    NSString *to = transaction[@"transferToAddress"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[transaction[@"timestamp"] doubleValue]/1000];
    NSString *d = [TKCommonTools dateDescForDate:date];
    NSInteger amount = [transaction[@"amount"] longLongValue]/kDense;
    NSString *hash = transaction[@"transactionHash"];
    
    
    self.fromLabel.text =  from?:@"--";
    self.toLabel.text   =  to?:@"--";
    self.dateLabel.text = d?:@"--";
    self.countLabel.text = [NSString stringWithFormat:@"%ld %@",amount,transaction[@"tokenName"]?:@""];
    self.hashLabel.text = hash?:@"--";
}

@end
