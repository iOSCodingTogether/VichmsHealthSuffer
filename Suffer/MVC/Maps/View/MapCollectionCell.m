//
//  MapCollectionCell.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/9.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "MapCollectionCell.h"

@implementation MapCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.label.layer.cornerRadius = 4;
    self.label.layer.borderWidth = 1;
    self.label.layer.borderColor = [UIColor grayColor].CGColor;
}
//- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes {
//    
//    [self setNeedsLayout];
//    
//    [self layoutIfNeeded];
//    
//    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
//    
//    CGRect cellFrame = layoutAttributes.frame;
//    
//    cellFrame.size.height= size.height*10;
//    
//    layoutAttributes.frame= cellFrame;
//    
//    return layoutAttributes;
//    
//}
@end
