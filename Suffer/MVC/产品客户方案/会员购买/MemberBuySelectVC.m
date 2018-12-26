//
//  MemberBuySelectVC.m
//  Suffer
//
//  Created by  licc on 2018/9/1.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "MemberBuySelectVC.h"
#import "MemberBuyCell0.h"
#import "MemberBuyCell1.h"
#import "selectPayTypeCell.h"
#import "CommonCell1.h"
#import "UITextField+Block.h"

@interface MemberBuySelectVC ()
@property (nonatomic, assign) NSInteger selectPayType;  //
@property (nonatomic, strong) NSMutableArray * selectOrders;     //


@end

@implementation MemberBuySelectVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
}

-(NSMutableArray *)selectOrders{
    if(!_selectOrders){
        _selectOrders = [NSMutableArray array];
    }
    return _selectOrders;
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

-(void)buyAction{
    DLog(@"");
}
#pragma mark - UITableViewDelegate UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section ==0 ){
        return 1;
    }
    else if(section ==1){
        return 8;
    }
    else if(section == 2){
        return 1;
    }
    else if(section == 3){
        return 3;
    }
    else if(section == 4){
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 0;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.section ==0 ){
        return UITableViewAutomaticDimension;
    }
    else if(indexPath.section == 1){
        return UITableViewAutomaticDimension;
    }
    else if(indexPath.section == 2){
        return UITableViewAutomaticDimension;
    }
    else if(indexPath.section == 3){
        return 44;
    }
    else if(indexPath.section == 4){
        return 44;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LRWeakSelf;
    UITableViewCell *cell;
    if(indexPath.section == 0){
        CommonCell1 * curCell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell1"];
        curCell.label0.text = @"您充值的金额可用于自动抵扣以下服务的消费，请选择需要的服务:";
        cell = curCell;
    }
    else if(indexPath.section == 1){

        MemberBuyCell0 *curCell = [tableView dequeueReusableCellWithIdentifier:@"MemberBuyCell0"];

        curCell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0); //

        curCell.priceLabel.text = @"500元/次";

        [curCell.timesTextField addActiontextFieldChanged:^(UITextField *textField) {
        }];
        if([self.selectOrders containsObject:@(indexPath.row)]){
            curCell.selectButton.selected = YES;
        }
        else{
            curCell.selectButton.selected = NO;
        }
        NSArray *strArr = @[@"紧急就医",@"住院服务",@"高端体检",@"功能性体检",@"体检报告风险评估",@"预约专家",@"温馨陪诊",@"全科医生",@""];
        NSString *str = [NSString stringWithFormat:@"   %@",strArr[indexPath.row]];
        [curCell.selectButton setTitle:str forState:UIControlStateNormal];
        [curCell.selectButton sizeToFit];
        cell = curCell;
    }
    else if(indexPath.section == 2){

            MemberBuyCell1 * curCell = [tableView dequeueReusableCellWithIdentifier:@"MemberBuyCell1"];
//            curCell.moneyLabel.text = @"450";
//            curCell.moneyTextField.text = [NSString stringWithFormat:@"%.f",self.totalMoney];
            [curCell.moneyTextField addActiontextFieldChanged:^(UITextField *textField) {
//                weakSelf.totalMoney = [textField.text doubleValue];
            }];
            cell = curCell;

    }
    else if(indexPath.section == 3){
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
    else if(indexPath.section == 4){
        CommonCell1 * curCell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell1"];
        
        NSString *moneyStr = @"1350.00";
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
    if(indexPath.section == 1){
        if([self.selectOrders containsObject:@(indexPath.row)]){
            [self.selectOrders removeObject:@(indexPath.row)];
        }
        else{
            [self.selectOrders addObject:@(indexPath.row)];
        }
        [self.mainTableView reloadData];
    }
    if(indexPath.section == 3){
        self.selectPayType = indexPath.row;
        [self.mainTableView reloadData];
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
