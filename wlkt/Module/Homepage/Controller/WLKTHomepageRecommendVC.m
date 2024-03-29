//
//  WLKTHomepageRecommendVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/1/23.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTHomepageRecommendVC.h"
#import "WLKTExchangeButton.h"
#import "WLKTTableviewRefresh.h"
#import "WLKTHPRecommendInterestCell.h"
#import "WLKTHPRecommendDiscountCell.h"
#import "WLKTHPRecommendNewCourseCell.h"
#import "WLKTHPRecommendVRCell.h"
#import "WLKTHPRecommendHotActivityCell.h"
#import "WLKTHPRecommendFoundCell.h"
#import "WLKTGetCouponVC.h"
#import "WLKTAppCoordinator.h"
#import "AppDelegate.h"
#import "WLKTHPNewApi.h"
#import "WLKTHPExchangeCourseApi.h"
#import "WLKTHomepage.h"
#import "WLKTHPBannerView.h"
#import "WLKTCDPageController.h"
#import "WLKTActivityDetailVC.h"
#import "WLKTSchoolVRPlayVC.h"
#import "WLKTCoursePageController.h"
#import "WLKTNewsVideoDetailVC.h"
#import "WLKTNewsAddVideoHitsApi.h"
#import "WLKTHPNewsMorenewsApi.h"
#import "WLKTSchoolNewsDetailVC.h"
#import "WLKTSchoolVC.h"
#import "WLKTActivityDetailVC.h"
#import "WKWebViewController.h"
#import "WLKTCouponSaleVC.h"

@interface WLKTHomepageRecommendVC ()<RecommendNewCourseDelegate, WLKTHPRecommendDelegate, RecommendInterestDelegate, HPBannerViewDelegate>
@property (strong, nonatomic) WLKTHPBannerView *bannerView;
@property (strong, nonatomic) UIView *headerView;

@property (copy, nonatomic) NSArray *titleArr;
@property (copy, nonatomic) NSArray *sectionImgArr;
@property (strong, nonatomic) NSMutableArray *bannerArr;
@property (strong, nonatomic) WLKTHomepage *data;
@property (strong, nonatomic) NSMutableArray<WLKTCourse *> *exchangeCourseArr;
@property (strong, nonatomic) NSMutableArray<WLKTNewsNormalNewsList *> *newslistArr;
@property (nonatomic) NSInteger page;
@end

@implementation WLKTHomepageRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kMainBackgroundColor;
//    [self setHeadView];
    [self loadData];
    [self setRefresh];
    self.page = 2;
}

- (UIView *)setHeadView{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 155 *ScreenRatio_6)];
    v.backgroundColor = [UIColor whiteColor];
    
    UIView *sep = [UIView new];
    sep.backgroundColor = separatorView_color;
    [v addSubview:sep];
    [v addSubview:self.bannerView];

    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 5 *ScreenRatio_6));
        make.bottom.left.mas_equalTo(v);
    }];
    return v;
}

#pragma mark - network
- (void)setRefresh{
    WS(weakSelf);
    [WLKTTableviewRefresh tableviewRefreshHeaderWithTaget:self.tableView request:^{
        weakSelf.page = 2;
        [weakSelf loadData];
    }];
    [WLKTTableviewRefresh tableviewRefreshFooterWithTaget:self.tableView block:^{
        weakSelf.page++;
        [weakSelf loadMoreData];
    }];
}

- (void)loadData{
    self.tableView.state = WLKTViewStateLoading;
    WLKTHPNewApi *api = [[WLKTHPNewApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.state = WLKTViewStateNormal;
        if (self.page == 2) {
            [self.newslistArr removeAllObjects];
        }
        self.data = [WLKTHomepage modelWithJSON:request.responseJSONObject[@"result"]];
        if (self.data) {
            //优惠
            if (self.data.yhlist.count) {
                [self.exchangeCourseArr removeAllObjects];
                [self.exchangeCourseArr addObjectsFromArray:self.data.yhlist];
            }
            //banner
            if (self.data.bannerlist.count) {
                [self.bannerArr removeAllObjects];
                for (WLKTCourse *obj in self.data.bannerlist) {
                    [self.bannerArr addObject:obj.img];
                }
                self.bannerView.bannerArr = self.bannerArr;
            }
            //发现
            if (self.data.newslist.count) {
                [self.newslistArr addObjectsFromArray:self.data.newslist];
                [self.tableView.mj_footer endRefreshing];
            }
            
            if (!self.headerView) {
                self.headerView = [self setHeadView];
            }
            self.tableView.tableHeaderView = self.headerView;
            
            [self.tableView reloadData];
            
        }
        else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.state = WLKTViewStateError;
        WS(weakSelf);
        self.tableView.emptyButtonClickBlock = ^{
            [weakSelf loadData];
        };
    }];
}

- (void)loadMoreData{
    WLKTHPNewsMorenewsApi *api = [[WLKTHPNewsMorenewsApi alloc]initWithPage:self.page];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSArray *arr = [NSArray modelArrayWithClass:[WLKTNewsNormalNewsList class] json:request.responseJSONObject[@"result"]];
        if (arr.count) {
            [self.tableView.mj_footer endRefreshing];
            [self.newslistArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadExchangeData{
    WLKTHPExchangeCourseApi *api = [[WLKTHPExchangeCourseApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSArray *arr = [NSArray modelArrayWithClass:[WLKTCourse class] json:request.responseJSONObject[@"result"]];
        if (arr.count) {
            [self.exchangeCourseArr removeAllObjects];
            [self.exchangeCourseArr addObjectsFromArray:arr];
            dispatch_async_on_main_queue(^{
                if (self.tableView.numberOfSections < 1){return ;}
                [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            });
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

- (void)addVideoHitsWithIndex:(NSInteger)index{
    WLKTNewsAddVideoHitsApi *api = [[WLKTNewsAddVideoHitsApi alloc]initWithNewsId:self.newslistArr[index].nid];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.data ? self.titleArr.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {//兴趣爱好
        return self.data.xq.count ? 1 : 0;
    }
    if (section == 1) {//限时优惠
        return self.exchangeCourseArr.count;
    }
    if (section == 2) {//上新好课
       return self.data.newcourselist.count ? 1 : 0;
    }
    if (section == 3) {//VR全景校园
        return self.data.vrlist.count ? 1 : 0;
    }
    if (section == 4) {//热门活动
        return self.data.actlist.count;
    }
    return self.newslistArr.count;//发现
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//兴趣爱好
        return 70;
    }
    if (indexPath.section == 1) {//限时优惠
        return 115 *ScreenRatio_6;
    }
    if (indexPath.section == 2) {//上新好课
        return 335 *ScreenRatio_6;
    }
    if (indexPath.section == 3) {//VR全景校园
        return 125 *ScreenRatio_6;
    }
    if (indexPath.section == 4) {//热门活动
        return 300 *ScreenRatio_6;
    }
    if (indexPath.section == 5) {//发现
        if (self.newslistArr[indexPath.row].video) {//视频
            CGFloat h = 250 *ScreenRatio_6;
            CGFloat hh = [self.newslistArr[indexPath.row].title getSizeWithWidth:ScreenWidth - 20 Font:18.5].height;
            h += hh > 45 *ScreenRatio_6 ? 40 *ScreenRatio_6 : hh;
            return h;
        }
        else{//新闻
            if (self.newslistArr[indexPath.row].imglist.count == 0) {
                return 100 *ScreenRatio_6;
            }
            if (self.newslistArr[indexPath.row].imglist.count == 1) {
                return 110 *ScreenRatio_6;
            }
            CGFloat hhh = [self.newslistArr[indexPath.row].title getSizeWithWidth:ScreenWidth - 20 Font:18.5].height;
            return hhh +160 *ScreenRatio_6;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 || section == 3) {
        return 95;
    }
    if (section == 4) {
        return 0.001;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//兴趣爱好
        WLKTHPRecommendInterestCell *cell = [[WLKTHPRecommendInterestCell alloc]initWithInterestArray:self.data.xq];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {//限时优惠
        WLKTHPRecommendDiscountCell *cell = [[WLKTHPRecommendDiscountCell alloc]init];
        [cell setCellData:self.exchangeCourseArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2) {//上新好课
        WLKTHPRecommendNewCourseCell *cell = [[WLKTHPRecommendNewCourseCell alloc]initWithCourseArray:self.data.newcourselist];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 3) {//VR全景校园
        WLKTHPRecommendVRCell *cell = [[WLKTHPRecommendVRCell alloc]initWithListArr:self.data.vrlist];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 4) {//热门活动
        WLKTHPRecommendHotActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLKTHPRecommendHotActivityCell *cell"];
        if (cell == nil) {
            cell = [[WLKTHPRecommendHotActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLKTHPRecommendHotActivityCell"];
        }
        [cell setCellData:self.data.actlist[indexPath.row] index:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //发现
    WLKTHPRecommendFoundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLKTHPRecommendFoundCell"];
    if (cell == nil) {
        cell = [[WLKTHPRecommendFoundCell alloc]init];
    }
    [cell setCellData:self.newslistArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    v.backgroundColor = [UIColor whiteColor];
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.sectionImgArr[section]]];
    [v addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.centerY.mas_equalTo(v);
        make.left.mas_equalTo(v).offset(10 *ScreenRatio_6);
    }];
    
    UILabel *l = [UILabel new];
    l.font = [UIFont systemFontOfSize:14 *ScreenRatio_6 weight:UIFontWeightSemibold];
    l.textColor = KMainTextColor_3;
    l.text = self.titleArr[section];
    [v addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(v);
        make.left.mas_equalTo(icon.mas_right).offset(5);
    }];
    
    WLKTExchangeButton *btn = [WLKTExchangeButton new];
    [btn setImage:[UIImage imageNamed:@"进入-拷贝"] forState:UIControlStateNormal];
    [btn setTitle:@"更多    " forState:UIControlStateNormal];
    [btn setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
    [btn addTarget:self action:@selector(sectionHeaderAct:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = section;
    [v addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(v.mas_right).offset(-10 *ScreenRatio_6);
        make.height.centerY.mas_equalTo(v);
    }];
    if (section == 0 || section == 2 || section == 3) {
        btn.hidden = YES;
    }
    if (section == 1) {
        [btn setImage:[UIImage imageNamed:@"HP_换一换"] forState:UIControlStateNormal];
        [btn setTitle:@"换一换    " forState:UIControlStateNormal];
    }
    
//    if (section == 3) {
//        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HP_new"]];
//        [v addSubview:iv];
//        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(15, 12));
//            make.top.mas_equalTo(v).offset(5);
//            make.left.mas_equalTo(l.mas_right);
//        }];
//    }
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1 || section == 3) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 95)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        bgView.tag = section;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerFooterViewAct:)];
        [bgView addGestureRecognizer:tap];
        
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:section == 1 ? @"HP_领券banner" : @"HP_banner活动"]];
        [bgView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView);
            make.bottom.mas_equalTo(bgView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20 *ScreenRatio_6, 70 *ScreenRatio_6));
        }];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
        v.backgroundColor = separatorView_color;
        [bgView addSubview:v];
        
        return bgView;
    }
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    v.backgroundColor = separatorView_color;
    
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {//限时优惠
        WLKTCDPageController *vc = [[WLKTCDPageController alloc]initWithCourseId:self.exchangeCourseArr[indexPath.row].uid];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 4) {//热门活动
        WLKTActivityDetailVC *vc = [[WLKTActivityDetailVC alloc]initWithActivityId:self.data.actlist[indexPath.row].aid];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 5) {////发现
        if (self.newslistArr[indexPath.row].video) {
            [self addVideoHitsWithIndex:indexPath.row];
            WLKTNewsVideoDetailVC *vc = [[WLKTNewsVideoDetailVC alloc]initWithNewsId:self.newslistArr[indexPath.row].nid];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            WLKTSchoolNewsDetailVC *vc = [[WLKTSchoolNewsDetailVC alloc]initWithNewsId:self.newslistArr[indexPath.row].nid];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark - banner view delegate
- (void)didSelectedBannerItem:(NSInteger)index{
    UIViewController *vc;
    
    switch (self.data.bannerlist[index].type) {
            
        case WLKTBannerListTyeNormal:
            break;
        case WLKTBannerListTyeSchool:
            vc = [[WLKTSchoolVC alloc] initWithSchoolId:self.data.bannerlist[index].url];
            
            break;
        case WLKTBannerListTyeCourseDetail:
            if (self.data.bannerlist[index].uid.length > 0) {
                vc = [[WLKTCDPageController alloc] initWithCourseId:self.data.bannerlist[index].url];

            }
        
            break;
        case WLKTBannerListTyeActivityDetail:
            vc = [[WLKTActivityDetailVC alloc] initWithActivityId:self.data.bannerlist[index].url];
            
            break;
        case WLKTBannerListTyeURL:
            vc = [[WKWebViewController alloc] init];
            [(WKWebViewController *)vc loadWebURLSring:self.data.bannerlist[index].url];
            
            break;

        default:
            break;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RecommendInterestDelegate
- (void)didSelectedInterestItem:(NSInteger)index{
    WLKTCoursePageController *vc = [[WLKTCoursePageController alloc] initWithCourseClassifition:self.data.xq[index].title];
    [vc setHidesBottomBarWhenPushed:YES];
    vc.navigationItem.title = self.data.xq[index].title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RecommendNewCourseDelegate
- (void)didSelectedRecommendNewCourseItem:(NSInteger)index{
    WLKTCDPageController *vc = [[WLKTCDPageController alloc]initWithCourseId:self.data.newcourselist[index].uid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WLKTHPRecommendDelegate
- (void)didSelectedVRPhotoWithIndex:(NSInteger)index{
    WLKTSchoolVRPlayVC *vc = [[WLKTSchoolVRPlayVC alloc]initWithVRListData:self.data.vrlist[index]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action
- (void)sectionHeaderAct:(UIButton *)sender{
    if (sender.tag == 1) {//换一换
        [self loadExchangeData];
    }
    if (sender.tag == 4) {//活动
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectedActivityNoti" object:nil];
    }
    if (sender.tag == 5) {//发现
        WLKTAppCoordinator *appCoordinator = ((AppDelegate *)[UIApplication sharedApplication].delegate).appCoordinator;
        appCoordinator.tabBarController.selectedIndex = 2;
    }

}


- (void)bannerFooterViewAct:(UITapGestureRecognizer *)sender{
    if (sender.view.tag == 1) {//领券banner
        WLKTGetCouponVC *vc = [[WLKTGetCouponVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{//banner活动
        WLKTCouponSaleVC *vc = [[WLKTCouponSaleVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        [[NSNotificationCenter defaultCenter]postNotificationName:kHP_GoActivityNoti object:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (scrollView.contentOffset.y > ScreenHeight) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"homepageGoTopShowNoti" object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"homepageGoTopDismissNoti" object:nil];
    }
}

#pragma mark - get
- (WLKTHPBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[WLKTHPBannerView alloc]initWithFrame:CGRectMake(0, 10 *ScreenRatio_6, ScreenWidth, 130 *ScreenRatio_6)];
        _bannerView.backgroundColor = [UIColor whiteColor];
        _bannerView.delegate = self;
    }
    return _bannerView;
}
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"兴趣爱好", @"限时优惠", @"上新好课", @"VR全景校园", @"热门活动", @"发现"];
    }
    return _titleArr;
}
-(NSArray *)sectionImgArr{
    if (!_sectionImgArr) {
        _sectionImgArr = @[@"HP_兴趣爱好", @"HP_限时优惠", @"HP_上新好课", @"HP_VR全景校园", @"HP_热门活动", @"HP_发现"];
    }
    return _sectionImgArr;
}
- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray arrayWithCapacity:3];
    }
    return _bannerArr;
}
- (NSMutableArray<WLKTCourse *> *)exchangeCourseArr{
    if (!_exchangeCourseArr) {
        _exchangeCourseArr = [NSMutableArray arrayWithCapacity:2];
    }
    return _exchangeCourseArr;
}
- (NSMutableArray<WLKTNewsNormalNewsList *> *)newslistArr{
    if (!_newslistArr) {
        _newslistArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _newslistArr;
}
@end
