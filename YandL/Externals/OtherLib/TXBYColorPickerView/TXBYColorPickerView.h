//
//  TXBYColorPickerView.h
//  YandL
//
//  Created by YandL on 16/12/21.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTColorPickerImageView.h"

@interface TXBYColorPickerView : UIView 

@property (nonatomic, strong) UIView *colorView;

typedef void (^ColorPickerBlock)(UILabel *colorLabel);

/**
 *  block
 */
@property (nonatomic, copy) ColorPickerBlock block;

- (instancetype)initWithShowAlpha:(BOOL)showAlph;
/*
 *  设置颜色选择器
 */
- (void)showPickerWithColor:(UIColor *)color block:(ColorPickerBlock)block;

@end
