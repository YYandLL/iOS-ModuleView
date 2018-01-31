//
//  UIView+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "UIView+TXBY.h"

@implementation UIView (TXBY)

- (CGFloat)txby_x {
    return self.frame.origin.x;
}

- (void)setTxby_x:(CGFloat)txby_x {
    CGRect frame = self.frame;
    frame.origin.x = txby_x;
    self.frame = frame;
}

- (CGFloat)txby_y {
    return self.frame.origin.y;
}

- (void)setTxby_y:(CGFloat)txby_y {
    CGRect frame = self.frame;
    frame.origin.y = txby_y;
    self.frame = frame;
}

- (CGFloat)txby_left {
    return self.frame.origin.x;
}

- (void)setTxby_left:(CGFloat)txby_left {
    CGRect frame = self.frame;
    frame.origin.x = txby_left;
    self.frame = frame;
}

- (CGFloat)txby_top {
    return self.frame.origin.y;
}

- (void)setTxby_top:(CGFloat)txby_top {
    CGRect frame = self.frame;
    frame.origin.y = txby_top;
    self.frame = frame;
}

- (CGFloat)txby_right {
    return self.superview.frame.size.width - CGRectGetMaxX(self.frame);
}

- (void)setTxby_right:(CGFloat)txby_right {
    CGRect frame = self.frame;
    frame.origin.x = self.superview.frame.size.width - frame.size.width - txby_right;
    self.frame = frame;
}

- (CGFloat)txby_bottom {
    return self.superview.frame.size.height - CGRectGetMaxY(self.frame);
}

- (void)setTxby_bottom:(CGFloat)txby_bottom {
    CGRect frame = self.frame;
    frame.origin.y = self.superview.frame.size.height - frame.size.height - txby_bottom;
    self.frame = frame;
}

- (CGFloat)txby_centerX {
    return self.center.x;
}

- (void)setTxby_centerX:(CGFloat)txby_centerX {
    self.center = CGPointMake(txby_centerX, self.center.y);
}

- (CGFloat)txby_centerY {
    return self.center.y;
}

- (void)setTxby_centerY:(CGFloat)txby_centerY {
    self.center = CGPointMake(self.center.x, txby_centerY);
}

- (CGFloat)txby_width {
    return self.frame.size.width;
}

- (void)setTxby_width:(CGFloat)txby_width {
    CGRect frame = self.frame;
    frame.size.width = txby_width;
    self.frame = frame;
}

- (CGFloat)txby_height {
    return self.frame.size.height;
}

- (void)setTxby_height:(CGFloat)txby_height {
    CGRect frame = self.frame;
    frame.size.height = txby_height;
    self.frame = frame;
}

- (CGSize)txby_size {
    return self.frame.size;
}

- (void)setTxby_size:(CGSize)txby_size {
    CGRect frame = self.frame;
    frame.size = txby_size;
    self.frame = frame;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end