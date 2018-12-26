//
//  ExpertListTableViewCell.m
//  Suffer
//
//  Created by  licc on 2018/8/24.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "ExpertListTableViewCell.h"

@implementation ExpertListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftImageView.layer.cornerRadius = self.leftImageView.bounds.size.width/2.0;
    self.leftImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
