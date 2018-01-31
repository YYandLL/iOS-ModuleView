//
//  ServiceViewController.m
//  sdfyy
//
//  Created by 919575700@qq.com on 10/19/15.
//  Copyright (c) 2015 eeesys. All rights reserved.
//

// tableView头部高度
CGFloat const ServiceTableViewH = 80;

#import "ServiceViewController.h"
#import "ServiceType.h"
#import "ServiceParam.h"
#import "ServiceItem.h"
#import "ServiceListViewController.h"

@interface ServiceViewController ()

/**
 *  医疗服务类型
 */
@property (nonatomic, strong) NSArray *services;

@end

@implementation ServiceViewController

#pragma mark - getters
/**
 *  医疗服务类型
 */
- (NSArray *)services {
    if (!_services) {
        _services = [ServiceType mj_objectArrayWithFilename:@"service.bundle/serviceType.plist"];
    }
    return _services;
}

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 监听通知
    [self setupNotifications];
    
    // 设置tableView属性
    [self setupTableView];
    
    // 添加groups数据
    [self setupGroups];
}

/**
 *  销毁
 */
- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 取消网络请求
    [[TXBYHTTPSessionManager sharedManager] cancelAllNetworking];
}

#pragma mark - private
/**
 *  监听通知
 */
- (void)setupNotifications
{
    // 监听键盘位置变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  当键盘改变了frame的时候调用
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.view.backgroundColor;
    
    // 取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 计算控制器的view需要平移的距离
    CGFloat transformY = (keyboardFrame.origin.y == [UIScreen mainScreen].bounds.size.height) ? 0 : -ServiceTableViewH;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

/**
 *  设置tableView属性
 */
- (void)setupTableView
{
    // 清除父类UIEdgeInsets
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 禁止滚动
    self.tableView.scrollEnabled = NO;
    // tableview头部视图设置
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.txby_width, ServiceTableViewH)];
    
    // 尾部
    CGFloat distance = 25;
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, self.view.txby_width, distance + 49);
    UIButton *button = [UIButton buttonWithTitle:@"查询" bg:@"service.bundle/common_card_background.png" target:self action:@selector(query)];
    button.frame = CGRectMake(0, distance, self.view.txby_width, 49);
    [footer addSubview:button];
    self.tableView.tableFooterView = footer;
}

/**
 *  查询按钮点击事件
 */
- (void)query
{
    // 结束编辑
    [self.view endEditing:YES];
    
    // 取出服务名称
    NSArray *items = [self.groups[0] items];
    
    TXBYInputItem *nameItem = items[0];
    // 取出当前选中的服务类型
    TXBYInputItem *typeItem = items[1];
    
    // 请求参数对象
    ServiceParam *param = [ServiceParam param];
    param.act = @"search";
    param.ServiceName = nameItem.subtitle;
    param.mtid = typeItem.code;
    for (ServiceType *type in self.services)
    {
        if ([typeItem.code isEqualToString:type.mtid])
        {
            if ([type.mtids isEqualToString:@""]) break;
            param.mtids = type.mtids;
            break;
        }
    }
    // 如果为空
    if (![param.mtids isEqualToString:@""])
    {
        param.mtids = [NSString stringWithFormat:@"%@'_'%@", param.mtid, param.mtids];
    }
    
    // 发送请求
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[TXBYHTTPSessionManager sharedManager] get:TXBYServiceAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        
        if (![responseObject count]) // 没有结果
        {
            TXBYAlert(@"没有相关数据")
            return;
        }
        
        // 转成ServiceItem数组
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < [responseObject count]; i++)
        {
            NSArray *tempArray = responseObject[i];
            NSString *price = @"价格(元)：";
            if (responseObject[i][3] != [NSNull null])
            {
                price = [price stringByAppendingString:tempArray[3]];
            }
            ServiceItem *item = [[ServiceItem alloc] init];
            item.ID = tempArray[0];
            item.name = tempArray[1];
            item.price = price;
            [arrayM addObject:item];
        }
        
        // 跳转到列表界面
        ServiceListViewController *vc = [[ServiceListViewController alloc] init];
        vc.serviceItems = arrayM;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:self.view];
        // 网络加载失败
        [self requestFailure:error];
    }];
}

/**
 *  添加groups数据
 */
- (void)setupGroups
{
    // 创建组
    TXBYInputGroup *group = [TXBYInputGroup group];
    [self.groups addObject:group];
    
    // 服务名称
    TXBYInputFieldItem *nameItem = [TXBYInputFieldItem itemWithTitle:@"服务名称" subtitle:@""];
    nameItem.placeholder = @"医疗服务名称";
    
    // 服务类型
    ServiceType *firstType = self.services[0];
    TXBYInputPickerItem *typeItem = [TXBYInputPickerItem itemWithTitle:@"服务类型" subtitle:firstType.name];
    typeItem.code = firstType.mtid;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (ServiceType *type in self.services)
    {
        TXBYInputPickerSource *source = [[TXBYInputPickerSource alloc] init];
        source.code = type.mtid;
        source.name = type.name;
        [arrayM addObject:source];
    }
    typeItem.source = arrayM;
    
    // 模型添加到组中
    group.items = @[nameItem, typeItem];
}

@end