//
//  OrderExpertVC.m
//  Suffer
//
//   Created by  licc on 2018/8/25.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "OrderExpertVC.h"
//#import "OrderExpertCollectionViewCell.h"
//#import "OrderExpertTableViewCell.h"
#import "WeekTableViewCell.h"
#import "CommonCell1.h"
#import "CommonCell0.h"

@interface OrderExpertVC ()
@end

@implementation OrderExpertVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createViews];
}
-(void)createViews{
    self.title = @"范中杰";//专家名字
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithTitle:@"专家介绍" style:UIBarButtonItemStylePlain target:self action:@selector(introduceAction)];
    self.navigationItem.rightBarButtonItem = item;
    registerNibWithCellName(self.mainTableView, @"WeekTableViewCell");
    registerNibWithCellName(self.mainTableView, @"CommonCell1");
    registerNibWithCellName(self.mainTableView, @"CommonCell0");
    self.mainTableView.estimatedRowHeight = 60;
    self.mainTableView.sectionHeaderHeight = 10;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIButton *button = [[UIButton alloc]init];
    [footView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(footView);
        make.width.mas_equalTo(footView).multipliedBy(0.8);
        make.height.mas_equalTo(44);
    }];
    LR_BUTTON_STYLE(button);
    [button setTitle:@"提交预约" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendOrder:) forControlEvents:UIControlEventTouchUpInside];
    self.mainTableView.tableFooterView = footView;
}
-(void)introduceAction{
    DLog(@"");
}
-(void)sendOrder:(UIButton *)sender{
    DLog(@"提交预约");
}
#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0||indexPath.row == 1||indexPath.row == 2){
            return 44;
        }
        else if(indexPath.row == 4){
            return    UITableViewAutomaticDimension;
        }
    }
    else if(indexPath.section == 0){
        return 44;
    }

    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell;

    if(indexPath.section == 0){
        if(indexPath.row == 0||indexPath.row == 1||indexPath.row == 2||indexPath.row == 3){
            WeekTableViewCell *curCell = [tableView dequeueReusableCellWithIdentifier:@"WeekTableViewCell"];
            curCell.style = indexPath.row;
            [curCell buttonSelected:nil];
            cell = curCell;
        }
        else if(indexPath.row == 4){
            CommonCell1 *curCell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell1"];
            curCell.label0.text = @"备注：上午 9:00-11:00        上午 9:00-11:00\n        上午 9:00-11:00";
            cell = curCell;
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
             UITableViewCell *curCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
            curCell.imageView.image = [UIImage imageNamed:@"icon_41"];
            curCell.textLabel.text = @"预约前，抢先联系专家，确定就诊时间段！";
            curCell.backgroundColor = [UIColor orangeColor];
            curCell.textLabel.textColor = LR_REDLCOLOR;
            cell = curCell;

        }
        else{
            CommonCell0 *curCell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell0"];

            if(indexPath.row == 1){
                curCell.label0.text = @"预约人：";
                curCell.textField.placeholder = @"请速入姓名";
                curCell.textField.text = @"";
                curCell.textField.userInteractionEnabled = YES;
                curCell.rightButton.hidden = YES;

            }
            else if(indexPath.row == 2){
                curCell.label0.text = @"诊断日期：";
                curCell.textField.text = @"";
                curCell.textField.placeholder = @"请选择日期";
                curCell.textField.userInteractionEnabled = NO;
                [curCell.rightButton setImage:[UIImage imageNamed:@"icon_33"] forState:UIControlStateNormal];
                curCell.rightButton.hidden = NO;
            }
            else if(indexPath.row == 3){
                curCell.label0.text = @"就诊时间段：";
                curCell.textField.text = @"";
                curCell.textField.placeholder = @"请选择时间段";
                curCell.textField.userInteractionEnabled = NO;
                [curCell.rightButton setImage:[UIImage imageNamed:@"icon_26"] forState:UIControlStateNormal];
                curCell.rightButton.hidden = NO;
            }
            cell = curCell;

        }
    }
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"c"];
    }

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 5;
    }
    else if(section == 1){
        return 4;
    }
    
    return 4;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
