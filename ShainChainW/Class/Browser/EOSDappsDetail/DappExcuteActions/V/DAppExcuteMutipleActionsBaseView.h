//
//  DAppExcuteMutipleActionsBaseView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DAppExcuteMutipleActionsBaseViewDelegate<NSObject>
- (void)excuteMutipleActionsConfirmBtnDidClick;
- (void)excuteMutipleActionsCloseBtnDidClick;
@end


@interface DAppExcuteMutipleActionsBaseView : UIView

- (void)updateViewWithArray:(NSArray *)dataArray;

@property(nonatomic , strong) NSMutableArray *actionsArray;



@property(nonatomic, weak) id<DAppExcuteMutipleActionsBaseViewDelegate> delegate;

@end
