//
//  HomeItem.m
//  TXBYModuleApp
//
//  Created by YandL on 16/10/21.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "HomeItem.h"
@implementation HomeSection

/**
 *  实现这个方法的目的：告诉MJExtension框架items数组里面装的是什么模型
 */
+ (NSDictionary *)objectClassInArray {
    return @{@"items" : [HomeItem class]};
}
@end

@implementation HomeItem
/**
 *  实现这个方法的目的：告诉MJExtension框架items数组里面装的是什么模型
 */
+ (NSDictionary *)objectClassInArray {
    return @{@"section" : [HomeSection class]};
}
@end
