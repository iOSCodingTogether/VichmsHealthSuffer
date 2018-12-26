//
//  MapCollectionView.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/9.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "MapCollectionView.h"
#import "MapCollectionCell.h"


@interface MapCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end
@implementation MapCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)createViews{
    self.layer.cornerRadius =8;
    self.layer.masksToBounds =YES;
    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.estimatedItemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 20);
    self.flowLayout =flowLayout;

    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = YES;
    [self addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:@"MapCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MapCollectionCell"];
    self.titleArray =@[@"aa",@"bb",@"cc",@"dd",@"ee",@"ff",@"gg",@"hh"];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
//    [collectionView reloadData];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        NSLog(@"heiht =%.2f",collectionView.collectionViewLayout.collectionViewContentSize.height); make.height.mas_equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height);
    }];
}
//





- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
    
}
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
    
}


#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MapCollectionCell";
    MapCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.label.text =self.titleArray[indexPath.row];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                                          withReuseIdentifier:@"header"forIndexPath:indexPath];
//
//    if (indexPath.section ==0) {
//        labelOne.text =@"热门检查";
//        labelOne.font = [UIFontsystemFontOfSize:14.0f];
//        labelOne.textColor =MainRGB;
//        [header addSubview:labelOne];
//    }else{
//        labelTwo.text =@"疾病信息";
//        labelTwo.font = [UIFontsystemFontOfSize:14.0f];
//        labelTwo.textColor =MainRGB;
//        [header addSubview:labelTwo];
//    }
//    reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:leaveDetailsHeadID forIndexPath:indexPath];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];

        UILabel *label = (UILabel *)[view viewWithTag:100];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, 40)];
            label.tag = 100;
            [view addSubview:label];
            label.text =@"title";
        }
        return view;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[view viewWithTag:100];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, 40)];
            label.tag = 100;
            [view addSubview:label];
            label.text =@"title";
        }
        return view;
    }else{
        return nil;
    }
   
    
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(20, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(20, 20);
}



#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((self.frame.size.width-20) /3 - 20,35);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//（上、左、下、右）
}

#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---------------------");
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        NSLog(@"heiht =%.2f",collectionView.collectionViewLayout.collectionViewContentSize.height); make.height.mas_equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height);
    }];
    
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
