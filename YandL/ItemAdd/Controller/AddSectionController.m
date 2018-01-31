//
//  AddModelController.m
//  YandL
//
//  Created by YandL on 16/12/21.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "AddSectionController.h"
#import "AddSectionItem.h"
#import "TXBYColorPickerView.h"
#import "AddItemController.h"
#import "AddScrollImageController.h"

@interface AddSectionController ()
/**
 *  模型
 */
@property (nonatomic, strong) NSArray *modelArr;

/**
 *  <#desc#>
 */
@property (nonatomic, strong) NSDictionary *itemDic;

/**
 *  <#desc#>
 */
@property (nonatomic, assign) BOOL isScrollSection;

@end

@implementation AddSectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroup];
    [self setFooter];
}

- (NSArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [AddSectionItem mj_objectArrayWithFilename:@"addSectionName.plist"];
    }
    return _modelArr;
}

- (void)setFooter {
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, self.view.txby_width, 90);
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"添   加" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 20, self.view.txby_width, 45);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = ESMainColor;
    [footer addSubview:button];
    self.tableView.tableFooterView = footer;
}

- (void)submit {
    if ([self canSubmit]) {
        if (!self.isSubSection) {
            if (self.isScrollSection) {
                NSDictionary *tempDic = [NSMutableDictionary dictionary];
                [tempDic setValue:@"5" forKey:@"itemType"];
                [tempDic setValue:@"1" forKey:@"viewScale"];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.itemDic[@"data"], @"image", [self indexValues][@"data"], @"section", tempDic, @"item", self.model_id, @"model_id", nil];
                NSLog(@"%@", dic.mj_keyValues);
                [self requestToAddImageSection:dic];
            } else {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.itemDic[@"data"], @"item", [self indexValues][@"data"], @"section", self.model_id, @"model_id", nil];
                NSLog(@"%@", dic.mj_keyValues);
                [self requestToAddSection:dic];
            }
        } else {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.itemDic[@"data"], @"item", [self indexValues][@"data"], @"section", nil];
            NSLog(@"%@", dic.mj_keyValues);
            [self requestToAddSubSection:dic];
        }
    }
}

- (void)requestToAddSection:(NSDictionary *)paramDic {
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Add/addSection") parameters:paramDic.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"errcode"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"errmsg"] toView:selfWeak.view animated:YES];
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestToAddImageSection:(NSDictionary *)paramDic {
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Add/addImageSection") parameters:paramDic.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"errmsg"] toView:selfWeak.view animated:YES];
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestToAddSubSection:(NSDictionary *)paramDic {
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Add/addSubSection") parameters:paramDic.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"errcode"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"errmsg"] toView:selfWeak.view animated:YES];
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupGroup {
    TXBYInputGroup *group = [TXBYInputGroup group];
    NSMutableArray *muArr = [NSMutableArray array];
    for (AddSectionItem *item in self.modelArr) {
        if ([item.title containsString:@"色"]) {
            NSString *subtitle;
            UIColor *color;
            if ([item.place isEqualToString:@"clear"]) {
                subtitle = @"透明";
            } else {
                color = [UIColor colorWithChineseRGBString:subtitle];
                subtitle = @"██";
            }
            TXBYInputLabelItem *labelItem = [TXBYInputLabelItem itemWithTitle:item.title titleScale:0.35 subtitle:subtitle];
            if (color) {
                labelItem.subtitleFont = [UIFont systemFontOfSize:23.0];
                labelItem.subtitleColor = color;
            }
            [muArr addObject:labelItem];
        } else if ([item.title containsString:@"显示"]) {
            TXBYInputLabelItem *fieldItem = [TXBYInputLabelItem itemWithTitle:item.title titleScale:0.35 subtitle:item.subtitle];
            [muArr addObject:fieldItem];
        } else {
            TXBYInputFieldItem *fieldItem = [TXBYInputFieldItem itemWithTitle:item.title titleScale:0.35 subtitle:@""];
            fieldItem.placeholder = item.place;
            if ([item.keyboard isEqualToString:@"number"]) {
                fieldItem.keyboardType = UIKeyboardTypeNumberPad;
            }
            [muArr addObject:fieldItem];
        }
    }
    group.items = muArr;
    [self.groups addObject:group];
    
    TXBYInputGroup *group1 = [TXBYInputGroup group];
    TXBYInputLabelItem *item1 = [TXBYInputLabelItem itemWithTitle:@"添加Item" titleScale:0.35 subtitle:@"给Section添加一个item"];
    item1.titleColor = [UIColor blackColor];
    item1.subtitleColor = [UIColor grayColor];
    item1.subtitleFont = [UIFont systemFontOfSize:13.0];
    group1.items = @[item1];
    [self.groups addObject:group1];
}


- (BOOL)canSubmit {
    TXBYInputGroup *group = [self.groups firstObject];
    for (int i = 0; i < group.items.count; i++) {
        TXBYInputItem *item = group.items[i];
        if (!item.subtitle.length) {
            [MBProgressHUD showInfo:@"请完善内容" toView:self.view];
            return NO;
        }
    }
    if (!self.itemDic) {
        [MBProgressHUD showInfo:@"请给Section添加一个item" toView:self.view];
        return NO;
    }
    return YES;
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
        for (AddSectionItem *sectionItem in self.modelArr) {
            if ([sectionItem.title isEqualToString:item.title]) {
                key = sectionItem.key;
                break;
            }
        }
        
        if ([item.title containsString:@"色"]) {
            if ([item.subtitle isEqualToString:@"透明"]) {
                [nameDic setValue:@"clear" forKey:key];
            } else{
                NSString *colorStr = [NSString stringWithColor:item.subtitleColor];
                [nameDic setValue:colorStr forKey:key];
            }
        } else if ([item.title containsString:@"显示"]) {
            if ([item.subtitle isEqualToString:@"显示"]) {
                [nameDic setValue:@"1" forKey:key];
            } else{
                [nameDic setValue:@"0" forKey:key];
            }
        } else {
            [nameDic setValue:item.subtitle forKey:key];
        }
    }
    if (self.isSubSection) {
        [nameDic setValue:@"0" forKey:@"is_index_item"];
        [nameDic setValue:self.section_item_id forKey:@"section_item_id"];
    } else {
        [nameDic setValue:@"1" forKey:@"is_index_item"];
        [nameDic setValue:@"0" forKey:@"section_item_id"];
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:nameDic, @"data",nil];
}

- (void)addItem {
    [self.view endEditing:YES];
    AddItemController *VC = [[AddItemController alloc] init];
    VC.isNewitem = YES;
    [VC setBlock:^(NSDictionary *dic) {
        self.itemDic = dic;
        [self addItemSucceedReload];
    }];
    if (self.isSubSection) {
        VC.isSubitem = YES;
        VC.section_item_id = self.section_item_id;
    }
    TXBYActionSheetItem *item1 = [TXBYActionSheetItem itemWithTitle:@"默认类型" subtitle:@"图片居上,文字居下" operation:^{
        VC.itemType = @"1";
        [self.navigationController pushViewController:VC animated:YES];
    }];
    TXBYActionSheetItem *item2 = [TXBYActionSheetItem itemWithTitle:@"左右类型" subtitle:@"图片居左,文字居右" operation:^{
        VC.itemType = @"2";
        [self.navigationController pushViewController:VC animated:YES];
    }];
    TXBYActionSheetItem *item3 = [TXBYActionSheetItem itemWithTitle:@"更多式横栏" subtitle:@"右侧带按钮" operation:^{
        TXBYActionSheetItem *item31 = [TXBYActionSheetItem itemWithTitle:@"左侧图片,右侧图片" operation:^{
            VC.itemType = @"3";
            VC.subType = @"1";
            [self.navigationController pushViewController:VC animated:YES];
        }];
        TXBYActionSheetItem *item32 = [TXBYActionSheetItem itemWithTitle:@"左侧图片,右侧文字" operation:^{
            VC.itemType = @"3";
            VC.subType = @"2";
            [self.navigationController pushViewController:VC animated:YES];
        }];
        TXBYActionSheetItem *item33 = [TXBYActionSheetItem itemWithTitle:@"左侧文字,右侧图片" operation:^{
            VC.itemType = @"3";
            VC.subType = @"3";
            [self.navigationController pushViewController:VC animated:YES];
        }];
        TXBYActionSheetItem *item34 = [TXBYActionSheetItem itemWithTitle:@"左侧文字,右侧文字" operation:^{
            VC.itemType = @"3";
            VC.subType = @"4";
            [self.navigationController pushViewController:VC animated:YES];
        }];
        TXBYActionSheet *actionSheet = [TXBYActionSheet actionSheetWithTitle:@"选择详细类型" otherButtonItems:@[item31, item32, item33, item34]];
        [actionSheet show];
    }];
    if (self.isSubSection) {
        TXBYActionSheet *actionSheet1 = [TXBYActionSheet actionSheetWithTitle:@"选择添加类型" otherButtonItems:@[item1, item2, item3]];
        [actionSheet1 show];
    } else {
        TXBYActionSheetItem *item4 = [TXBYActionSheetItem itemWithTitle:@"轮播图样式" operation:^{
            AddScrollImageController *scrollVC = [[AddScrollImageController alloc] init];
            scrollVC.isNew = YES;
            [scrollVC setBlock:^(NSDictionary *dic) {
                self.isScrollSection = YES;
                self.itemDic = dic;
                [self addItemSucceedReload];
            }];
            [self.navigationController pushViewController:scrollVC animated:YES];
        }];
        
        TXBYActionSheetItem *item5 = [TXBYActionSheetItem itemWithTitle:@"含子Section样式" operation:^{
            VC.itemType = @"4";
            [self.navigationController pushViewController:VC animated:YES];
        }];
        
        TXBYActionSheet *actionSheet1 = [TXBYActionSheet actionSheetWithTitle:@"选择添加类型" otherButtonItems:@[item1, item2, item3, item4, item5]];
        [actionSheet1 show];
    }
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
        if (self.itemDic) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.userInteractionEnabled = NO;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = YES;
        }
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
        } else if ([item.title containsString:@"显示"]) {
            [self showActionView:indexPath.row];
        } else {
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    } else {
        [self addItem];
    }
}

- (void)addItemSucceedReload {
    TXBYInputGroup *group = [self.groups lastObject];
    TXBYInputLabelItem *item = group.items[0];
    item.subtitle = @"已添加item";
    [self.tableView reloadData];
}

- (void)showActionView:(NSInteger)index {
    [self.view endEditing:YES];
    TXBYActionSheetItem *item1 = [TXBYActionSheetItem itemWithTitle:@"显示" operation:^{
        [self reloadShow:index show:YES];
    }];
    TXBYActionSheetItem *item2 = [TXBYActionSheetItem itemWithTitle:@"不显示" operation:^{
        [self reloadShow:index show:NO];
    }];
    TXBYActionSheet *actionSheet = [TXBYActionSheet actionSheetWithTitle:@"是否显示" otherButtonItems:@[item1, item2]];
    [actionSheet show];
}

// 刷新显示
- (void)reloadShow:(NSInteger)index show:(BOOL)show {
    TXBYInputGroup *group = [self.groups firstObject];
    TXBYInputLabelItem *item = group.items[index];
    if (show) {
        item.subtitle = @"显示";
    } else {
        item.subtitle = @"不显示";
    }
    [self.tableView reloadData];
}

// 显示颜色选择器
- (void)showColorPicker:(NSInteger)index {
    [self.view endEditing:YES];
    TXBYInputGroup *group = [self.groups firstObject];
    TXBYInputLabelItem *item = group.items[index];
    TXBYColorPickerView *pickerView = [[TXBYColorPickerView alloc] initWithShowAlpha:YES];
    [pickerView showPickerWithColor:item.subtitleColor block:^(UILabel *colorLabel) {
        [self reloadGroup:index color:colorLabel];
    }];
}

// 刷新选择的颜色
- (void)reloadGroup:(NSInteger)index color:(UILabel *)colorLabel {
    TXBYInputGroup *group = [self.groups firstObject];
    TXBYInputLabelItem *item = group.items[index];
    if (colorLabel.text.length) {
        item.subtitleColor = [UIColor blackColor];
        item.subtitleFont = [UIFont systemFontOfSize:16.0];
        item.subtitle = @"透明";
    } else {
        item.subtitleColor = colorLabel.backgroundColor;
        item.subtitleFont = [UIFont systemFontOfSize:23.0];
        item.subtitle = @"██";
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)title {
    return (self.isSubSection)? @"添加子Section": @"添加Section";
}

@end
