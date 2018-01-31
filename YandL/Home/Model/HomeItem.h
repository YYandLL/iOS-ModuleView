//
//  HomeItem.h
//  TXBYModuleApp
//
//  Created by YandL on 16/10/21.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeSection : NSObject
/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  是否有子标题
 */
@property (nonatomic, assign) BOOL showSubtitle;
/**
 *  是否显示分隔线
 */
@property (nonatomic, assign) BOOL showMargin;
/**
 *  section的高度
 */
@property (nonatomic, assign) float sectionHeight;
/**
 *  距下一个section的margin
 */
@property (nonatomic, assign) float margin;
/**
 *  backgroundColor
 */
@property (nonatomic, copy) NSString *backgroundColor;
/**
 *  section数组
 */
@property (nonatomic, strong) NSArray *items;
/**
 *  section_item_id
 */
@property (nonatomic, copy) NSString *section_item_id;

@end

typedef enum {
    // 默认类型
    ItemTypeDefault = 1,
    // 图片居右，文字居左
    ItemTypeRightIcon = 2,
    // 更多式横栏
    ItemTypeMoreView = 3,
    // 含有子section的样式
    ItemTypeSubSection = 4,
    // 轮播图样式
    ItemTypeScrollImg = 5
    
} TXBYHomeItemType;

@interface HomeItem : NSObject
/**
 *  ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  titleColor
 */
@property (nonatomic, copy) NSString *titleColor;
/**
 *  titleFont
 */
@property (nonatomic, copy) NSString *titleFont;
/**
 *  subtitle
 */
@property (nonatomic, copy) NSString *subtitle;
/**
 *  subtitleColor
 */
@property (nonatomic, copy) NSString *subtitleColor;
/**
 *  image
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  backgroundColor
 */
@property (nonatomic, copy) NSString *backgroundColor;
/**
 *  子image
 */
@property (nonatomic, copy) NSString *subIcon;
/**
 *  type3时 右边的文字
 */
@property (nonatomic, copy) NSString *rightText;
/**
 *  iconWidth
 */
@property (nonatomic, assign) float iconWidth;
/**
 *  iconHeight
 */
@property (nonatomic, assign) float iconHeight;
/**
 *  icon距离右边的距离
 *  icon居右才用得到
 */
@property (nonatomic, assign) float iconRight;
/**
 *  有子section时 所占宽度百分比
 */
@property (nonatomic, assign) float viewScale;
/**
 *  TXBYHomeItemType
 */
@property (nonatomic, assign) TXBYHomeItemType itemType;
/**
 *  子section
 */
@property (nonatomic, strong) NSArray *section;
/**
 *  子section的位置
 *  0表示居左 1表示居右
 */
@property (nonatomic, assign) BOOL sectionRight;
/**
 *  item_id
 */
@property (nonatomic, copy) NSString *item_id;
/**
 *  section_item_id
 */
@property (nonatomic, copy) NSString *section_item_id;
/**
 *  scroll类型的images
 */
@property (nonatomic, strong) NSArray *images;

@end
