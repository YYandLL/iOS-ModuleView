//
//  DrugListViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

#import "DrugListViewController.h"
#import "DrugList.h"
#import "Drug.h"
#import "DrugParam.h"
#import "TXBYListItem.h"
#import "DrugDetailViewController.h"

@interface DrugListViewController ()

/**
 *  Drug模型数组
 */
@property (nonatomic, strong) NSArray *drugs;

@end

@implementation DrugListViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 发送网络请求
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
 *  发送网络请求
 */
- (void)request
{
    // 1. 加载提示
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    // 2. 请求参数
    DrugParam *param = [[DrugParam alloc] init];
    param.mtid = self.item.mtid;
    param.mtids = self.item.mtids;
    if ([param.mtid isEqualToString:@"-1"])
    {
        param.cpm = self.item.name;
    }
    
    // 3. 发送请求
    [[TXBYHTTPSessionManager sharedManager] get:TXBYDrugListAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        
        // 转成Drug模型数组
        self.drugs = [Drug mj_objectArrayWithKeyValuesArray:responseObject];
        if (!self.drugs.count)
        {
            TXBYAlert(@"没有相关数据")
            return;
        }
        // 转成ESListItem模型数组
        NSMutableArray *arrayM = [NSMutableArray array];
        for (Drug *drug in self.drugs)
        {
            TXBYListItem *item = [[TXBYListItem alloc] init];
            item.title = drug.cpm;
            item.subtitle = drug.scs_desc;
            [arrayM addObject:item];
        }
        self.items = arrayM;
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        // 网络加载失败
        [self requestFailure:error];
    }];
}

#pragma mark - super
/**
 *  导航栏标题
 */
- (NSString *)title
{
    return [self.item.mtid isEqualToString:@"-1"] ? @"搜索结果" : self.item.name;
}

/**
 *  点击某一行
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    DrugDetailViewController *vc = [[DrugDetailViewController alloc] init];
    vc.drug = self.drugs[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end