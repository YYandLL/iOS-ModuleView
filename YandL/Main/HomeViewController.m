//
//  HomeViewController.m
//  YandL
//
//  Created by YandL on 16/12/14.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "HomeViewController.h"
#import "TXBYAlertView.h"
#import "TXBYScrollView.h"
#import "HomeItem.h"
#import "HomeMetroView.h"
#import "ModifyItemController.h"
#import "AddSectionController.h"
#import "AddItemController.h"
#import "AddScrollImageController.h"

@interface HomeViewController ()
/**
 *  headerView
 */
@property (nonatomic, weak) UIView *headerView;
/**
 *  <#desc#>
 */
@property (nonatomic, strong) NSArray *metroArr;
/**
 *  <#desc#>
 */
@property (nonatomic, strong) NSArray *objectArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self setRefresh];
}

- (void)setRefresh {
    //添加下拉刷新
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = normalHeader;
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshView {
    [self requestForView];
}

- (NSString *)model_id {
    if (!_model_id) {
        return @"3";
    }
    return _model_id;
}

- (void)requestForView {
    [self deleteEmptyText];
    WeakSelf;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.model_id forKey:@"model_id"];
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Home/test") parameters:dic.mj_keyValues netIdentifier:[NSString stringWithFormat:@"%@%@", TXBYClassName,self.model_id] success:^(id responseObject) {
        [selfWeak.tableView.mj_header endRefreshing];
        if (AppModify) {
            [selfWeak setupNav];
        }
        if ([responseObject[@"errcode"] integerValue] == 200) {
            selfWeak.tableView.tableHeaderView = [UIView new];
            selfWeak.metroArr = [HomeSection mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            selfWeak.objectArr = responseObject[@"data"];
            [selfWeak setUpHeaderView];
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
            [selfWeak emptyViewWithText:@"暂时没有页面数据..\n点击右上角添加一个Section"];
        }
    } failure:^(NSError *error) {
        [selfWeak.tableView.mj_header endRefreshing];
    }];
}

- (void)objectHomeItem:(NSInteger)itemID isEdit:(BOOL)edit {
    HomeItem *selectedItem;
    HomeSection *section;
    HomeSection *subsection;
    NSInteger sectionID = 0;
    NSInteger itemType = 0;
    for (int i = 0; i < self.metroArr.count; i ++) {
        if (!selectedItem) {
            section = self.metroArr[i];
            for (HomeItem *item in section.items) {
                if ([item.ID integerValue] == itemID) {
                    selectedItem = item;
                    itemType = item.itemType;
                    subsection = nil;
                    break;
                }
                if (!selectedItem) {
                    if (item.section.count) {
                        for (int j = 0; j < item.section.count; j ++) {
                            if (!selectedItem) {
                                subsection = item.section[j];
                                for (HomeItem *subitem in subsection.items) {
                                    if ([subitem.ID integerValue] == itemID) {
                                        selectedItem = subitem;
                                        itemType = subitem.itemType;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if (edit) {
        ModifyItemController *modeView = [[ModifyItemController alloc] init];
        modeView.modifyItem = [HomeItem mj_objectWithKeyValues:selectedItem.mj_keyValues];
        modeView.modifyItem.section = nil;
        if (subsection) {
            modeView.section = subsection;
        } else {
            modeView.section = section;
        }
        [self.navigationController pushViewController:modeView animated:YES];
    } else {
        BOOL isSubitem = NO;
        if ([selectedItem.section_item_id integerValue] > 0) {
            sectionID = [selectedItem.section_item_id integerValue];
            isSubitem = YES;
        } else {
            sectionID = [selectedItem.item_id integerValue];
        }
        [self addSectionItem:sectionID itemType:itemType isSubitem:isSubitem];
    }
}

/**
 *  添加导航栏按钮
 */
- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick1)];
}


- (void)addSectionItem:(NSInteger)sectionID itemType:(NSInteger)type isSubitem:(BOOL)isSubitem {
    if (type == 3) {
        [MBProgressHUD showInfo:@"此类section只需一个item" toView:self.view];
        return;
    } else {
        AddItemController *VC = [[AddItemController alloc] init];
        VC.itemType = [NSString stringWithFormat:@"%ld", type];
        VC.section_item_id = [NSString stringWithFormat:@"%ld", sectionID];
        VC.isSubitem = isSubitem;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
}

- (NSString *)haveSubSection:(NSInteger)itemID {
    for (int i = 0; i < self.metroArr.count; i ++) {
        HomeSection *section = self.metroArr[i];
        for (HomeItem *item in section.items) {
            if ([item.ID integerValue] == itemID) {
                if (item.viewScale) {
                    return item.item_id;
                }
            }
        }
    }
    return @"";
}

- (void)addClick1 {
    TXBYActionSheetItem *item1 = [TXBYActionSheetItem itemWithTitle:@"添加一个Section" operation:^{
        AddSectionController *VC = [[AddSectionController alloc] init];
        VC.isSubSection = NO;
        VC.model_id = self.model_id;
        [self.navigationController pushViewController:VC animated:YES];
    }];
//    TXBYActionSheetItem *item2 = [TXBYActionSheetItem itemWithTitle:@"添加一个子Section" operation:^{
//        AddSectionController *VC = [[AddSectionController alloc] init];
//        VC.isSubSection = YES;
//        VC.model_id = self.model_id;
//        [self.navigationController pushViewController:VC animated:YES];
//    }];
    
    TXBYActionSheet *actionSheet1 = [TXBYActionSheet actionSheetWithTitle:@"选择添加类型" otherButtonItems:@[item1]];
    [actionSheet1 show];
}

- (void)setUpHeaderView {
    UIView *view = [[UIView alloc] init];
    self.headerView = view;
    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    //头文件的高度
    view.frame = CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationW / 2.1);
    //添加itemView
    [self setupMetroView];
    
    self.tableView.tableHeaderView = view;
    
}

/**
 *  点击事件
 */
//- (void)confirm {
//    [[TXBYAlertView alertWithTitle:@"我是首页" message:@"你想要干嘛" buttonTitles:@"不干嘛", nil] showWithClickBlock:^(NSInteger index) {
//        NSLog(@"%ld", index);
//        
//    }];
//}

/**
 *  设置视图item
 */
- (void)setupMetroView {
    HomeMetroView *metroView = [HomeMetroView metroViewWith:self.metroArr click:^(NSIndexPath *indexPath) {
        if (AppModify) {
            if (indexPath.section == -1) {
                TXBYActionSheetItem *item1 = [TXBYActionSheetItem itemWithTitle:@"编辑这个item" operation:^{
                    [self objectHomeItem:indexPath.row isEdit:YES];
                }];
                NSString *section_item_id = [self haveSubSection:indexPath.row];
                if (section_item_id.length) {
                    TXBYActionSheetItem *item3 = [TXBYActionSheetItem itemWithTitle:@"添加一个子Section" operation:^{
                        AddSectionController *VC = [[AddSectionController alloc] init];
                        VC.isSubSection = YES;
                        VC.section_item_id = section_item_id;
                        [self.navigationController pushViewController:VC animated:YES];
                    }];
                    TXBYActionSheet *actionSheet1 = [TXBYActionSheet actionSheetWithTitle:@"选择您的操作" otherButtonItems:@[item1, item3]];
                    [actionSheet1 show];
                } else {
                    TXBYActionSheetItem *item2 = [TXBYActionSheetItem itemWithTitle:@"添加一个item" operation:^{
                        [self objectHomeItem:indexPath.row isEdit:NO];
                    }];
                    TXBYActionSheet *actionSheet1 = [TXBYActionSheet actionSheetWithTitle:@"选择您的操作" otherButtonItems:@[item1, item2]];
                    [actionSheet1 show];
                }
            } else {
                TXBYActionSheetItem *item1 = [TXBYActionSheetItem itemWithTitle:@"编辑轮播图" operation:^{
                    [self objectHomeItem:indexPath.section isEdit:YES];
                }];
                TXBYActionSheetItem *item2 = [TXBYActionSheetItem itemWithTitle:@"添加轮播图" operation:^{
                    AddScrollImageController *vc = [[AddScrollImageController alloc] init];
                    vc.itemID = [NSString stringWithFormat:@"%ld", indexPath.section];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                TXBYActionSheet *actionSheet1 = [TXBYActionSheet actionSheetWithTitle:@"选择您的操作" otherButtonItems:@[item1, item2]];
                [actionSheet1 show];
            }
        } else {
            NSString *str;
            if (indexPath.section == -1) {
                str = [NSString stringWithFormat:@"你点击了第%ld个item", indexPath.row];
            } else {
                str = [NSString stringWithFormat:@"你点击了第%ld个item的第%ld张图片", indexPath.section, indexPath.row];
            }
            [[TXBYAlertView alertWithTitle:@"温馨提示" message:str buttonTitles:@"好的", nil] showWithClickBlock:^(NSInteger index) {
                NSLog(@"%ld", index);
            }];
        }
    }];
    self.headerView.txby_height = metroView.metroHeight;
    [self.headerView addSubview:metroView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[TXBYHTTPSessionManager sharedManager] cancelNetworkingWithNetIdentifier:[NSString stringWithFormat:@"%@%@", TXBYClassName,self.model_id]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


@end
