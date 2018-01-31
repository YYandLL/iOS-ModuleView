//
//  AddScrollImageController.m
//  YandL
//
//  Created by YandL on 16/12/23.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "AddScrollImageController.h"
#import "AddImageCell.h"

@interface AddScrollImageController ()

@end

@implementation AddScrollImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroup];
    [self setFooter];
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
    if (self.isNew) {
        self.block([self indexValues].mj_keyValues);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self requestToAddImage];
    }
}

- (void)setupGroup {
    TXBYInputGroup *group = [TXBYInputGroup group];
    NSMutableArray *muArr = [NSMutableArray array];
    TXBYInputFieldItem *fieldItem = [TXBYInputFieldItem itemWithTitle:@"图片地址" titleScale:0.35 subtitle:@""];
    fieldItem.keyboardType = UIKeyboardTypeURL;
    fieldItem.placeholder = @"添加图片的url";
    [muArr addObject:fieldItem];
    group.items = muArr;
    [self.groups addObject:group];
}

- (void)addAnItem {
    TXBYInputGroup *group = [self.groups firstObject];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:group.items];
    TXBYInputFieldItem *fieldItem = [TXBYInputFieldItem itemWithTitle:@"图片地址" titleScale:0.35 subtitle:@""];
    fieldItem.keyboardType = UIKeyboardTypeURL;
    fieldItem.placeholder = @"添加图片的url";
    [muArr addObject:fieldItem];
    group.items = muArr;
    [self.tableView reloadData];
}

- (void)requestToAddImage {
    WeakSelf;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:HttpAddress(@"Add/addImage") parameters:[self indexValues].mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"errmsg"] toView:selfWeak.view animated:YES];
        } else {
            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TXBYInputGroup *group = self.groups[section];
    return group.items.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXBYInputGroup *group = [self.groups firstObject];
    NSArray *arr = group.items;
    if (indexPath.row == arr.count) {
        AddImageCell *addCell = [AddImageCell addImageCell];
        return addCell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    TXBYInputGroup *group = [self.groups firstObject];
    NSArray *arr = group.items;
    if (arr.count > 1) {
        if (indexPath.row == arr.count) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    TXBYInputGroup *group = [self.groups firstObject];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:group.items];
    [muArr removeObjectAtIndex:indexPath.row];
    group.items = muArr;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TXBYInputGroup *group = [self.groups firstObject];
    NSArray *arr = group.items;
    if (indexPath.row == arr.count) {
        [self addAnItem];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

/**
 *  通过索引取出输入的值
 */
- (NSDictionary *)indexValues {
    TXBYInputGroup *group = [self.groups firstObject];
    NSArray *itemArr = group.items;
    NSMutableArray *muArr = [NSMutableArray array];
    for (TXBYInputItem *item in itemArr) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setValue:item.subtitle forKey:@"image_url"];
        [tempDic setValue:self.itemID forKey:@"item_id"];
        [muArr addObject:tempDic];
    }
    if (self.isNew) {
        return [NSDictionary dictionaryWithObject:muArr.mj_JSONString forKey:@"data"];
    } else {
        return [NSDictionary dictionaryWithObject:muArr.mj_JSONString forKey:@"data"];
    }
}

- (BOOL)canSubmit {
    TXBYInputGroup *group = [self.groups firstObject];
    for (int i = 0; i < group.items.count; i++) {
        TXBYInputItem *item = group.items[i];
        if (!item.subtitle.length) {
            [MBProgressHUD showInfo:@"请补全图片地址" toView:self.view];
            return NO;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)title {
    return @"添加轮播图";
}

@end
