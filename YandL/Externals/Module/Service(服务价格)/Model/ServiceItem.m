//
//  ServiceItem.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "ServiceItem.h"

@implementation ServiceItem

/**
 *  模型中增加详情数据
 */
- (instancetype)detailWithDict:(NSDictionary *)dict
{
    if (self)
    {
        self.Code = dict[@"Code"];
        self.ServiceName = dict[@"ServiceName"];
        self.Until = dict[@"Until"];
        self.Prices = dict[@"Price"];
        self.ServiceBody = dict[@"ServiceBody"];
        self.ServiceContent = dict[@"ServiceContent"];
        self.Note = dict[@"Note"];
    }
    return self;
}

@end