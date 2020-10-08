//
//  EOSPermissionsController.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSPermissionsController.h"
#import "EOSPermissionsView.h"

@interface EOSPermissionsController ()
{
    EOSAccount *_eosAccount;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation EOSPermissionsController

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.backgroundColor = SCGray(253);
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"权限查看");

    [self.view addSubview:self.scrollView];
    [self getAccount];
}

- (void)getAccount
{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    [EOSClient GetEOSAccountRequestWithName:wallet.address handle:^(EOSAccount * _Nonnull eosAccount) {
        _eosAccount = eosAccount;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self subViews];
        });
    }];
}

- (void)subViews
{
    for (int i=0; i<_eosAccount.permissions.count; i++) {
        Permissions *permission = _eosAccount.permissions[i];
        EOSPermissionsView *pv = [EOSPermissionsView new];
        pv.permissions = permission;
        pv.centerX = SCREEN_WIDTH/2;
        pv.top = pv.height*i + i*15 + 15;
        
        [_scrollView addSubview:pv];
    }
    
    UITextView *textView = [[UITextView alloc]init];
    textView.size = CGSizeMake(SCREEN_WIDTH-30, 150);
    textView.x = 15;
    textView.top = (172+15)*_eosAccount.permissions.count+15;
    textView.font = kFont(13);
    textView.textColor = SCGray(128);
    textView.backgroundColor = [UIColor clearColor];
    textView.text = LocalizedString(@"Tips:\n • Owner权限：Owner拥有账号的所有权，可以管理账号权限，管理Active及其他角色；\n• Active权限：Active拥有转账、投票等其它权限；\n• 权重阈值：权重阈值是行驶权限的最低权重要求；\n• 权重：权重是公钥的权重等级，数字越大权重越高；\n");
    [_scrollView addSubview:textView];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, textView.bottom+30);
}

@end
