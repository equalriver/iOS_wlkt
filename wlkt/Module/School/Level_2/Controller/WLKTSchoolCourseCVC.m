//
//  WLKTSchoolCourseCVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/11/21.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTSchoolCourseCVC.h"
#import "WLKTCourseDetailOtherCourseCollectionCell.h"
#import "WLKTTableviewRefresh.h"
#import "WLKTCDPageController.h"
#import "WLKTSchoolCourseApi.h"
#import "WLKTTableviewRefresh.h"
#import <UIScrollView+EmptyDataSet.h>

@interface WLKTSchoolCourseCVC ()<DZNEmptyDataSetSource>
@property (copy, nonatomic) NSString *suid;
@property (assign) NSInteger page;
@property (strong, nonatomic) NSMutableArray<WLKTCourseDetailNewAbout_list *> *dataArr;
@end

@implementation WLKTSchoolCourseCVC

static NSString * const reuseIdentifier = @"SchoolCourseCell";
- (instancetype)initWithSchoolId:(NSString *)suid
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(170 * ScreenRatio_6, 150 * ScreenRatio_6);
    layout.sectionInset = UIEdgeInsetsMake(10 * ScreenRatio_6, 10 * ScreenRatio_6, 20 * ScreenRatio_6, 10 * ScreenRatio_6);
    layout.minimumLineSpacing = 2.5 * ScreenRatio_6;
    layout.minimumInteritemSpacing = 2.5 * ScreenRatio_6;
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.collectionViewLayout = layout;
        _suid = suid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学校课程";
    [self.collectionView registerClass:[WLKTCourseDetailOtherCourseCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.emptyDataSetSource = self;
    [self setRefresh];
}

#pragma mark - empty data source
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"message_bg"];
}

#pragma mark - network
- (void)loadData{
    WLKTSchoolCourseApi *api = [[WLKTSchoolCourseApi alloc]initWithSchoolId:self.suid page:self.page];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSArray *arr = [NSArray modelArrayWithClass:[WLKTCourseDetailNewAbout_list class] json:request.responseJSONObject[@"result"][@"list"]];
        if (self.page == 1) {
            [self.collectionView.mj_footer resetNoMoreData];
            [self.dataArr removeAllObjects];
        }
        if (self.page == 1) {
            if (!arr.count) {
                [self.collectionView.mj_footer endRefreshing];
            }
        }
        else{
            if (arr.count) {
                [self.collectionView.mj_footer endRefreshing];
            }
            else{
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.dataArr addObjectsFromArray:arr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        ShowApiError
    }];
}

- (void)setRefresh{
    WS(weakSelf);
    [WLKTTableviewRefresh tableviewRefreshHeaderWithTaget:self.collectionView request:^{
        weakSelf.page = 1;

        [weakSelf loadData];
    }];
    [WLKTTableviewRefresh tableviewRefreshFooterWithTaget:self.collectionView block:^{
        if (weakSelf.dataArr.count) {
            weakSelf.page++;
            [weakSelf loadData];
        }
        else{
            weakSelf.collectionView.mj_footer = nil;
        }
    }];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WLKTCourseDetailOtherCourseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setCellData:self.dataArr[indexPath.item]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WLKTCDPageController *vc = [[WLKTCDPageController alloc]initWithCourseId:self.dataArr[indexPath.item].cid];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - get
- (NSMutableArray<WLKTCourseDetailNewAbout_list *> *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArr;
}
@end
