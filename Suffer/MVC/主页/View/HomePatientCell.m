//
//  HomePatientCell.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/5.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "HomePatientCell.h"

@implementation HomePatientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
