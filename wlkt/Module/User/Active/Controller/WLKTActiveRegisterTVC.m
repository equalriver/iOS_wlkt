//
//  WLKTActiveRegisterTVC.m
//  wlkt
//
//  Created by 尹平江 on 2017/7/10.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTActiveRegisterTVC.h"
#import "WLKTActiveRegisterCell.h"
#import "WLKTTableviewRefresh.h"
#import <MJRefresh.h>
#import "WLKTActiveRegisterData.h"
#import "WLKTActiveRegisterListData.h"
#import "WLKTActiveRegisterApi.h"
#import "WLKTActivityDetailVC.h"

typedef void(^refreshBlock)(void);

@interface WLKTActiveRegisterTVC ()
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

static NSString * const activeRegisterCell = @"activeRegisterCell";

@implementation WLKTActiveRegisterTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setHeaderRefreshing];
    //[self setFooterRefreshing];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLKTActiveRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:activeRegisterCell];
    if (cell == nil) {
        cell = [[WLKTActiveRegisterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activeRegisterCell];
    }
    if (self.dataArr.count > 0) {
        [cell setCellContent:self.dataArr[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 305 * ScreenRatio_6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setHidesBottomBarWhenPushed:YES];
    if (self.dataArr.count > 0) {
        WLKTActiveRegisterData *data = self.dataArr[indexPath.row];
        if (data.valid.intValue == 1) {
            WLKTActivityDetailVC *vc = [[WLKTActivityDetailVC alloc]initWithActivityId:data.cid];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"该活动已结束或下架"];
        }
        
    }
}

#pragma mark - network

- (void)request {
    //WS(weakSelf);
    WLKTActiveRegisterApi *api = [[WLKTActiveRegisterApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        
        [self.dataArr removeAllObjects];
        
        WLKTActiveRegisterListData *data = [WLKTActiveRegisterListData modelWithDictionary:request.responseJSONObject[@"result"]];
        if (data.list.count) {
            [self.dataArr addObjectsFromArray:data.list];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                 if (!self.dataArr.count) {
                     self.tableView.state = WLKTViewStateEmpty;
                     self.tableView.imageForStateEmpty = [UIImage imageNamed:@"活动-缺省"];
                     //self.tableView.buttonColorForStateEmpty = navigationBgColor;
                     self.tableView.buttonTitleForStateEmpty = @"暂无报名活动";
                     self.tableView.emptyButtonClickBlock = ^{
                     
                     };
                 }
             
            });
        }
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.state = WLKTViewStateError;
        WS(weakSelf);
        self.tableView.emptyButtonClickBlock = ^{
            [weakSelf request];
        };
    }];
}

#pragma mark - refresh
- (void)setHeaderRefreshing{
    WS(weakSelf);
    [WLKTTableviewRefresh tableviewRefreshHeaderWithTaget:self.tableView request:^() {

        [weakSelf request];
    }];
    
}

//- (void)setFooterRefreshing{
//    WS(weakSelf);
//    [WLKTTableviewRefresh tableviewRefreshFooterWithTaget:self.tableView block:^() {
//        [weakSelf requestWithRefreshBlock:^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.tableView.mj_footer endRefreshing];
//                [weakSelf.tableView reloadData];
//            });
//        }];
//    }];
//
//}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
