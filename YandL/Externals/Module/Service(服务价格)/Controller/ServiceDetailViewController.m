//
//  ServiceDetailViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "ServiceItem.h"
#import "ServiceParam.h"

@interface ServiceDetailViewController ()

@end

@implementation ServiceDetailViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.item.Code) // 模型中已经有详情数据了
    {
        // 添加groups数据
        [self setupGroups];
        return;
    }
    // 网络请求
    [self request];
}

/**
 *  销毁
 */
- (void)dealloc
{
    // 取消网络请求
    [[TXBYHTTPSessionManager sharedManager] cancelAllNetworking];
}

#pragma mark - private
/**
 *  网络请求
 */
- (void)request {
    // 请求参数
    ServiceParam *param = [ServiceParam param];
    param.act = @"detail";
    param.Code = self.item.ID;
    
    // 发送请求
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[TXBYHTTPSessionManager sharedManager] get:TXBYServiceAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.item detailWithDict:[responseObject lastObject]];
        // 添加groups数据
        [self setupGroups];
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        // 网络加载失败
        [self requestFailure:error];
    }];
}

#pragma mark - private
/**
 *  添加groups数据
 */
- (void)setupGroups
{
    // 加载plist文件
    NSArray *array = [NSArray arrayWithContentsOfFile:[NSString pathForResource:@"service.bundle/serviceDetail"]];
    // 数据
    NSMutableArray *arrayM = [NSMutableArray array];
    NSDictionary *drugDict = self.item.mj_keyValues;
    for (NSDictionary *dict in array)
    {
        NSString *title = dict[@"title"];
        NSString *subtitle = drugDict[dict[@"subtitle"]];
        subtitle = [subtitle isEqualToString:@"null"] ? @"" : subtitle;
        TXBYInputLabelItem *item = [TXBYInputLabelItem itemWithTitle:title subtitle:subtitle];
        [arrayM addObject:item];
    }
    
    // 创建组
    TXBYInputGroup *group = [TXBYInputGroup group];
    group.items = arrayM;
    [self.groups addObject:group];
    
    // 刷新表格
    [self.tableView reloadData];
}

#pragma mark - super
/**
 *  导航栏标题
 */
- (NSString *)title
{
    return @"详细信息";
}

@end