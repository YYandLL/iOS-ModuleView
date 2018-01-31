//
//  TXBYColorPickerView.m
//  YandL
//
//  Created by YandL on 16/12/21.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "TXBYColorPickerView.h"

@interface TXBYColorPickerView () <DTColorPickerImageViewDelegate>

/**
 *  <#desc#>
 */
//@property (nonatomic, strong) UIView *backView;
/**
 *  工具条
 */
@property (nonatomic, strong) UIView *toolView;
/**
 *  当前颜色预览
 */
@property (nonatomic, strong) UILabel *currentLabel;
/**
 *  当前颜色预览
 */
@property (nonatomic, assign) BOOL showAlpha;

@end

@implementation TXBYColorPickerView

- (instancetype)initWithShowAlpha:(BOOL)showAlpha {
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    self.showAlpha = showAlpha;
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
    return self;
}

/*
 *  设置颜色选择器
 */
- (void)showPickerWithColor:(UIColor *)color block:(ColorPickerBlock)block {
    self.block = block;
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.0;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideColorPicker)];
    [self addGestureRecognizer:ges];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.colorView = [DTColorPickerImageView colorPickerWithImage:[UIImage imageNamed:@"fontcolor_bar"]];
    self.colorView.frame = CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, TXBYApplicationW, 240);
    [[UIApplication sharedApplication].keyWindow addSubview:self.colorView];
    
    DTColorPickerImageView *pickerView = [DTColorPickerImageView colorPickerWithImage:[UIImage imageNamed:@"fontcolor_bar"]];
    pickerView.frame = CGRectMake(0, 40, TXBYApplicationW, 200);
    pickerView.delegate = self;
    [self.colorView addSubview:pickerView];
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TXBYApplicationW, 40)];
    self.toolView.backgroundColor = TXBYColor(230, 230, 230);
    [self.colorView addSubview:self.toolView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, TXBYApplicationW, 30)];
    titleLabel.text = @"选择颜色";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.colorView addSubview:titleLabel];
    
    self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(TXBYApplicationW - 115, 5, 60, 30)];
    if (color) {
        self.currentLabel.backgroundColor = color;
    } else {
        self.currentLabel.text = @"透明";
    }
    self.currentLabel.textAlignment = NSTextAlignmentCenter;
    self.currentLabel.textColor = [UIColor grayColor];
    self.currentLabel.font = [UIFont systemFontOfSize:14.0];
    self.currentLabel.layer.cornerRadius = 2;
    self.currentLabel.layer.masksToBounds = YES;
    [self.toolView addSubview:self.currentLabel];
    
    UIButton *whiteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [whiteBtn setTitle:@"纯白" forState:UIControlStateNormal];
    [whiteBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    whiteBtn.backgroundColor = [UIColor whiteColor];
    whiteBtn.tag = 1000;
    whiteBtn.layer.cornerRadius = 2;
    [whiteBtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    whiteBtn.frame = CGRectMake(55, 5, 40, 30);
    [self.toolView addSubview:whiteBtn];
    
    UIButton *blackBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [blackBtn setTitle:@"纯黑" forState:UIControlStateNormal];
    [blackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    blackBtn.backgroundColor = [UIColor blackColor];
    blackBtn.tag = 1001;
    blackBtn.layer.cornerRadius = 2;
    [blackBtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    blackBtn.frame = CGRectMake(10, 5, 40, 30);
    [self.toolView addSubview:blackBtn];
    
    if (self.showAlpha) {
        UIButton *alphaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [alphaBtn setTitle:@"透明" forState:UIControlStateNormal];
        [alphaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //    alphaBtn.backgroundColor = [UIColor clearColor];
        alphaBtn.tag = 1002;
        alphaBtn.layer.borderWidth = 1.0;
        alphaBtn.layer.cornerRadius = 2;
        alphaBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [alphaBtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        alphaBtn.frame = CGRectMake(100, 5, 40, 30);
        [self.toolView addSubview:alphaBtn];
    }
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.tag = 1003;
    [sureBtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(TXBYApplicationW - 45, 5, 35, 30);
    [self.toolView addSubview:sureBtn];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.colorView.transform = CGAffineTransformMakeTranslation(0, -240);
        self.alpha = 0.3;
    }];
}

- (void)hideColorPicker {
    [UIView animateWithDuration:0.25 animations:^{
        self.colorView.transform = CGAffineTransformMakeTranslation(0, 240);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.colorView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)colorBtnClick:(UIButton *)btn {
    if (btn.tag == 1000) {
        self.currentLabel.text = @"";
        self.currentLabel.backgroundColor = [UIColor whiteColor];
    } else if (btn.tag == 1001) {
        self.currentLabel.text = @"";
        self.currentLabel.backgroundColor = [UIColor blackColor];
    } else if (btn.tag == 1002) {
        self.currentLabel.text = @"透明";
        self.currentLabel.backgroundColor = [UIColor clearColor];
    } else {
        [self hideColorPicker];
        self.block(self.currentLabel);
    }
}

- (void)imageView:(DTColorPickerImageView *)imageView didPickColorWithColor:(UIColor *)color {
    self.currentLabel.text = @"";
    self.currentLabel.backgroundColor = color;
}

@end
