//
//  MyApplyListVC.m
//  Suffer
//
//  Created by  licc on 2018/8/24.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "MyApplyListVC.h"
#import "MyApplyListTableViewCell.h"
#import "OrderPageMyRequestModel.h"

@interface MyApplyListVC ()
@property (nonatomic, strong) NSMutableArray <OrderPageMyResultSubModel *> *orderpageSubModelArr;     //

@end

@implementation MyApplyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    registerNibWithCellName(self.mainTableView, @"MyApplyListTableViewCell");
    self.title = @"我的预约";
    [self request:NO];

    

    LRWeakSelf;
    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request:NO];
        
    }];
}
-(NSMutableArray <OrderPageMyResultSubModel *> *)orderpageSubModelArr{
    if(!_orderpageSubModelArr){
        _orderpageSubModelArr = [NSMutableArray array];
    }
    return _orderpageSubModelArr;
    
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
    model.search_EQ_orderStatus= @"4";
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
    [self.mainTableView reloadData];
}
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
    cell.btn1.hidden =YES;
    cell.btn2.hidden =YES;
    cell.btn3.hidden =NO;
    cell.btn4.hidden =NO;
    [cell.btn3 setTitle:@"已预约" forState:UIControlStateNormal];
    [cell.btn4 setTitle:@"评价" forState:UIControlStateNormal];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"click");
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
