//
//  VideoEvaluationVC.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/11.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "VideoEvaluationVC.h"
#import "VideoEvaluationLabelsCell.h"
#import "VideoEvaluationImageCell.h"
#import "AppDefine.h"

@interface VideoEvaluationVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *doctorLabel;
@property (nonatomic, strong) UILabel * endTimeLabel;     //
@property (nonatomic, strong) UIView * starView;     //
@property (nonatomic, strong) UICollectionView * labelsCollection;     //
@property (nonatomic, strong) UICollectionView * imagessCollection;     //
@property (nonatomic, strong) UITextView * evaluationTextView;     //
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton * sendButton;     //


@property (nonatomic, strong) NSMutableArray *labelsStrings;//评价标签
@property (nonatomic, strong) NSMutableArray *imagesArray;     //

@end

@implementation VideoEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self reloadData];
}

-(void)createViews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//    [self.contentView addSubview:view];
//    self.mainTableView.tableHeaderView = view;

//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//    }];
    UILabel *tLabel = [self createLabelInView:view];
    tLabel.text =@"视频通话";
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(8);
    }];
    UIView *line0 = [self createLineForView:view];
    [line0 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tLabel.mas_bottom).offset(8);
    }];
    
    UIView *detailView = [UIView new];
    [view addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(line0.mas_bottom);
        make.height.mas_equalTo(200);
    }];
    self.startTimeLabel =[self createLabelInView:detailView];
    self.nameLabel =[self createLabelInView:detailView];
    self.doctorLabel =[self createLabelInView:detailView];
    self.endTimeLabel =[self createLabelInView:detailView];
    NSArray *labels = @[self.startTimeLabel,self.nameLabel,self.doctorLabel,self.endTimeLabel];
    //竖直方向固定间隔 等高度
    [labels mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:4 leadSpacing:8 tailSpacing:8];
    [labels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
    }];

    self.ageLabel = [self createLabelInView:detailView];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(detailView.mas_centerX);
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    
    UIView *grayview =[UIView new];
    [view addSubview:grayview];
    grayview.backgroundColor = [UIColor grayColor];
    [grayview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(detailView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    UIView *starContentView =[UIView new];
    [view addSubview:starContentView];
    [starContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(grayview.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    UIView *line1 = [self createLineForView:view];
    [line1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(starContentView.mas_bottom);
    }];
    UILabel *label =[self createLabelInView:view];
    label.text =@"标签";
    label.font = [UIFont boldSystemFontOfSize:14];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(starContentView.mas_bottom).offset(8);
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
        make.top.mas_equalTo(label.mas_bottom).offset(8);
        make.height.mas_equalTo(30);
    }];
    UIView *line2 =[self createLineForView:view];
    [line2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelsCollection.mas_bottom).offset(8);
    }];
    UILabel *imagelabel =[self createLabelInView:view];
    imagelabel.text =@"图片：";
    [imagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
    }];
    
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.estimatedItemSize = CGSizeMake(10, 10);
    self.imagessCollection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout2];
    self.imagessCollection.backgroundColor = [UIColor lightGrayColor];
    self.imagessCollection.delegate = self;
    self.imagessCollection.dataSource = self;
    self.imagessCollection.scrollEnabled = YES;
    [self.imagessCollection registerClass:[VideoEvaluationImageCell class] forCellWithReuseIdentifier:@"VideoEvaluationImageCell"];
    [view addSubview:self.imagessCollection];
    [self.imagessCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(58);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(line2.mas_bottom).offset(8);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(imagelabel.mas_bottom).offset(10);
    }];
    UIView *line3 =[self createLineForView:view];
    [line3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imagessCollection.mas_bottom).offset(8);
    }];
    UILabel *evaluationLabel =[self createLabelInView:view];
    evaluationLabel.text =@"评价";
    [evaluationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line3);
        make.height.mas_equalTo(35);
    }];
    
    self.evaluationTextView =[UITextView new];

    [view addSubview:self.evaluationTextView];
    [self.evaluationTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(evaluationLabel.mas_bottom);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(80);
    }];
    UIView *line4 =[self createLineForView:view];
    [line4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.evaluationTextView.mas_bottom).offset(8);
    }];
    self.timeLabel = [self createLabelInView:view];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(line4);
        make.height.mas_equalTo(35);
    }];
    self.sendButton =[UIButton new];
    [view addSubview:self.sendButton];
    LR_BUTTON_STYLE(self.sendButton);
    [self.sendButton setTitle:@"发表" forState:UIControlStateNormal];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(55);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-80);
    }];
    
    CGFloat height = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = view.bounds;
    frame.size.height = height;
    view.frame = frame;
    self.mainTableView.tableHeaderView = view;
    
}

-(void)reloadData{
    self.startTimeLabel.text = @"通话开始时间：2018-7-10 12:10:15";
    self.nameLabel.text = @"姓名：陈陈";
    self.doctorLabel.text = @"接诊医生：张小小";
    self.endTimeLabel.text = @"通话结束时间：2018-7-10 12:30:20";
    self.ageLabel.text = @"年龄：30";
    self.timeLabel.text =@"时间：2018-7-26 06:10:25";
    if(self.labelsStrings ==nil){
        self.labelsStrings = [NSMutableArray arrayWithArray:@[@"分析思路清晰",@"回复快",@"有问必答",@"好",@"good",@"回复快",@"有问必答",@"好",@"good",@"回复快",@"有问必答",@"好",@"good",@"回复快",@"有问必答",@"好",@"good",@"回复快",@"有问必答",@"好",@"good",@"回复快"]];
    }
    [self.labelsCollection reloadData];
    [self.labelsCollection mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(self.labelsCollection.collectionViewLayout.collectionViewContentSize.height));

    }];
    if(self.imagesArray == nil){
        self.imagesArray =[NSMutableArray arrayWithArray: @[@"000",@"000"]];
    }
    [self.imagessCollection reloadData];
    [self.imagessCollection mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(self.imagessCollection.collectionViewLayout.collectionViewContentSize.height));
    }];
    UIView * view = self.mainTableView.tableHeaderView;
    CGFloat height = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = view.bounds;
    frame.size.height = height;
    view.frame = frame;
    self.mainTableView.tableHeaderView = view;

}
-(UILabel *)createLabelInView:(UIView *)view{
    UILabel *label =[UILabel new];
    [view addSubview:label];
    return label;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
    
}
#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.labelsCollection){
        return self.labelsStrings.count;
    }
    else if(collectionView == self.imagessCollection){
        return self.imagesArray.count + 1;
    }
    return 0;
    
}


#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.labelsCollection){
        VideoEvaluationLabelsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoEvaluationLabelsCell" forIndexPath:indexPath];
        cell.label.text = self.labelsStrings[indexPath.row];
//        [self.labelsCollection mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(@(self.labelsCollection.collectionViewLayout.collectionViewContentSize.height));//.priority(MASLayoutPriorityDefaultHigh);
//
//        }];
        return cell;
    }
    else if(collectionView == self.imagessCollection){
        VideoEvaluationImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoEvaluationImageCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor grayColor];

        if(indexPath.row == self.imagesArray.count){
            cell.imageView.image = nil;

        }else{
            cell.imageView.image = [UIImage imageNamed: self.imagesArray[indexPath.row]];
        }
        return cell;
    }
    
    return nil;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.labelsCollection){
//        if(indexPath.row == self.labelsStrings.count -1){
            UILabel* label=[UILabel new];
            label.text = self.labelsStrings[indexPath.row];
            [label sizeToFit];

            NSLog(@"%.f,%.f",label.frame.size.width,label.frame.size.height);
            return CGSizeMake(label.frame.size.width+8, label.frame.size.height+8);
//        }
        return CGSizeMake(100, 300);
    }
    else if(collectionView == self.imagessCollection){

        return  CGSizeMake(50,50);

    }
    return  CGSizeMake(20,50);
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
    if(collectionView == self.labelsCollection){
        return 2;
    }
    else if(collectionView == self.imagessCollection){
        return 10;
    }
    return 0;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if(collectionView == self.labelsCollection){
        return 4;
    }
    else if(collectionView == self.imagessCollection){
        return 10;
    }
    return 0;}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---------------------");
    if(collectionView == self.labelsCollection){
        self.labelsStrings = [NSMutableArray arrayWithArray:@[@"分析思路清晰",@"回复快",@"有问必答",@"好",@"good",@"回复快"]];
        int to =arc4random()%30;
        for (NSInteger i =0; i<to;i++){
            [self.labelsStrings addObject:[NSString stringWithFormat:@"%d",arc4random()%100000000]];
        }
        [self.labelsStrings addObject:[NSString stringWithFormat:@"%d",arc4random()%100000000*0+100]];

        [self reloadData];
    }
    else if(collectionView == self.imagessCollection){
        [self.imagesArray addObject:@"000"];
        [self reloadData];
    }
    
}

//#pragma mark  设置CollectionViewCell是否可以被点击
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
