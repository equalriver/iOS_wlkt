//
//  WLKTNewsNormalNewsTVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/1/2.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTNewsNormalNewsTVC.h"
#import "WLKTFrontPageCell.h"
#import "WLKTNewsApi.h"
#import "WLKTTableviewRefresh.h"
#import "WLKTNewsNormalNewsList.h"
#import "WLKTSchoolNewsDetailVC.h"

@interface WLKTNewsNormalNewsTVC ()
@property (nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray<WLKTNewsNormalNewsList *> *dataArr;
@end

@implementation WLKTNewsNormalNewsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kMainBackgroundColor;
    self.page = 1;
    [self setRefresh];
    [self loadDataWithPage:self.page];
}

#pragma mark - network
- (void)loadDataWithPage:(NSInteger)page{
    self.tableView.state = WLKTViewStateLoading;
    WLKTNewsApi *api = [[WLKTNewsApi alloc]initWithType:WLKTNewsTypeNews page:page];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        self.tableView.state = WLKTViewStateNormal;
        NSArray *arr = [NSArray modelArrayWithClass:[WLKTNewsNormalNewsList class] json:request.responseJSONObject[@"result"]];
        if (arr.count == 0) {
            if (page > 1) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [self.tableView.mj_footer endRefreshing];
                self.tableView.state = WLKTViewStateEmpty;
                self.tableView.imageForStateEmpty = [UIImage imageNamed:@"无内容"];
                self.tableView.titleForStateEmpty = @"无内容";
            }
        }
        else{
            if (page == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.state = WLKTViewStateError;
        WS(weakSelf);
        self.tableView.emptyButtonClickBlock = ^{
            [weakSelf loadDataWithPage:weakSelf.page];
        };
    }];
}

- (void)setRefresh{
    WS(weakSelf);
    [WLKTTableviewRefresh tableviewRefreshHeaderWithTaget:self.tableView request:^{
        weakSelf.page = 1;
        [weakSelf loadDataWithPage:1];
    }];
    [WLKTTableviewRefresh tableviewRefreshFooterWithTaget:self.tableView block:^{
        weakSelf.page++;
        [weakSelf loadDataWithPage:weakSelf.page];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArr[indexPath.row].imglist.count == 0) {
        return 100 *ScreenRatio_6;
    }
    if (self.dataArr[indexPath.row].imglist.count == 1) {
        return 110 *ScreenRatio_6;
    }
    CGFloat hhh = [self.dataArr[indexPath.row].title getSizeWithWidth:ScreenWidth - 20 *ScreenRatio_6 Font:17.5 *ScreenRatio_6].height;
    hhh = hhh > 40 ? hhh : 15 *ScreenRatio_6;
    return hhh +160 *ScreenRatio_6;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLKTFrontPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLKTFrontPageCell"];
    if (cell == nil) {
        cell = [[WLKTFrontPageCell alloc]init];
    }
    [cell setCellData:self.dataArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WLKTSchoolNewsDetailVC *vc = [[WLKTSchoolNewsDetailVC alloc]initWithNewsId:self.dataArr[indexPath.row].nid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (scrollView.contentOffset.y > ScreenHeight) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NewsGoTopShowNoti" object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NewsGoTopDismissNoti" object:nil];
    }
}

#pragma mark -
- (NSMutableArray<WLKTNewsNormalNewsList *> *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArr;
}
@end

