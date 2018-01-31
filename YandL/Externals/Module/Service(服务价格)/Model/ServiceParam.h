//
//  ServiceParam.h
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//  服务价格请求对象

#import "TXBYBaseParam.h"

@interface ServiceParam : TXBYBaseParam

/**
 *  服务名称
 */
@property (nonatomic, copy) NSString *ServiceName;

/**
 *  code
 */
@property (nonatomic, copy) NSString *Code;

/**
 *  mtid
 */
@property (nonatomic, copy) NSString *mtid;

/**
 *  mtids
 */
@property (nonatomic, copy) NSString *mtids;

@end