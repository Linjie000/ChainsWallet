//
//  SCChooseWalletTableView.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCChooseWalletTableViewDelegagte <NSObject>

- (void)SCChooseWalletTableViewSelectWallet:(walletModel *)walletModel;

@end

@interface SCChooseWalletTableView : UIView
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) id<SCChooseWalletTableViewDelegagte> delegate;
@end

