//
//  ExpertDetailVC.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/13.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "ExpertDetailVC.h"
#import "AppDefine.h"
#import "VideoEvaluationLabelsCell.h"

@interface ExpertDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView * icon;     //
@property (nonatomic, strong) UILabel * nameLabel;     //

@property (nonatomic, strong) UILabel * label0;     //职务
@property (nonatomic, strong) UILabel * label1;     //医院
@property (nonatomic, strong) UICollectionView * labelsCollection;     //
@property (nonatomic, strong) NSMutableArray *labelsStrings;//标签

@end

@implementation ExpertDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self reloadData];
}
-(void)createViews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 600)];

    self.icon = [UIImageView new];
    [view addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.width.mas_equalTo(30);
    }];

    self.nameLabel = [UILabel new];
    [view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.icon.mas_bottom).offset(4);
    }];
    
    self.label0 = [UILabel new];
    [view addSubview:self.label0];
    [self.label0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4);
    }];
    
    self.label1 = [UILabel new];
    [view addSubview:self.label1];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.label0.mas_bottom).offset(4);
    }];
    UIView *line0 =[self createLineForView:view ];
    [line0 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label1.mas_bottom).offset(12);
    }];
    
    UILabel * shanchang = [UILabel new];
    [view addSubview:shanchang];
    shanchang.text =@"擅长";
    [shanchang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line0.mas_bottom).offset(4);
        
    }];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //    flowLayout.estimatedItemSize = CGSizeMake(10, 10);
    //    flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
    
    self.labelsCollection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.labelsCollection.backgroundColor = [UIColor grayColor];
    self.labelsCollection.delegate = self;
    self.labelsCollection.dataSource = self;
    self.labelsCollection.scrollEnabled = YES;
    [self.labelsCollection registerClass:[VideoEvaluationLabelsCell class] forCellWithReuseIdentifier:@"VideoEvaluationLabelsCell"];
    [view addSubview:self.labelsCollection];
    [self.labelsCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(line0.mas_bottom).offset(48);
        make.height.mas_equalTo(30);
    }];
    
    CGFloat height = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = view.bounds;
    frame.size.height = height;
    view.frame = frame;
    self.mainTableView.tableHeaderView = view;
    
}
-(UIView *)createLineForView:(UIView *)view{
    UIView *line = [UIView new];
    [view addSubview:line];
    line.backgroundColor = [UIColor grayColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    return line;
}

-(void)reloadData{
    self.labelsStrings = [NSMutableArray arrayWithArray:@[@"分析思路清晰",@"回复快",@"有问必答",@"好",@"good",@"回复快",@"有问必答",@"好",@"good",@"回复快",@"有问必答",@"好",@"good",@"回复快",@"有问必答",@"好",@"good",@"回复快",@"有问必答",@"好",@"good",@"回复快"]];
    [self.labelsCollection reloadData];

    [self.labelsCollection mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(self.labelsCollection.collectionViewLayout.collectionViewContentSize.height));
        
    }];
    
}
#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.labelsStrings.count;
    
    
    
}


#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        VideoEvaluationLabelsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoEvaluationLabelsCell" forIndexPath:indexPath];
        cell.label.text = self.labelsStrings[indexPath.row];
      
        return cell;
   
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        //        if(indexPath.row == self.labelsStrings.count -1){
        UILabel* label=[UILabel new];
        label.text = self.labelsStrings[indexPath.row];
        [label sizeToFit];
        
        NSLog(@"%.f,%.f",label.frame.size.width,label.frame.size.height);
        return CGSizeMake(label.frame.size.width+8, label.frame.size.height+8);
        //        }
        return CGSizeMake(100, 300);
    
    
}


//
//#pragma mark  定义整个CollectionViewCell与整个View的间距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 10, 10, 10);//（上、左、下、右）
//}

#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
        return 2;
    
    
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    return 4;
  
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---------------------");
        self.labelsStrings = [NSMutableArray arrayWithArray:@[@"分析思路清晰",@"回复快",@"有问必答",@"好",@"good",@"回复快"]];
        int to =arc4random()%30;
        for (NSInteger i =0; i<to;i++){
            [self.labelsStrings addObject:[NSString stringWithFormat:@"%d",arc4random()%100000000]];
        }
        [self.labelsStrings addObject:[NSString stringWithFormat:@"%d",arc4random()%100000000*0+100]];
        
        [self reloadData];
   
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
