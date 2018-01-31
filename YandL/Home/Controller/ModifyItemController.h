//
//  TestViewController.h
//  TXBYModuleApp
//
//  Created by YandL on 16/10/24.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeItem.h"

@interface ModifyItemController : TXBYInputViewController

/**
 *  模型数组
 */
@property (nonatomic, strong) HomeItem *modifyItem;
/**
 *  模型数组
 */
@property (nonatomic, strong) HomeSection *section;

@end
