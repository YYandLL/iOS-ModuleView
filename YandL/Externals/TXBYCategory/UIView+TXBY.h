//
//  UIView+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TXBY)

/**
 *  x坐标
 */
@property (nonatomic, assign) CGFloat txby_x;

/**
 *  y坐标
 */
@property (nonatomic, assign) CGFloat txby_y;

/**
 *  左边距
 */
@property (nonatomic, assign) CGFloat txby_left;

/**
 *  上边距
 */
@property (nonatomic, assign) CGFloat txby_top;

/**
 *  右边距
 */
@property (nonatomic, assign) CGFloat txby_right;

/**
 *  下边距
 */
@property (nonatomic, assign) CGFloat txby_bottom;

/**
 *  中点x
 */
@property (nonatomic, assign) CGFloat txby_centerX;

/**
 *  中点y
 */
@property (nonatomic, assign) CGFloat txby_centerY;

/**
 *  宽度
 */
@property (nonatomic, assign) CGFloat txby_width;

/**
 *  高度
 */
@property (nonatomic, assign) CGFloat txby_height;

/**
 *  视图的宽高
 */
@property (nonatomic, assign) CGSize txby_size;

/**
 *  移除该view的所有subviews
 */
- (void)removeAllSubviews;

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end