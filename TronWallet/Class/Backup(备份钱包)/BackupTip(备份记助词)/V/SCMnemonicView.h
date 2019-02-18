//
//  SCMnemonicView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/25.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCMnemonicDelegate <NSObject>

- (void)selectWord:(NSString *)word;

@end

@interface SCMnemonicView : UICollectionView

+ (instancetype) init:(CGRect)frame;

@property (nonatomic, strong) NSArray *mnemonicWord;

@property (nonatomic, assign) id <SCMnemonicDelegate> mnemonicDelegate;

@end


NS_ASSUME_NONNULL_END
