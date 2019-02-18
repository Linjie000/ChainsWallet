//
//  TWMainRecentBlockTableViewCell.h
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWMainRecentBlockTableViewCell : UITableViewCell


//
-(void)updateWithModel:(NSMutableArray<Block*> *)blockArray;

@end
