//
//  TXBYBaseParam.m
//  TXBYBaseParam
//
//  Created by hj on 16/5/9.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import "TXBYBaseParam.h"
#import "TXBYKitConst.h"
//#import "AccountTool.h"

@implementation TXBYBaseParam

- (NSString *)token {
//    if (!_token) {
//        _token = [AccountTool account].token;
//    }
    return _token;
}

/**
 *  快速创建一个请求参数对象
 */
+ (instancetype)param {
    // 默认使用pch中的医院ID
    id param = [[self alloc] init];
    
    NSException *hospitalException = [NSException
                                      exceptionWithName: @"参数未初始化"
                                      reason: @"未设置医院ID"
                                      userInfo: nil];
    NSException *apptypeException = [NSException
                                     exceptionWithName: @"参数未初始化"
                                     reason: @"未设置apptype"
                                     userInfo: nil];
    if (!TXBYHospital) {
        @throw hospitalException;
    }
    if (!TXBYApp_type) {
        @throw apptypeException;
    }
    if (TXBYBranch) {
        [param setBranch:TXBYBranch];
    }
    [param setHospital:TXBYHospital];
    [param setApp_type:TXBYApp_type];
    return param;
}

@end
