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

@interface BackupPriKeyView : UIScrollView
{
    UITextView *_textView;
}
@property(strong, nonatomic) TWWalletAccountClient *client;
@end

NS_ASSUME_NONNULL_END
