//
//  selectPayTypeCell.m
//  Suffer
//
//  Created by  licc on 2018/8/26.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "selectPayTypeCell.h"

@implementation selectPayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
