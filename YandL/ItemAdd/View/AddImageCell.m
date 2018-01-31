//
//  AddUserCell.m
//  sdfey_patient
//
//  Created by txby on 16/5/31.
//  Copyright © 2016年 txby. All rights reserved.
//

#import "AddImageCell.h"

@implementation AddImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)addImageCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"AddImageCell" owner:nil options:nil] lastObject];
}

@end
