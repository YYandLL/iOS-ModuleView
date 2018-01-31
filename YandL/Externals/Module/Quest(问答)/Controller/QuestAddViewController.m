//
//  QuestAddViewController.m
//  smh
//
//  Created by yh on 15/3/31.
//  Copyright (c) 2015年 eeesys. All rights reserved.
//

// 标题文本框高度
CGFloat const ESTitleH = 44;
// 内容文本高度
CGFloat const ESContentH = 150;

#import "QuestAddViewController.h"
#import "QuestTool.h"
#import "QuestParam.h"
#import "QuestResult.h"

@interface QuestAddViewController () <UITextFieldDelegate, UITextViewDelegate>

/**
 *  标题
 */
@property (nonatomic, weak) UITextField *titleTextField;

/**
 *  内容
 */
@property (nonatomic, weak) UITextView *contentTextView;

@end

@implementation QuestAddViewController

#pragma mark - lifecycle
/**
 *  view加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加导航栏按钮
    [self setupNavBarButton];
    
    // 添加标题文本框
    [self setupTitleTextField];
    
    // 添加内容文本视图
    [self setupContentTextView];
    
    // 添加手势
    [self setupTapGesture];
}

/**
 *  view出现
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 成为第一响应者
    [self.titleTextField becomeFirstResponder];
}

/**
 *  销毁
 */
- (void)dealloc {
    // 取消网络请求
    [[TXBYHTTPSessionManager sharedManager] cancelNetworkingWithNetIdentifier:TXBYClassName];
}

#pragma mark - private
/**
 *  添加导航栏按钮
 */
- (void)setupNavBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提问" style:UIBarButtonItemStyleDone target:self action:@selector(sendClick)];
}

/**
 *  发表按钮点击事件
 */
- (void)sendClick {
    // 结束编辑
    [self.view endEditing:YES];
    
    // 取出文字
    NSString *title = self.titleTextField.text.trim;
    NSString *content = self.contentTextView.text.trim;
    
    // 输入校验
    if (title.length < 3) {
        [MBProgressHUD showInfo:@"标题太短了" toView:self.view];
        return;
    } else if (content.length < 3) {
        [MBProgressHUD showInfo:@"内容太短了" toView:self.view];
        return;
    }
    
    // 关闭确定按钮交互
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // 检查账号过期
    [self checkAccount];
}

/**
 *  检查账号过期
 */
- (void)checkAccount {
    // 加载提示
    [MBProgressHUD showMessage:@"提问中" toView:self.view];
    
    // 检查账号
    [self accountUnExpired:^{
        // 提问
        [self add];
    }];
}

/**
 *  提问
 */
- (void)add {
    // 请求参数
    QuestParam *param = [QuestParam param];
    param.title = self.titleTextField.text.trim;
    param.content = self.contentTextView.text.trim;
    WeakSelf;
    // 发送请求
    [QuestTool questAddWithParam:param netIdentifier:TXBYClassName success:^(QuestResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        // 开启确定按钮交互
        selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
        
        if ([result.errcode isEqualToString:TXBYSuccessCode]) { // 提问成功
            // 执行代理方法
            if ([selfWeak.delegate respondsToSelector:@selector(questAddViewControllerDidFinish:)])
            {
                [selfWeak.delegate questAddViewControllerDidFinish:selfWeak];
            }
            
            [selfWeak.navigationController popViewControllerAnimated:YES];
        } else { // 提问失败
            [MBProgressHUD showInfo:result.errmsg toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        [selfWeak requestFailure:error];
        // 开启确定按钮交互
        selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

/**
 *  添加标题文本框
 */
- (void)setupTitleTextField {
    UITextField *titleTextField = [[UITextField alloc] init];
    self.titleTextField = titleTextField;
    [self.view addSubview:titleTextField];
    titleTextField.delegate = self;
    titleTextField.frame = CGRectMake(0, TXBYCellMargin, TXBYApplicationW, ESTitleH);
    titleTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Quest.bundle/textfield_bkg"]];
    // 垂直居中
    titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    titleTextField.placeholder = @"问题标题";
    titleTextField.font = [UIFont systemFontOfSize:16];
    // 清除样式
    titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    titleTextField.returnKeyType = UIReturnKeyDone;
    
    // 左边视图
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 8, 0);
    titleTextField.leftViewMode = UITextFieldViewModeAlways;
    titleTextField.leftView = leftView;
}

/**
 *  添加内容文本视图
 */
- (void)setupContentTextView {
    UITextView *contentTextView = [[UITextView alloc] init];
    self.contentTextView = contentTextView;
    contentTextView.delegate = self;
    [self.view addSubview:contentTextView];
    contentTextView.delegate = self;
    contentTextView.frame = CGRectMake(0, TXBYCellMargin + ESTitleH + 1, TXBYApplicationW, ESContentH);
    contentTextView.font = [UIFont systemFontOfSize:16];
    contentTextView.returnKeyType = UIReturnKeyDone;
}

/**
 *  添加手势
 */
- (void)setupTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - UITextFieldDelegate
/**
 *  按下return键
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.titleTextField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
/**
 *  按下return键
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) { //判断输入的字是否是回车，即按下return
        [self.view endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark - super
/**
 *  标题文字
 */
- (NSString *)title {
    return @"提问";
}

@end