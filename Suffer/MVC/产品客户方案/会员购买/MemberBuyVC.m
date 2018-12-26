//
//  MemberBuyVC.m
//  Suffer
//
//  Created by  licc on 2018/8/26.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "MemberBuyVC.h"
#import "MemberBuyCell0.h"
#import "MemberBuyCell1.h"
#import "selectPayTypeCell.h"
#import "CommonCell1.h"
#import "UITextField+Block.h"
//#import "GoodsFindByGoodsTypeRequestModel.h"
#import "BaseRequest.h"
#import "CouponUseUsableRequestModel.h"
#import "PayRecordCreateRequestModel.h"
#import "UserOpenVideoRequestModel.h"
#import "UserActiveVideoRequestModel.h"
#import "CouponuseUserPageRequestModel.h"

@interface MemberBuyVC ()
@property (nonatomic, assign) NSInteger selectPayType;  //
@property (nonatomic, assign) NSInteger times;          //次数
@property (nonatomic, assign) double totalMoney;        //总钱数
//@property (nonatomic, strong) GoodsFindByGoodsTypeResultModel *goodsResultModel;
@property (nonatomic, strong) GoodsPageResultSubModel * goodsTypeSubModel;     //
@property (nonatomic, strong) CouponuseUserPageResultModel * couponuseUserPageResultModel;     //
@property (nonatomic, assign) double shouldPayMoney;        //


@end

@implementation MemberBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    [self request];
}

-(void)request{//请求优惠券数据
    LRWeakSelf;
    {
//        CouponUseUsableRequestModel *requestModel = [CouponUseUsableRequestModel new];
        CouponuseUserPageRequestModel *requestModel = [CouponuseUserPageRequestModel new];
        
        [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof CouponuseUserPageResultModel *dataModel, NSString *jsonObjc) {
            if(dataModel.success){
                DLog(@"dataModel = %@",dataModel);
                self.couponuseUserPageResultModel = dataModel;
                [weakSelf reloadData];
            }
        }];
    }
    
    {
//        GoodsFindByGoodsTypeRequestModel *requestModel = [GoodsFindByGoodsTypeRequestModel new];
//        requestModel.type = @"视频医生";//视频医生=1
//        [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof GoodsFindByGoodsTypeResultModel *dataModel, NSString *jsonObjc) {
//            if(dataModel.success){
//                weakSelf.goodsResultModel = dataModel;
//                [weakSelf.mainTableView reloadData];
//
//            }
//        }];
        
        [CommonManageInstance goodsPageResultModelBack:^(GoodsPageResultModel * _Nonnull goodsPageResultModel) {
            self.goodsTypeSubModel = [goodsPageResultModel findBygoodsTypeName:self.type];
        }];
    }
    DLog(@"");
}

-(void)buyAction{
    [self activeVideo];
    return;
    
    DLog(@"");
}

//购买成功
-(void)payRecordCreate{
    PayRecordCreateRequestModel *requestModel = [PayRecordCreateRequestModel new];
//    requestModel.payRecord = @{
//                               @"payMoney":@(123),@"couponMoney":@10,@"paymentType":@"支付宝",@"activePayMoney":@113};
    
//    requestModel.couponUseList =
//  @[@{@"id":@"03a9811d1a9546fe9c4a8c359bde3b29"},
//  @{@"id":@"0d7f0ca7d7fa415883c6e45d77e007cf"}];

    
    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof PayRecordCreateResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            DLog(@"dataModel = %@",dataModel);
            
        }
    }];
    DLog(@"");
}

-(void)openVideo{
    UserOpenVideoRequestModel *requestModel = [UserOpenVideoRequestModel new];

    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof UserOpenVideoResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){

            
        }
    }];
}
-(void)activeVideo{
    UserActiveVideoRequestModel *requestModel = [UserActiveVideoRequestModel new];
    
    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof UserActiveVideoResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            LR_TOAST(@"%@",dataModel.msg);
            
        }
    }];
}
-(void)createViews{
    self.title = @"会员购买";
    self.mainTableView.estimatedRowHeight = 100;  //  

    registerNibWithCellName(self.mainTableView, @"MemberBuyCell0");
    registerNibWithCellName(self.mainTableView, @"MemberBuyCell1");
    registerNibWithCellName(self.mainTableView, @"selectPayTypeCell");
    registerNibWithCellName(self.mainTableView, @"CommonCell1");
    
    self.mainTableView.sectionHeaderHeight = 10;
    self.mainTableView.backgroundColor = LR_TABLE_BACKGROUNDCOLOR;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    self.mainTableView.tableFooterView = bottomView;
    
    UIButton *button = [[UIButton alloc]init];
    [bottomView addSubview:button];
    LR_BUTTON_STYLE(button);
    [button setTitle:@"立即购买" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
}
-(void)reloadData{
    
    self.shouldPayMoney=self.totalMoney;
    for(CouponuseUserPageResultListModel *listModel in self.couponuseUserPageResultModel.data){
        if(listModel.isSelect == YES){
        if([listModel.coupon.freeMoney containsString:@"%"]){
            CGFloat freeMoney =listModel.coupon.freeMoney.doubleValue/100.0;
            self.shouldPayMoney *=freeMoney;
        }
        }
    }
    for(CouponuseUserPageResultListModel *listModel in self.couponuseUserPageResultModel.data){
        if(listModel.isSelect == YES){

        if(![listModel.coupon.freeMoney containsString:@"%"]){
            CGFloat freeMoney =listModel.coupon.freeMoney.doubleValue;
            self.shouldPayMoney -=freeMoney;
        }
        }
    }
    
    
    [self.mainTableView reloadData];
    
}
#pragma mark - UITableViewDelegate UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section ==0 ){
        return 2;
    }
    else if(section == 1){
        return 2;
    }
    else if(section == 2){
        return 2;
    }
    else if(section == 3){
        return self.couponuseUserPageResultModel.data.count;
    }
    else if(section == 4){
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(indexPath.section ==0 ){
        return    UITableViewAutomaticDimension;

    }
    else if(indexPath.section == 1){
        return UITableViewAutomaticDimension;
    }
    else if(indexPath.section == 2){
        return 44;
    }
    else if(indexPath.section == 3){
        return 44;
    }
    else if(indexPath.section == 4){
        return 44;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LRWeakSelf;
    UITableViewCell *cell;
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            CommonCell1 * curCell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell1"];
            curCell.label0.text = @"您充值的账户余额不足请先充值：";
            cell = curCell;
        }
        else{
            MemberBuyCell0 *curCell = [tableView dequeueReusableCellWithIdentifier:@"MemberBuyCell0"];
            NSString * goodsType = self.goodsTypeSubModel.goodsTypeName;
            NSString * str= [NSString stringWithFormat:@"   %@",goodsType];
            [curCell.selectButton setTitle:str forState:UIControlStateNormal];

            curCell.priceLabel.text =[NSString stringWithFormat:@"%f元/次",self.goodsTypeSubModel.fee];
            curCell.timesTextField.text = [NSString stringWithFormat:@"%ld",(long)self.times];
            [curCell.timesTextField addActiontextFieldChanged:^(UITextField *textField) {
                weakSelf.times = [textField.text integerValue];
            }];
            cell = curCell;
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            CommonCell1 * curCell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell1"];
            NSString *moneyStr = @"450";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"本次消费需要金额为%@，请输入本次充值",moneyStr]];
            NSRange range1 = [[str string] rangeOfString:moneyStr];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range1];
            curCell.label0.attributedText = str;
            cell = curCell;
        }
        else{
            MemberBuyCell1 * curCell = [tableView dequeueReusableCellWithIdentifier:@"MemberBuyCell1"];

            curCell.moneyTextField.text = [NSString stringWithFormat:@"%.f",self.totalMoney];
            [curCell.moneyTextField addActiontextFieldChanged:^(UITextField *textField) {
                weakSelf.totalMoney = [textField.text doubleValue];
            }];
            cell = curCell;
        }
    }
    else if(indexPath.section == 2){
        selectPayTypeCell * curCell = [tableView dequeueReusableCellWithIdentifier:@"selectPayTypeCell"];
        if(indexPath.row == 0){
            curCell.myImageView.image = LRSTRING2IMAGE(@"icon_37");
            curCell.myLabel.text = @"微信支付";
        }
        else if(indexPath.row == 1){
            curCell.myImageView.image = LRSTRING2IMAGE(@"icon_38");
            curCell.myLabel.text = @"";
        }
        else if(indexPath.row == 2){
            curCell.myImageView.image = LRSTRING2IMAGE(@"icon_39");
            NSString *moneyStr = @" 450 ";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"现金券折扣%@元",moneyStr]];
            NSRange range1 = [[str string] rangeOfString:moneyStr];
            [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor orangeColor] } range:range1];
            curCell.myLabel.attributedText = str;
        }
        if(self.selectPayType == indexPath.row){
            curCell.myButton.selected = YES;
        }
        else{
            curCell.myButton.selected = NO;
        }
        cell = curCell;
    }
    else if(indexPath.section == 3){
        selectPayTypeCell * curCell = [tableView dequeueReusableCellWithIdentifier:@"selectPayTypeCell"];
//        curCell.myImageView.image = nil;
        curCell.myImageView.image = LRSTRING2IMAGE(@"icon_39");

        curCell.myButton.selected = self.couponuseUserPageResultModel.data[indexPath.row].isSelect;
        curCell.myLabel.text = self.couponuseUserPageResultModel.data[indexPath.row].coupon.couponName;
        cell = curCell;

        
    }
    else if(indexPath.section == 4){
        CommonCell1 * curCell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell1"];
        
//        NSString *moneyStr = @"1350.00";
        NSString *moneyStr =[NSString stringWithFormat:@"%.2f",self.shouldPayMoney];

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实际支付:%@ 元",moneyStr]];
        NSRange range1 = [[str string] rangeOfString:moneyStr];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range1];
        curCell.label0.attributedText = str;
        cell = curCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = LR_TABLE_BACKGROUNDCOLOR;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        self.selectPayType = indexPath.row;
        [self reloadData];
    }
    if(indexPath.section == 3){
        self.couponuseUserPageResultModel.data[indexPath.row].isSelect= !self.couponuseUserPageResultModel.data[indexPath.row].isSelect;
        [self reloadData];
    }
    DLog(@"");
    
    
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
