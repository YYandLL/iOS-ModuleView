//
//  HomeMetroView.m
//  TXBYModuleApp
//
//  Created by YandL on 16/10/21.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "HomeMetroView.h"

#define itemGap 1

@implementation HomeMetroView

+ (HomeMetroView *)metroViewWith:(NSArray *)sectionArr click:(metroClickBlock)block {
    HomeMetroView *view = [[self alloc] init];
    view.block = block;
    float height = 0;
    for (HomeSection *section in sectionArr) {
        height += section.sectionHeight;
    }
    view.frame = CGRectMake(0, 0, TXBYApplicationW, height);
    [view setupItemView:sectionArr];
    return view;
}

- (void)setupItemView:(NSArray *)sectionArr {
    float viewY = 0;
    NSInteger clickIndex = 0;
    for (int i = 0; i < sectionArr.count; i ++) {
        float scrollHeight = 0;
        HomeSection *section = sectionArr[i];
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, viewY, TXBYApplicationW, section.sectionHeight);
        if (![section.backgroundColor isEqualToString:@"clear"]) {
            view.backgroundColor = [UIColor colorWithChineseRGBString:section.backgroundColor];
        }
        [self addSubview:view];
        
        for (int j = 0; j < section.items.count; j ++) {
            
            HomeItem *item = section.items[j];
            
            UIButton *itemView = [UIButton buttonWithType:UIButtonTypeSystem];
            if (item.backgroundColor.length) {
                itemView.backgroundColor = [UIColor colorWithChineseRGBString:item.backgroundColor];
            } else {
                itemView.backgroundColor = [UIColor whiteColor];
            }
            if (AppModify) {
                itemView.tag = item.ID.integerValue;
            } else {
                itemView.tag = clickIndex;
            }
            clickIndex ++;
            if (item.itemType != ItemTypeMoreView) {
                [itemView addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            float itemWidth = (TXBYApplicationW - (section.showMargin? section.items.count: 0)) / (float)section.items.count;
            if (item.itemType == ItemTypeSubSection) {
                itemWidth = TXBYApplicationW * item.viewScale;
            }
            float gap = 0;
            if (section.showMargin) {
                gap = j * itemGap;
            }
            if (item.itemType == ItemTypeScrollImg) {
                scrollHeight = TXBYApplicationW * item.viewScale * section.sectionHeight;
                view.txby_height = scrollHeight;
            }
            itemView.frame = CGRectMake( gap + (j * itemWidth), 0, itemWidth, (scrollHeight > 0)? scrollHeight: section.sectionHeight);
            [view addSubview:itemView];
            
            // 第一种和第二种类型
            if (item.itemType == ItemTypeDefault || item.itemType == ItemTypeRightIcon) {
                
                UIImageView *iconView = [[UIImageView alloc] init];
                iconView.contentMode = UIViewContentModeScaleAspectFit;
                if (item.itemType == ItemTypeDefault) {
                    iconView.frame = CGRectMake((itemWidth - item.iconWidth) / 2.0, 10, item.iconWidth, item.iconHeight);
                    if (section.showSubtitle) {
                        iconView.txby_centerY = itemView.txby_height * 0.3;
                    } else {
                        iconView.txby_centerY = itemView.txby_height * 0.37;
                    }
                } else {
                    iconView.frame = CGRectMake(itemWidth - item.iconWidth - item.iconRight, (section.sectionHeight - item.iconHeight) / 2.0, item.iconWidth, item.iconHeight);
                }
                [itemView addSubview:iconView];
                NSArray *urlArr = [item.icon componentsSeparatedByString:@"/"];
                if (urlArr.count > 1) {
                    //                    [iconView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage loadingImageWithSize]];
                    [iconView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage loadingImageWithSize] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        iconView.contentMode = UIViewContentModeScaleToFill;
                        iconView.image = image;
                    }];
                } else {
                    iconView.image = [UIImage imageNamed:item.icon];
                }
                
                UILabel *titleLabel = [[UILabel alloc] init];
                if (item.titleFont.length) {
                    titleLabel.font = [UIFont systemFontOfSize:[item.titleFont floatValue]];
                } else {
                    titleLabel.font = [UIFont systemFontOfSize:17];
                }
                if (item.itemType == ItemTypeDefault) {
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    if (section.showSubtitle) {
                        titleLabel.frame = CGRectMake(0, 3 + CGRectGetMaxY(iconView.frame), itemWidth, 21);
                    } else {
                        titleLabel.frame = CGRectMake(0, 5 + CGRectGetMaxY(iconView.frame), itemWidth, 21);
                    }
                } else {
                    titleLabel.textAlignment = NSTextAlignmentLeft;
                    titleLabel.frame = CGRectMake(15, section.sectionHeight * 0.2, itemWidth, 21);
                }
                titleLabel.textColor = [UIColor colorWithChineseRGBString:item.titleColor];
                titleLabel.text = item.title;
                [itemView addSubview:titleLabel];
                
                if (section.showSubtitle) {
                    UILabel *subtitleLabel = [[UILabel alloc] init];
                    subtitleLabel.textColor = [UIColor colorWithChineseRGBString:item.subtitleColor];
                    subtitleLabel.font = [UIFont systemFontOfSize:14];
                    subtitleLabel.numberOfLines = 0;
                    if (item.itemType == ItemTypeDefault) {
                        subtitleLabel.textAlignment = NSTextAlignmentCenter;
                        subtitleLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 5, itemWidth, 21);
                    } else {
                        subtitleLabel.textAlignment = NSTextAlignmentLeft;
                        if (item.iconRight > 0) {
                            subtitleLabel.frame = CGRectMake(15, section.sectionHeight * 0.2 + 21 + 5, itemWidth - item.iconWidth - item.iconRight - 15, 40);
                        } else {
                            subtitleLabel.frame = CGRectMake(15, section.sectionHeight * 0.2 + 21 + 5, itemWidth, 40);
                        }
                    }
                    subtitleLabel.text = item.subtitle;
                    [itemView addSubview:subtitleLabel];
                }
            }
            else if (item.itemType == ItemTypeMoreView) {
                float subtitleX = 0;
                if (item.title.length) {
                    UILabel *label = [[UILabel alloc] init];
                    CGFloat labelX = 8;
                    label.frame = CGRectMake(labelX, 12, 70, 25);
                    label.text = item.title;
                    if (item.titleFont.length) {
                        label.font = [UIFont systemFontOfSize:[item.titleFont floatValue]];
                    } else {
                        label.font = [UIFont systemFontOfSize:17];
                    }
                    label.textColor = [UIColor colorWithChineseRGBString:item.titleColor];
                    [itemView addSubview:label];
                    subtitleX = labelX + 70 + 3;
                } else {
                    UIImageView *titleImage = [[UIImageView alloc] init];
                    titleImage.frame = CGRectMake(8, (section.sectionHeight - item.iconHeight) / 2, item.iconWidth, item.iconHeight);
                    NSArray *urlArr = [item.icon componentsSeparatedByString:@"/"];
                    if (urlArr.count > 1) {
                        [titleImage sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage loadingImageWithSize]];
                    } else {
                        titleImage.image = [UIImage imageNamed:item.icon];
                    }
                    [itemView addSubview:titleImage];
                    subtitleX = 8 + item.iconWidth + 5;
                }
                
                if (section.showSubtitle) {
                    UILabel *sublabel = [[UILabel alloc] init];
                    sublabel.frame = CGRectMake(subtitleX, 15, 150, 23);
                    sublabel.text = item.subtitle;
                    sublabel.font = [UIFont systemFontOfSize:13];
                    sublabel.textColor = [UIColor colorWithChineseRGBString:item.subtitleColor];
                    [itemView addSubview:sublabel];
                }
                
                UIButton *more = [UIButton buttonWithType:UIButtonTypeSystem];
                CGFloat moreW = 150;
                more.frame = CGRectMake(TXBYApplicationW - moreW - 10, 0, moreW, section.sectionHeight);
                if (AppModify) {
                    more.tag = item.ID.integerValue;
                } else {
                    more.tag = itemView.tag;
                }
                [more addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [itemView addSubview:more];
                if (item.subIcon.length) {
                    UIImageView *moreimg = [[UIImageView alloc] init];
                    moreimg.frame = CGRectMake(moreW - 44, section.sectionHeight / 2 - 19, 38, 38);
                    NSArray *urlArr = [item.subIcon componentsSeparatedByString:@"/"];
                    if (urlArr.count > 1) {
                        [moreimg sd_setImageWithURL:[NSURL URLWithString:item.subIcon] placeholderImage:[UIImage loadingImageWithSize]];
                    } else {
                        moreimg.image = [UIImage imageNamed:item.subIcon];
                    }
                    [more addSubview:moreimg];
                } else {
                    UILabel *moreLb = [[UILabel alloc] init];
                    moreLb.frame = CGRectMake(0, 0, moreW - 12, section.sectionHeight);
                    moreLb.textAlignment = NSTextAlignmentRight;
                    moreLb.text = item.rightText;
                    moreLb.textColor = [UIColor grayColor];
                    moreLb.font = [UIFont systemFontOfSize:12];
                    [more addSubview:moreLb];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_indicator"]];
                    imageView.frame = CGRectMake(moreW - 8, 17, 8, 14);
                    [more addSubview:imageView];
                }
                
            }
            else if (item.itemType == ItemTypeSubSection) {
                if (item.sectionRight) {
                    itemView.txby_x = TXBYApplicationW * (1 - item.viewScale) + 1;
                }
                UILabel *titleLabel = [[UILabel alloc] init];
                if (item.titleFont.length) {
                    titleLabel.font = [UIFont systemFontOfSize:[item.titleFont floatValue]];
                } else {
                    titleLabel.font = [UIFont systemFontOfSize:17];
                }
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.frame = CGRectMake(0, 12 , itemWidth, 21);
                titleLabel.textColor = [UIColor colorWithChineseRGBString:item.titleColor];
                titleLabel.text = item.title;
                [itemView addSubview:titleLabel];
                
                UIImageView *iconView = [[UIImageView alloc] init];
                iconView.frame = CGRectMake((itemWidth - item.iconWidth) / 2.0, section.sectionHeight - item.iconHeight - 10, item.iconWidth, item.iconHeight);
                
                [itemView addSubview:iconView];
                NSArray *urlArr = [item.icon componentsSeparatedByString:@"/"];
                if (urlArr.count > 1) {
                    [iconView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage loadingImageWithSize]];
                } else {
                    iconView.image = [UIImage imageNamed:item.icon];
                }
                
                UILabel *subtitleLabel = [[UILabel alloc] init];
                subtitleLabel.textColor = [UIColor colorWithChineseRGBString:item.subtitleColor];
                subtitleLabel.font = [UIFont systemFontOfSize:14];
                subtitleLabel.numberOfLines = 0;
                subtitleLabel.textAlignment = NSTextAlignmentCenter;
                float subTitleHeight = CGRectGetMinY(iconView.frame) - CGRectGetMaxY(titleLabel.frame) - 16;
                subtitleLabel.frame = CGRectMake(0, 12 + 21 + 8, itemWidth, subTitleHeight);
                
                subtitleLabel.text = item.subtitle;
                [itemView addSubview:subtitleLabel];
                
                if (item.section.count) {
                    float subViewY = 0;
                    for (int m = 0; m < item.section.count; m ++) {
                        HomeSection *subSection = item.section[m];
                        UIView *subView = [UIView new];
                        subView.frame = CGRectMake(item.sectionRight? 0: TXBYApplicationW * item.viewScale, subViewY, TXBYApplicationW * (1 - item.viewScale), subSection.sectionHeight);
                        if (![subSection.backgroundColor isEqualToString:@"clear"]) {
                            subView.backgroundColor = [UIColor colorWithChineseRGBString:subSection.backgroundColor];
                        }
                        [view addSubview:subView];
                        for (int k = 0; k < subSection.items.count; k ++) {
                            HomeItem *subItem = subSection.items[k];
                            
                            UIButton *subItemView =  [UIButton buttonWithType:UIButtonTypeSystem];
                            if (AppModify) {
                                subItemView.tag = subItem.ID.integerValue;
                            } else {
                                subItemView.tag = clickIndex;
                            }
                            clickIndex ++;
                            if (subItem.itemType != ItemTypeMoreView) {
                                [subItemView addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                            }
                            if (subItem.backgroundColor.length) {
                                subItemView.backgroundColor = [UIColor colorWithChineseRGBString:subItem.backgroundColor];
                            } else {
                                subItemView.backgroundColor = [UIColor whiteColor];
                            }
                            float subItemWidth = (TXBYApplicationW * (1 - item.viewScale) - (subSection.showMargin? subSection.items.count: 0)) / (float)subSection.items.count;
                            //                                if (item.itemType == ItemTypeSubSection) {
                            //                                    itemWidth = TXBYApplicationW * item.viewScale;
                            //                                }
                            float subGap = 1;
                            if (!subSection.showMargin) {
                                subGap = 0;
                            }
                            if (subSection.showMargin) {
                                subGap += k * itemGap;
                            }
                            subItemView.frame = CGRectMake(subGap + (k * subItemWidth), 0, subItemWidth, subSection.sectionHeight);
                            [subView addSubview:subItemView];
                            
                            // 第一种和第二种类型
                            if (subItem.itemType == ItemTypeDefault || subItem.itemType == ItemTypeRightIcon) {
                                
                                UIImageView *iconView = [[UIImageView alloc] init];
                                iconView.contentMode = UIViewContentModeScaleAspectFit;
                                if (subItem.itemType == ItemTypeDefault) {
                                    iconView.frame = CGRectMake((subItemWidth - subItem.iconWidth) / 2.0, 10, subItem.iconWidth, subItem.iconHeight);
                                    if (subSection.showSubtitle) {
                                        iconView.txby_centerY = subItemView.txby_height * 0.3;
                                    } else {
                                        iconView.txby_centerY = subItemView.txby_height * 0.35;
                                    }
                                } else {
                                    iconView.frame = CGRectMake(subItemWidth - subItem.iconWidth - subItem.iconRight, (subSection.sectionHeight - subItem.iconHeight) / 2.0, subItem.iconWidth, subItem.iconHeight);
                                }
                                [subItemView addSubview:iconView];
                                NSArray *urlArr = [subItem.icon componentsSeparatedByString:@"/"];
                                if (urlArr.count > 1) {
                                    //                                    [iconView sd_setImageWithURL:[NSURL URLWithString:subItem.icon] placeholderImage:[UIImage loadingImageWithSize]];
                                    
                                    [iconView sd_setImageWithURL:[NSURL URLWithString:subItem.icon] placeholderImage:[UIImage loadingImageWithSize] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        iconView.contentMode = UIViewContentModeScaleToFill;
                                        iconView.image = image;
                                    }];
                                } else {
                                    iconView.image = [UIImage imageNamed:subItem.icon];
                                }
                                
                                UILabel *titleLabel = [[UILabel alloc] init];
                                if (item.titleFont.length) {
                                    titleLabel.font = [UIFont systemFontOfSize:[item.titleFont floatValue]];
                                } else {
                                    titleLabel.font = [UIFont systemFontOfSize:17];
                                }
                                if (subItem.itemType == ItemTypeDefault) {
                                    titleLabel.textAlignment = NSTextAlignmentCenter;
                                    if (subSection.showSubtitle) {
                                        titleLabel.frame = CGRectMake(0, 3 + CGRectGetMaxY(iconView.frame), subItemWidth, 21);
                                    } else {
                                        titleLabel.frame = CGRectMake(0, 5 + CGRectGetMaxY(iconView.frame), subItemWidth, 21);
                                    }
                                } else {
                                    titleLabel.textAlignment = NSTextAlignmentLeft;
                                    titleLabel.frame = CGRectMake(10, subSection.sectionHeight * 0.15, subItemWidth, 21);
                                }
                                titleLabel.textColor = [UIColor colorWithChineseRGBString:subItem.titleColor];
                                titleLabel.text = subItem.title;
                                [subItemView addSubview:titleLabel];
                                
                                if (subSection.showSubtitle) {
                                    UILabel *subtitleLabel = [[UILabel alloc] init];
                                    subtitleLabel.textColor = [UIColor colorWithChineseRGBString:subItem.subtitleColor];
                                    subtitleLabel.font = [UIFont systemFontOfSize:14];
                                    subtitleLabel.numberOfLines = 0;
                                    if (subItem.itemType == ItemTypeDefault) {
                                        subtitleLabel.textAlignment = NSTextAlignmentCenter;
                                        subtitleLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 5, subItemWidth, 21);
                                    } else {
                                        subtitleLabel.textAlignment = NSTextAlignmentLeft;
                                        if (subItem.iconRight > 0) {
                                            subtitleLabel.frame = CGRectMake(10, subSection.sectionHeight * 0.15 + 21 + 5, subItemWidth - subItem.iconWidth - subItem.iconRight - 15, 40);
                                        } else {
                                            subtitleLabel.frame = CGRectMake(10, subSection.sectionHeight * 0.2 + 21 + 5, subItemWidth, 40);
                                        }
                                    }
                                    subtitleLabel.text = subItem.subtitle;
                                    [subItemView addSubview:subtitleLabel];
                                }
                            }
                            else if (subItem.itemType == ItemTypeMoreView) {
                                float subtitleX = 0;
                                if (subItem.title.length) {
                                    UILabel *label = [[UILabel alloc] init];
                                    CGFloat labelX = 8;
                                    label.frame = CGRectMake(labelX, 7, 70, 25);
                                    label.text = subItem.title;
                                    if (subItem.titleFont.length) {
                                        label.font = [UIFont systemFontOfSize:[subItem.titleFont floatValue]];
                                    } else {
                                        label.font = [UIFont systemFontOfSize:17];
                                    }
                                    label.textColor = [UIColor colorWithChineseRGBString:subItem.titleColor];
                                    [subItemView addSubview:label];
                                    subtitleX = labelX + 70 + 3;
                                } else {
                                    UIImageView *titleImage = [[UIImageView alloc] init];
                                    titleImage.frame = CGRectMake(8, (subSection.sectionHeight - subItem.iconHeight) / 2, subItem.iconWidth, subItem.iconHeight);
                                    NSArray *urlArr = [subItem.icon componentsSeparatedByString:@"/"];
                                    if (urlArr.count > 1) {
                                        [titleImage sd_setImageWithURL:[NSURL URLWithString:subItem.icon] placeholderImage:[UIImage loadingImageWithSize]];
                                    } else {
                                        titleImage.image = [UIImage imageNamed:subItem.icon];
                                    }
                                    [subItemView addSubview:titleImage];
                                    subtitleX = 8 + subItem.iconWidth + 5;
                                }
                                
                                if (subSection.showSubtitle) {
                                    UILabel *sublabel = [[UILabel alloc] init];
                                    sublabel.frame = CGRectMake(subtitleX, 10, 150, 23);
                                    sublabel.text = subItem.subtitle;
                                    sublabel.font = [UIFont systemFontOfSize:13];
                                    sublabel.textColor = [UIColor colorWithChineseRGBString:subItem.subtitleColor];
                                    [subItemView addSubview:sublabel];
                                }
                                
                                UIButton *more = [UIButton buttonWithType:UIButtonTypeSystem];
                                CGFloat moreW = 150;
                                more.frame = CGRectMake(TXBYApplicationW * (1 - item.viewScale) - moreW - 10, 0, moreW, subSection.sectionHeight);
                                if (AppModify) {
                                    more.tag = subItem.ID.integerValue;
                                } else {
                                    more.tag = subItemView.tag;
                                }
                                [more addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                                [subItemView addSubview:more];
                                if (subItem.subIcon.length) {
                                    UIImageView *moreimg = [[UIImageView alloc] init];
                                    moreimg.frame = CGRectMake(moreW - 44, subSection.sectionHeight / 2 - 19, 38, 38);
                                    NSArray *urlArr = [subItem.subIcon componentsSeparatedByString:@"/"];
                                    if (urlArr.count > 1) {
                                        [moreimg sd_setImageWithURL:[NSURL URLWithString:subItem.subIcon] placeholderImage:[UIImage loadingImageWithSize]];
                                    } else {
                                        moreimg.image = [UIImage imageNamed:subItem.subIcon];
                                    }
                                    [more addSubview:moreimg];
                                } else {
                                    UILabel *moreLb = [[UILabel alloc] init];
                                    moreLb.frame = CGRectMake(0, 0, moreW - 12, subSection.sectionHeight);
                                    moreLb.textAlignment = NSTextAlignmentRight;
                                    moreLb.text = subItem.rightText;
                                    moreLb.font = [UIFont systemFontOfSize:12];
                                    moreLb.textColor = [UIColor grayColor];
                                    [more addSubview:moreLb];
                                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_indicator"]];
                                    imageView.frame = CGRectMake(moreW - 8, 14, 6.5, 12);
                                    [more addSubview:imageView];
                                }
                                
                            }
                        }
                        
                        subViewY += (subSection.sectionHeight + subSection.margin);
                    }
                }
            }
            else if (item.itemType == ItemTypeScrollImg) {
                NSMutableArray *urlArr = [NSMutableArray array];
                for (NSDictionary *dic in item.images) {
                    [urlArr addObject:dic[@"image_url"]];
                }
                // 创建网络图片数组
                TXBYScrollView *cyberView = [[TXBYScrollView alloc] initWithFrame:CGRectMake(0, 0, TXBYApplicationW * item.viewScale, scrollHeight) type:ScrollImageCyber imageArr:[NSArray arrayWithArray:urlArr] isAutoScroll:YES];
                // 设置代理
                cyberView.delegate = self;
                if (AppModify) {
                    cyberView.tag = item.ID.integerValue;
                } else {
                    cyberView.tag = itemView.tag;
                }
                cyberView.scrollTime = 2.5f;
                cyberView.backPageColor = [UIColor lightGrayColor];
                cyberView.currentPageColor = [UIColor whiteColor];
                [cyberView setScrollProperty];
                [itemView addSubview:cyberView];
            }
        }
        if (scrollHeight > 0) {
            viewY += (scrollHeight + section.margin);
        } else {
            viewY += (section.sectionHeight + section.margin);
        }
    }
    self.metroHeight = viewY;
    self.txby_height = viewY;
}

- (void)clickBtn:(UIButton *)btn {
    NSInteger row = btn.tag;
    [btn setBackgroundImage:[UIImage imageNamed:@"place1"] forState:UIControlStateHighlighted];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:-1];
    self.block(indexPath);
}

#pragma mark - ADViewDelegate
- (void)scrollViewClickAtIndex:(NSIndexPath *)indexPath {
    self.block(indexPath);
}

@end
