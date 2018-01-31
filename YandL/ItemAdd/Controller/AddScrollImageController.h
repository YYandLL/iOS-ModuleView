//
//  AddScrollImageController.h
//  YandL
//
//  Created by YandL on 16/12/23.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "TXBYInputViewController.h"

@interface AddScrollImageController : TXBYInputViewController

typedef void (^addImageBlock)(NSDictionary *dic);
/**
 *  block
 */
@property (nonatomic, copy) addImageBlock block;
/**
 *  <#desc#>
 */
@property (nonatomic, copy) NSString *itemID;

/**
 *  <#desc#>
 */
@property (nonatomic, assign) BOOL isNew;
@end
