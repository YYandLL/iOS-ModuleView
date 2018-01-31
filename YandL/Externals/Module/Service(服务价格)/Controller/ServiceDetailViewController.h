//
//  ServiceDetailViewController.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  服务价格详情

#import <UIKit/UIKit.h>
@class ServiceItem;

@interface ServiceDetailViewController : TXBYInputViewController

/**
 *  ServiceItem模型
 */
@property (nonatomic, strong) ServiceItem *item;

@end