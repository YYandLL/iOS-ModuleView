//
//  IndexViewController.m
//  YandL
//
//  Created by YandL on 16/12/16.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "IndexViewController.h"
#import "HomeViewController.h"
#import "TXBYAlertView.h"

@interface IndexViewController ()
/**
 *  <#desc#>
 */
@property (nonatomic, strong) NSArray *modelArr;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  添加导航栏按钮
 */
- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
}

- (void)addClick {
    TXBYAlertView *alertView = [TXBYAlertView alertWithTitle:@"提醒" message:@"确定添加一个新模板吗？" buttonTitles:@"取消", @"添加", nil];
    [alertView showWithClickBlock:^(NSInteger index) {
        if (index == 1) {
            WeakSelf;
            [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Add/addModel") parameters:[NSDictionary dictionaryWithObject:@"yes" forKey:@"sure"].mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
                if ([responseObject[@"errcode"] integerValue] == 200) {
                    [MBProgressHUD showSuccess:responseObject[@"errmsg"] toView:selfWeak.view animated:YES];
                    [self.tableView.mj_header beginRefreshing];
                } else {
                    [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}

- (void)setRefresh {
    //添加下拉刷新
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshModelView)];
    normalHeader.ignoredScrollViewContentInsetTop = -30;
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = normalHeader;
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshModelView {
    [self requestForAllType];
}

- (void)requestForAllType {
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Home") parameters:nil netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 200) {
            selfWeak.modelArr = [NSArray arrayWithArray:responseObject[@"data"]];
            [self.tableView.mj_header endRefreshing];
            [selfWeak setupGroup];
            if (AppModify) {
                [self setupNav];
            }
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupGroup {
    TXBYSettingGroup *group = [TXBYSettingGroup group];
    for (NSDictionary *dic in self.modelArr) {
        TXBYSettingLabelItem *item = [TXBYSettingLabelItem itemWithTitle:[NSString stringWithFormat:@"排版%@", dic[@"model_id"]] icon:@"tool_map"];
        item.subtitle = [NSString stringWithFormat:@"第%@种自定义样式", dic[@"model_id"]];
        
        [group addItem:item];
    }
    [self.groups removeAllObjects];
    [self.groups addObject:group];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.modelArr[indexPath.row];
    HomeViewController *VC = [[HomeViewController alloc] init];
    VC.title = [NSString stringWithFormat:@"排版%@", dic[@"model_id"]];
    VC.model_id = dic[@"model_id"];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
