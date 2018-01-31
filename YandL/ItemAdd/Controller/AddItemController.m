//
//  AddItemController.m
//  YandL
//
//  Created by YandL on 16/12/22.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "AddItemController.h"
#import "AddSectionItem.h"
#import "TXBYColorPickerView.h"

@interface AddItemController ()
/**
 *  模型
 */
@property (nonatomic, strong) NSArray *modelArr;

@end

@implementation AddItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroup];
    [self setFooter];
}

- (NSArray *)modelArr {
    if (!_modelArr) {
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addItemName" ofType:@"plist"]];
        for (NSDictionary *dic in arr) {
            if ([dic[@"itemType"] intValue] == [self.itemType intValue]) {
                if (self.subType.length && [dic[@"itemType"] intValue] == 3) {
                    if ([dic[@"subType"] intValue] == [self.subType intValue]) {
                        _modelArr = [AddSectionItem mj_objectArrayWithKeyValuesArray:dic[@"names"]];
                        break;
                    }
                } else {
                    _modelArr = [AddSectionItem mj_objectArrayWithKeyValuesArray:dic[@"names"]];
                    break;
                }
            }
        }
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

- (void)setupGroup {
    TXBYInputGroup *group = [TXBYInputGroup group];
    NSMutableArray *muArr = [NSMutableArray array];
    for (AddSectionItem *item in self.modelArr) {
        //        NSString *subtitle = item.;
        if ([item.title containsString:@"色"]) {
            UIColor *color = [UIColor colorWithChineseRGBString:item.place];
            NSString *subtitle = @"██";
            TXBYInputLabelItem *labelItem = [TXBYInputLabelItem itemWithTitle:item.title titleScale:0.3 subtitle:subtitle];
            labelItem.subtitleFont = [UIFont systemFontOfSize:23];
            labelItem.subtitleColor = color;
            [muArr addObject:labelItem];
        } else if ([item.title containsString:@"显示"]) {
            TXBYInputLabelItem *fieldItem = [TXBYInputLabelItem itemWithTitle:item.title titleScale:0.35 subtitle:item.subtitle];
            [muArr addObject:fieldItem];
        } else {
            TXBYInputFieldItem *fieldItem = [TXBYInputFieldItem itemWithTitle:item.title titleScale:0.3 subtitle:@""];
            fieldItem.placeholder = item.place;
            if ([item.keyboard isEqualToString:@"number"]) {
                fieldItem.keyboardType = UIKeyboardTypeNumberPad;
            }
            [muArr addObject:fieldItem];
        }
    }
    group.items = muArr;
    [self.groups addObject:group];
}

- (void)submit {
    if (self.isNewitem) {
        self.block([self indexValues].mj_keyValues);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([self canSubmit]) {
            [self requestToAdd];
        }
    }
}

- (void)requestToAdd {
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Add/addItem") parameters:[self indexValues].mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"errmsg"] toView:selfWeak.view animated:YES];
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        
    }];
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
            NSString *colorStr = [NSString stringWithColor:item.subtitleColor];
            [nameDic setValue:colorStr forKey:key];
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
    if (self.section_item_id.length) {
        if (self.isSubitem) {
            [nameDic setValue:self.section_item_id forKey:@"section_item_id"];
        } else {
            [nameDic setValue:self.section_item_id forKey:@"item_id"];
        }
    }
    [nameDic setValue:self.itemType forKey:@"itemType"];
    return [NSDictionary dictionaryWithObjectsAndKeys:nameDic, @"data",nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TXBYInputGroup *group = [self.groups firstObject];
    TXBYInputItem *item = group.items[indexPath.row];
    if ([item.title containsString:@"色"]) {
        [self showColorPicker:indexPath.row];
    } else if ([item.title containsString:@"显示"]) {
        [self showActionView:indexPath.row];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
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
    TXBYColorPickerView *pickerView = [[TXBYColorPickerView alloc] initWithShowAlpha:NO];
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
    NSInteger type = [self.itemType integerValue];
    return (type == 1)? @"默认类型":(type == 2)? @"左右类型":(type == 3)? @"更多式横栏":(type == 5)? @"轮播图样式": @"含子Section样式";
}

@end
