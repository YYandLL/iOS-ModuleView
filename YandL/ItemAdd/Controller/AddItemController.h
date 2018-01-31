//
//  AddItemController.h
//  YandL
//
//  Created by YandL on 16/12/22.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemController : TXBYInputViewController

typedef void (^addItemBlock)(NSDictionary *dic);
/**
 *  block
 */
@property (nonatomic, copy) addItemBlock block;
/**
 *  type (类型)
 */
@property (nonatomic, copy) NSString *itemType;
/**
 *  subtype (更多类型时的详细类型)
 */
@property (nonatomic, copy) NSString *subType;
/**
 *  是否是新Section中的item
 */
@property (nonatomic, assign) BOOL isNewitem;
/**
 *  是否是子section中的item
 */
@property (nonatomic, assign) BOOL isSubitem;
/**
 *  子section的识别id
 */
@property (nonatomic, copy) NSString *section_item_id;

@end
