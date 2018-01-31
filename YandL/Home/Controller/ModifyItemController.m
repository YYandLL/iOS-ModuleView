//
//  TestViewController.m
//  TXBYModuleApp
//
//  Created by YandL on 16/10/24.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "ModifyItemController.h"
#import "ModifySectionController.h"
#import "DTColorPickerImageView.h"
#import "TXBYColorPickerView.h"

@interface ModifyItemController () <DTColorPickerImageViewDelegate>

/**
 *  <#desc#>
 */
@property (nonatomic, strong) NSArray *nameArr;

@end

@implementation ModifyItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.modifyItem.itemType == 5) {
        [self setupImageGroup];
    } else {
        [self setupGroup];
    }
    [self setFooter];
}

- (void)setupGroup {
    TXBYInputGroup *group = [TXBYInputGroup group];
    HomeItem *item = self.modifyItem;
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *orderArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"itemName" ofType:@"plist"]];
    NSArray *nameArr;
    for (NSDictionary *dic in orderArr) {
        if ([dic[@"itemType"] integerValue] == item.itemType) {
            nameArr = dic[@"names"];
            self.nameArr = nameArr;
            break;
        }
    }
    
    for (NSDictionary *dic in nameArr) {
        NSString *subtitle = [NSString stringWithFormat:@"%@",item.mj_keyValues[dic[@"key"]]];
        if ([dic[@"title"] containsString:@"色"]) {
            UIColor *color;
            if (![subtitle isEqualToString:@"(null)"]) {
                color = [UIColor colorWithChineseRGBString:subtitle];
                subtitle = @"██";
            }
            TXBYInputLabelItem *labelItem = [TXBYInputLabelItem itemWithTitle:dic[@"title"] titleScale:0.3 subtitle:subtitle];
            labelItem.subtitleFont = [UIFont systemFontOfSize:23];
            labelItem.subtitleColor = color;
            if (![subtitle isEqualToString:@"(null)"]) {
                [muArr addObject:labelItem];
            }
        } else {
            TXBYInputFieldItem *fieldItem = [TXBYInputFieldItem itemWithTitle:dic[@"title"] titleScale:0.3 subtitle:subtitle];
            if ([dic[@"keyboard"] isEqualToString:@"number"]) {
                fieldItem.keyboardType = UIKeyboardTypeNumberPad;
            }
            // 不是“更多”类型
            if (item.itemType != 3) {
                [muArr addObject:fieldItem];
            } else {
                if (![subtitle isEqualToString:@"(null)"]) {
                    if ([dic[@"title"] isEqualToString:@"图宽"] || [dic[@"title"] isEqualToString:@"图高"]) {
                        if (item.icon.length) {
                            [muArr addObject:fieldItem];
                        }
                    } else {
                        [muArr addObject:fieldItem];
                    }
                }
            }
        }
    }
    group.items = muArr;
    [self.groups addObject:group];
    
    TXBYInputGroup *group1 = [TXBYInputGroup group];
    TXBYInputLabelItem *item1 = [TXBYInputLabelItem itemWithTitle:@"修改Section" titleScale:0.33 subtitle:@"所属Section的样式"];
    item1.titleColor = [UIColor blackColor];
    item1.subtitleColor = [UIColor grayColor];
    item1.subtitleFont = [UIFont systemFontOfSize:13.0];
    group1.items = @[item1];
    [self.groups addObject:group1];
}

- (void)setupImageGroup {
    TXBYInputGroup *group = [TXBYInputGroup group];
    HomeItem *item = self.modifyItem;
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 0; i < item.images.count; i ++) {
        NSDictionary *dic = item.images[i];
        NSString *subtitle = [NSString stringWithFormat:@"%@",dic[@"image_url"]];
        TXBYInputFieldItem *fieldItem = [TXBYInputFieldItem itemWithTitle:[NSString stringWithFormat:@"第%d张", i + 1] titleScale:0.3 subtitle:subtitle];
        [muArr addObject:fieldItem];
    }
    group.items = muArr;
    [self.groups addObject:group];
    
    TXBYInputGroup *group1 = [TXBYInputGroup group];
    TXBYInputLabelItem *item1 = [TXBYInputLabelItem itemWithTitle:@"修改Section" titleScale:0.33 subtitle:@"所属Section的样式"];
    item1.titleColor = [UIColor blackColor];
    item1.subtitleColor = [UIColor grayColor];
    item1.subtitleFont = [UIFont systemFontOfSize:13.0];
    group1.items = @[item1];
    [self.groups addObject:group1];
}

- (void)requestToModify {
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Home/modify") parameters:[self indexValues].mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"errmsg"] toView:selfWeak.view animated:YES];
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestToModifyImages {
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Home/modify_images") parameters:[self imageIndexValues].mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"errmsg"] toView:selfWeak.view animated:YES];
//            NSLog(@"%@", responseObject);
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setFooter {
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, self.view.txby_width, 90);
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"修   改" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 20, self.view.txby_width, 45);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = ESMainColor;
    [footer addSubview:button];
    self.tableView.tableFooterView = footer;
}

- (void)submit {
    if (self.modifyItem.itemType == 5) {
        [self requestToModifyImages];
//        NSLog(@"%@", [self imageIndexValues].mj_keyValues);
    } else {
        [self requestToModify];
    }
}

/**
 *  通过索引取出输入的值
 */
- (NSDictionary *)indexValues {
    TXBYInputGroup *group = [self.groups firstObject];
    NSMutableDictionary *nameDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < group.items.count; i++) {
        TXBYInputItem *item = group.items[i];
        NSString *key;
        for (NSDictionary *dic in self.nameArr) {
            if ([dic[@"title"] isEqualToString:item.title]) {
                key = dic[@"key"];
                break;
            }
        }
        if ([item.title containsString:@"色"]) {
            NSString *colorStr = [NSString stringWithColor:item.subtitleColor];
            [nameDic setValue:colorStr forKey:key];
        } else {
            [nameDic setValue:item.subtitle forKey:key];
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:self.modifyItem.ID, @"ID", nameDic, @"data",nil];
}
/**
 *  通过索引取出输入的图片地址
 */
- (NSDictionary *)imageIndexValues {
    TXBYInputGroup *group = [self.groups firstObject];
    HomeItem *item = self.modifyItem;
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 0; i < item.images.count; i ++) {
        NSDictionary *dic = item.images[i];
        TXBYInputItem *item = group.items[i];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setValue:item.subtitle forKey:@"image_url"];
        [tempDic setValue:item.ID forKey:@"item_id"];
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
        [imageDic setValue:dic[@"ID"] forKey:@"ID"];
        [imageDic setValue:tempDic forKey:@"data"];
        [muArr addObject:imageDic];
        
    }
//    NSLog(@"%@", [NSDictionary dictionaryWithObject:muArr.mj_keyValues forKey:@"data"]);
    return [NSDictionary dictionaryWithObject:muArr.mj_JSONString forKey:@"data"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        TXBYInputGroup *group = [self.groups firstObject];
        TXBYInputItem *item = group.items[indexPath.row];
        if ([item.title containsString:@"色"]) {
            [self showColorPicker:indexPath.row];
        } else {
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    } else {
        ModifySectionController *modeVC = [[ModifySectionController alloc] init];
        modeVC.section = self.section;
        [self.navigationController pushViewController:modeVC animated:YES];
    }
}

// 显示颜色选择器
- (void)showColorPicker:(NSInteger)index {
    [self.view endEditing:YES];
    TXBYInputGroup *group = [self.groups firstObject];
    TXBYInputLabelItem *item = group.items[index];
    TXBYColorPickerView *pickerView = [[TXBYColorPickerView alloc] initWithShowAlpha:NO];
    [pickerView showPickerWithColor:item.subtitleColor block:^(UILabel *colorLabel) {
        [self reloadGroup:index color:colorLabel.backgroundColor];
    }];
}

// 刷新选择的颜色
- (void)reloadGroup:(NSInteger)index color:(UIColor *)color {
    TXBYInputGroup *group = [self.groups firstObject];
    TXBYInputLabelItem *item = group.items[index];
    item.subtitleColor = color;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[TXBYHTTPSessionManager sharedManager] cancelNetworkingWithNetIdentifier:TXBYClassName];
}

- (NSString *)title {
    return @"Item调整";
}

@end
