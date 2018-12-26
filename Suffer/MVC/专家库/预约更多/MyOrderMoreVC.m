//
//  MyOrderMoreVC.m
//  Suffer
//
//  Created by  licc on 2018/9/2.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "MyOrderMoreVC.h"
#import "MyApplyListTableViewCell.h"
#import "BRStringPickerView.h"
#import "OrderPageMyRequestModel.h"
#import "CommonManage.h"
#import "UIButton+Block.h"

@interface MyOrderMoreVC ()< UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *mSearchBar;
@property (nonatomic, strong) NSMutableArray *dataArr;//获取到的数据
@property (nonatomic, strong) NSMutableArray *showArr;
@property (nonatomic, strong) UIButton * grayViewButton;     //
@property (nonatomic, strong) UIButton * selectTypeButton;     //
@property (nonatomic, strong) UILabel * selectTypeLabel;     //
@property (nonatomic, assign) NSInteger spreadSection;     //展开哪一列
@property (nonatomic, strong) NSString * searchGoodsTypeType;     //

@property (nonatomic, strong) NSMutableArray <OrderPageMyResultSubModel *> *orderpageSubModelArr;     //

@end

@implementation MyOrderMoreVC
//[BRStringPickerView showStringPickerWithTitle:@"与患者关系：" dataSource:selectArr defaultSelValue:selectArr[self.orderCreateModel.relative.intValue -1] isAutoSelect:NO resultBlock:^(id selectValue) {
//    NSInteger selectIndex = [selectArr indexOfObject:selectValue];
//    weakSelf.orderCreateModel.relative = [NSString stringWithFormat:@"%ld",selectIndex+1];
//    [weakSelf reloadData];
//}];

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    _orderpageSubModelArr = [NSMutableArray array];
    [self request:NO];

    [self reloadData];
}
- (void)createViews{
    self.spreadSection = -1;
    self.title = @"我的订单";
    registerNibWithCellName(self.mainTableView, @"MyApplyListTableViewCell");

    
    
    _mSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    self.mSearchBar.barTintColor = [UIColor whiteColor]; //设置搜索框背景颜色为灰色
    //
    UITextField *searchField = [self.mSearchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor lightGrayColor]];
        searchField.layer.cornerRadius = 4;
        searchField.borderStyle = UITextBorderStyleNone;
        searchField.layer.masksToBounds = YES;
        searchField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];

    }
    _mSearchBar.placeholder = @"请输入医院、科室、专家姓名";
    
    _mSearchBar.delegate = self;
    [self.contentView addSubview:_mSearchBar];
    
    [self.mSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(0);
        //        make.height.mas_equalTo(50);
    }];
    
    self.selectTypeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    [self.contentView addSubview:self.selectTypeButton];
    [self.selectTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mSearchBar);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.mSearchBar.mas_left).offset(-10);
    }];
    [self.selectTypeButton setBackgroundColor:[UIColor lightGrayColor]];
    self.selectTypeButton.layer.cornerRadius = 4;
    self.selectTypeButton.layer.masksToBounds = YES;
    
    self.selectTypeLabel = [[UILabel alloc]init];
    [self.selectTypeButton addSubview:self.selectTypeLabel];
    self.selectTypeLabel.text = @"服务类型";
    [self.selectTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    [self.selectTypeButton addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.selectTypeButton addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.selectTypeLabel.mas_right).offset(10);
    }];
    imageView.image = [UIImage imageNamed:@"icon_26"];
    
    
    
    [searchField setBackgroundColor:[UIColor lightGrayColor]];
    self.selectTypeButton.layer.cornerRadius = 4;
    self.selectTypeButton.layer.masksToBounds = YES;
    
    
    [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mSearchBar.mas_bottom);
    }];
    
    self.grayViewButton = [[UIButton alloc]init];
    [self.contentView addSubview:self.grayViewButton];
    _grayViewButton.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [_grayViewButton addTarget:self.view action:@selector(endEditing:) forControlEvents:UIControlEventTouchUpInside];
    
    _grayViewButton.hidden = YES;
    [self.grayViewButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.top.mas_equalTo(self.mainTableView);
    }];

    
    
    LRWeakSelf;
    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request:YES];
        
    }];
}

-(void)selectTypeAction:(UIButton *)button{
    [[CommonManage shareInstance] goodsPageResultModelBack:^(GoodsPageResultModel * _Nonnull goodsPageResultModel) {
        NSMutableArray *arr = [NSMutableArray array];
        
        for (GoodsPageResultSubModel *model in goodsPageResultModel.list) {
            [arr addObject:[NSString stringWithFormat:@"%@",model.goodsTypeName]];
            
        }
        LRWeakSelf;
        [BRStringPickerView showStringPickerWithTitle:@"与患者关系：" dataSource:arr defaultSelValue:nil isAutoSelect:NO resultBlock:^(id selectValue) {
            GoodsPageResultSubModel *model = [goodsPageResultModel findBygoodsTypeName:selectValue];
            weakSelf.searchGoodsTypeType = model.goodsTypeCode;
//            [button setTitle:selectValue forState:UIControlStateNormal];
            self.selectTypeLabel.text = selectValue;
            [weakSelf request:NO];
        }];
    }];
    

}

-(void)request:(BOOL)isLoadMore{
    OrderPageMyRequestModel *model = [OrderPageMyRequestModel new];
    model.pageSize = 10;
    
    if(!isLoadMore){
        model.pageSize = 20;
        
        model.pageNo = 1;
    }
    else{
        model.pageSize = 10;
        
        model.pageNo = [model nextPageNoForCurDataCount:self.orderpageSubModelArr.count];
    }
    model.search_EQ_buyGoodsType= self.searchGoodsTypeType;
    [BaseRequest requestWithRequestModel:model ret:^(BOOL success, __kindof OrderPageMyResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            if(!isLoadMore){
                self.orderpageSubModelArr =[NSMutableArray arrayWithArray:  dataModel.list];
            }
            else{
                
                [self.orderpageSubModelArr addObjectsFromArray:dataModel.list];
            }
            [self reloadData];
        }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    }];
    
    
}
-(void)reloadData{
//    self.dataArr = [NSMutableArray arrayWithObjects:@"内科",@"外科",@"儿科",@"妇科",@"眼科",@"耳鼻喉科",@"口腔科",@"皮肤科",@"中医科",@"理疗科", nil];
//    NSString *searchKey = self.mSearchBar.text;
//    if(searchKey.length ==0){
//        self.showArr = self.dataArr;
//    }
//    else{
//        self.showArr = [NSMutableArray array];
//        for(NSString *str in self.dataArr){
//            if([str containsString:searchKey]){
//                [self.showArr addObject:str];
//            }
//        }
//    }
    [self.mainTableView reloadData];
}
//
//-(void)spreadButtonClicked:(UIButton *)sender{
//    if(self.spreadSection == sender.tag){
//        self.spreadSection = -1;
//    }
//    else{
//        self.spreadSection = sender.tag;
//    }
//    [self reloadData];
//}
//#pragma mark - UITableViewDelegate, UITableViewDataSource
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 150;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 60;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 30;
//}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 200)];
//
//    UIView *contentView = [[UIView alloc]init];
//    [view addSubview:contentView];
//    contentView.backgroundColor = [UIColor whiteColor];
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(0);
//        make.top.mas_equalTo(10);
//    }];
//    UILabel *label = [UILabel new];
//    [contentView addSubview:label];
//    label.text = @[@"预约专家",@"高端体检",@"温馨陪诊"][section];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(12);
//        make.centerY.mas_equalTo(0);
//    }];
//    return view;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 200)];
//    view.backgroundColor = [UIColor whiteColor];
//    UIButton *footButton = [[UIButton alloc]init];
//    footButton.tag = section;
//    [view addSubview:footButton];
//    [footButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(0);
//    }];
//    if(self.spreadSection == section){
//        [footButton setImage:[UIImage imageNamed:@"icon_58"] forState:UIControlStateNormal];
//    }
//    else{
//        [footButton setImage:[UIImage imageNamed:@"icon_57"] forState:UIControlStateNormal];
//    }
//    [footButton addTarget:self action:@selector(spreadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    return view;
//}
//
//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    MyApplyListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyApplyListTableViewCell"];
//
//    return cell;
//}
//
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(self.spreadSection == section){
//        return 3;
//    }
//
//    return 1;
//
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//
//    return 3;
//}

#pragma mark - UITableViewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderpageSubModelArr.count;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 60;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyApplyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyApplyListTableViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderPageMyResultSubModel *model = self.orderpageSubModelArr[indexPath.row];
    cell.labelTop.text = model.doctor;
    cell.labelL1.text = @{@"1":@"第一次就诊",@"2":@"复诊"}[model.orderType];
    cell.labelL2.text = model.personName;
    cell.labelL3.text = model.hospital;
    cell.labelL4.text = [NSString stringWithFormat:@"%@", model.orderMoney];
    cell.labelR1.text =  LRTimeIntervalFromToFormatter(model.visitTime, @"yyyy-MM-dd'T'HH:mm:ss.SSSZ", @"yyyy-MM-dd");
    cell.labelR2.text = model.personAge;
    cell.labelR3.text = model.department;
    cell.btn2.hidden =YES;
    cell.btn3.hidden =NO;
    cell.btn4.hidden =NO;
    [cell.btn3 setTitle:@"申请中" forState:UIControlStateNormal];
    [cell.btn4 setTitle:@"立即支付" forState:UIControlStateNormal];
    [cell.btn3 addAction:^(UIButton *btn) {
        [self pushViewController: [MemberBuyVC new]];
    }];
    [cell.btn4 addAction:^(UIButton *btn) {
        [self pushViewController:[ MemberBuyVC new]];
    }];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"click");
}


//#pragma mark - 引入索引的一个代理方法
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    return self.keys;
//}
//#pragma mark - section上的标题（A B C D……Z）
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    return self.keys[section];
//}

#pragma mark - UISearchBar - delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0){
        self.grayViewButton.hidden = YES;
    }
    else{
        self.grayViewButton.hidden = NO;
    }
    [self reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if(searchBar.text.length > 0){
        self.grayViewButton.hidden = YES;
    }
    else{
        self.grayViewButton.hidden = NO;
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.grayViewButton.hidden = YES;
    
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
