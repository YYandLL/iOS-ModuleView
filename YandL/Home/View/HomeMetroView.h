//
//  HomeMetroView.h
//  TXBYModuleApp
//
//  Created by YandL on 16/10/21.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeItem.h"
#import "TXBYScrollView.h"
#import "YBPopupMenu.h"

@interface HomeMetroView : UIView <TXBYScrollViewDelegate, YBPopupMenuDelegate>

typedef void (^metroClickBlock)(NSIndexPath *indexPath);

/**
 *  view的高度
 */
@property (nonatomic, assign) float metroHeight;

+ (HomeMetroView *)metroViewWith:(NSArray *)sectionArr click:(metroClickBlock)block;

/**
 *  点击block
 */
@property (nonatomic, copy) metroClickBlock block;

- (void)setupItemView:(NSArray *)sectionArr;

@end
