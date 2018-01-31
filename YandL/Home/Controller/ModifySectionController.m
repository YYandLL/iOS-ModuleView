//
//  ModifySectionController.m
//  YandL
//
//  Created by YandL on 16/12/20.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "ModifySectionController.h"
#import "ModifySectionItem.h"
#import "TXBYColorPickerView.h"

@interface ModifySectionController ()

/**
 *  模型
 */
@property (nonatomic, strong) NSArray *modelArr;

@end

@implementation ModifySectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroup];
    [self setFooter];
}

- (NSArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sectionName" ofType:@"plist"]];;
    }
    return _modelArr;
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
    [self requestToModify];
}

- (void)requestToModify {
    WeakSelf;
    NSLog(@"%@", [self indexValues].mj_keyValues);
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Home/modify_section") parameters:[self indexValues].mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
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
    HomeSection *section = self.section;
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 0; i < self.modelArr.count; i ++) {
        NSDictionary *dic = self.modelArr[i];
        NSString *subtitle = [NSString stringWithFormat:@"%@", section.mj_keyValues[dic[@"key"]]];
        if ([dic[@"title"] containsString:@"色"]) {
            UIColor *color;
            if ([subtitle isEqualToString:@"clear"]) {
                subtitle = @"透明";
            } else {
                color = [UIColor colorWithChineseRGBString:subtitle];
                subtitle = @"██";
            }
            TXBYInputLabelItem *labelItem = [TXBYInputLabelItem itemWithTitle:dic[@"title"] titleScale:0.35 subtitle:subtitle];
            if (color) {
                labelItem.subtitleFont = [UIFont systemFontOfSize:23.0];
                labelItem.subtitleColor = color;
            }
            [muArr addObject:labelItem];
        } else if ([dic[@"title"] containsString:@"显示"]) {
            if ([subtitle intValue] == 1) {
                subtitle = @"显示";
            } else {
                subtitle = @"不显示";
            }
            TXBYInputLabelItem *fieldItem = [TXBYInputLabelItem itemWithTitle:dic[@"title"] titleScale:0.35 subtitle:subtitle];
            [muArr addObject:fieldItem];
        } else {
            TXBYInputFieldItem *fieldItem = [TXBYInputFieldItem itemWithTitle:dic[@"title"] titleScale:0.35 subtitle:subtitle];
            if ([dic[@"keyboard"] isEqualToString:@"number"]) {
                fieldItem.keyboardType = UIKeyboardTypeNumberPad;
            }
            [muArr addObject:fieldItem];
        }
    }
    group.items = muArr;
    [self.groups addObject:group];
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
        for (NSDictionary *dic in self.modelArr) {
            if ([dic[@"title"] isEqualToString:item.title]) {
                key = dic[@"key"];
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
    return [NSDictionary dictionaryWithObjectsAndKeys:self.section.ID, @"ID", nameDic, @"data",nil];
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
    return @"Section调整";
}

@end
