//
//  BackupPriKeyView.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWWalletAccountClient.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BackupPriKeyViewDelegate <NSObject>

- (void)backupPriKeyCommon;

@end

@interface BackupPriKeyView : UIScrollView
{
    UITextView *_textView;
}
@property(strong, nonatomic) TWWalletAccountClient *client;
@property(weak, nonatomic) id<BackupPriKeyViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
