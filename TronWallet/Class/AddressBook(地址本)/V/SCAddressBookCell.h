//
//  SCAddressBookCell.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/15.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SCAddressBookCell;
@protocol SCAddressBookCellDelegate <NSObject>
-(void)addressDelectSelect:(SCAddressBookCell *)cell;
-(void)addressEditCell:(SCAddressBookCell *)cell;
-(void)addressChooseNormalCell:(SCAddressBookCell *)cell;
@end

@interface SCAddressBookCell : UITableViewCell
@property(assign, nonatomic) CGFloat height;

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *address;
@property(strong, nonatomic) NSString *note;

@property(assign, nonatomic) BOOL normalSelect;
@property(weak, nonatomic) id<SCAddressBookCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
