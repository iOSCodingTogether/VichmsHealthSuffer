//
//  VideoEvaluationLabelsCell.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/11.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "VideoEvaluationLabelsCell.h"


@implementation VideoEvaluationLabelsCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.label=[UILabel new];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(4);
        make.right.bottom.mas_equalTo(-4);
    }];
    self.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    return self;
}
//- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes {
//
//    [self setNeedsLayout];
//
//    [self layoutIfNeeded];
//
//    CGSize size = [self systemLayoutSizeFittingSize: layoutAttributes.size];
//
//    CGRect cellFrame = layoutAttributes.frame;
//
//    cellFrame.size.height= size.height;
//    cellFrame.size.width= size.width;
//
//    layoutAttributes.frame= cellFrame;
//
//    return layoutAttributes;
//
//}
@end
