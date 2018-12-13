//
//  WLKTCouponSaleCourseCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/8/18.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTCouponSaleCourseCell.h"
#import "WLKTCouponSaleCollectionViewCell.h"
#import "WLKTCDPageController.h"

@interface WLKTCouponSaleCourseCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) UICollectionView *courseItemCV;
@property (strong, nonatomic) NSMutableArray<WLKTSaleCourseData *> *dataArr;
@property (strong, nonatomic) UIViewController *target;
@end

@implementation WLKTCouponSaleCourseCell

- (instancetype)initWithSaleCourse:(NSArray<WLKTSaleCourseData *> *)data target:(UIViewController *)target
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        self.dataArr = data.mutableCopy;
        _target = target;
        self.backgroundColor = [UIColor colorWithHexString:@"#fb9661"];
        [self.contentView addSubview:self.titleIV];
        [self.contentView addSubview:self.courseItemCV];
        [self makeConstraints];
        
        [self.courseItemCV registerClass:[WLKTCouponSaleCollectionViewCell class] forCellWithReuseIdentifier:@"CouponSaleCollectionViewCell"];
    }
    return self;
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WLKTCouponSaleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CouponSaleCollectionViewCell" forIndexPath:indexPath];
    [cell setCellData:self.dataArr[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WLKTCDPageController *vc = [[WLKTCDPageController alloc]initWithCourseId:self.dataArr[indexPath.item].cid];
    [self.target.navigationController pushViewController:vc animated:YES];
}

#pragma mark - make constraints
- (void)makeConstraints{
    [self.titleIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(150, 25));
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(20 * ScreenRatio_6);
    }];
    [self.courseItemCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.top.mas_equalTo(self.titleIV.mas_bottom).offset(8);
    }];
}

#pragma mark - get
- (NSMutableArray<WLKTSaleCourseData *> *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (UIImageView *)titleIV{
    if (!_titleIV) {
        _titleIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"折扣课程标题2"]];
    }
    return _titleIV;
}
- (UICollectionView *)courseItemCV{
    if (!_courseItemCV) {
        _courseItemCV = [[UICollectionView alloc]initWithFrame:CGRectNull collectionViewLayout:self.layout];
        _courseItemCV.backgroundColor = [UIColor colorWithHexString:@"#fb9661"];
        _courseItemCV.dataSource = self;
        _courseItemCV.delegate = self;
        _courseItemCV.scrollEnabled = NO;
    }
    return _courseItemCV;
}
- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(0, 8 *ScreenRatio_6, 10, 8 *ScreenRatio_6);
        _layout.minimumInteritemSpacing = 5;
        _layout.minimumLineSpacing = 5;
        _layout.itemSize = CGSizeMake(175 * ScreenRatio_6, 205 * ScreenRatio_6);
        
    }
    return _layout;
}

@end