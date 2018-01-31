//
//  AddModelController.h
//  YandL
//
//  Created by YandL on 16/12/21.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSectionController : TXBYInputViewController
/**
 *  type (类型)
 */
@property (nonatomic, assign) BOOL isSubSection;

/**
 *  model_id
 */
@property (nonatomic, copy) NSString *model_id;

/**
 *  子section的识别id
 */
@property (nonatomic, copy) NSString *section_item_id;

@end
