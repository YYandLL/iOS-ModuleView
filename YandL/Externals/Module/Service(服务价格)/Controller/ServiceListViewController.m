//
//  ServiceListViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "ServiceListViewController.h"
#import "ServiceItem.h"
#import "ServiceDetailViewController.h"

@interface ServiceListViewController ()

@end

@implementation ServiceListViewController

#pragma mark - setters
/**
 *  设置ServiceItem模型数组
 */
- (void)setServiceItems:(NSArray *)serviceItems
{
    _serviceItems = serviceItems;
    
    // 转成ESListItem模型数组
    NSMutableArray *arrayM = [NSMutableArray array];
    for (ServiceItem *item in self.serviceItems)
    {
        TXBYListItem *listItem = [TXBYListItem itemWithTitle:item.name subtitle:item.price];
        [arrayM addObject:listItem];
    }
    self.items = arrayM;
}

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - super
/**
 *  导航栏标题
 */
- (NSString *)title
{
    return @"查询结果";
}

/**
 *  点击某一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    ServiceDetailViewController *vc = [[ServiceDetailViewController alloc] init];
    vc.item = self.serviceItems[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end