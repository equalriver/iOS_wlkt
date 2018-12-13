//
//  WLKTSchoolVideoCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/11/20.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTSchoolVideoCell.h"

@interface WLKTSchoolVideoCollectionCell: UICollectionViewCell
@property (strong, nonatomic) UIImageView *imgIV;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *videoTagIV;
- (void)setCellData:(WLKTSchoolVideoList *)data;
@end

@implementation WLKTSchoolVideoCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgIV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.videoTagIV];
        [self makeConstraints];
    }
    return self;
}

- (void)setCellData:(WLKTSchoolVideoList *)data{
    [self.imgIV setImageURL:[NSURL URLWithString:data.video_img]];
    self.titleLabel.text = data.title;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imgIV.image = nil;
    self.titleLabel.text = nil;
}

- (void)makeConstraints{
    [self.imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140 *ScreenRatio_6, 90 *ScreenRatio_6));
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140 *ScreenRatio_6, 15 *ScreenRatio_6));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.videoTagIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-30 *ScreenRatio_6);
    }];
}

- (UIImageView *)imgIV{
    if (!_imgIV) {
        _imgIV = [UIImageView new];
        _imgIV.layer.masksToBounds = YES;
    }
    return _imgIV;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _titleLabel.textColor = KMainTextColor_3;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)videoTagIV{
    if (!_videoTagIV) {
        _videoTagIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"视频"]];
    }
    return _videoTagIV;
}

@end

//**********************************************************************
@interface WLKTSchoolVideoCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *videoCV;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
//@property (strong, nonatomic) UIView *separatorView;
@property (copy, nonatomic) NSArray<WLKTSchoolVideoList *> *dataArr;
@end

@implementation WLKTSchoolVideoCell
- (instancetype)initWithData:(NSArray<WLKTSchoolVideoList *> *)dataArr
{
    self = [super init];
    if (self) {
        _dataArr = [NSArray arrayWithArray:dataArr];
        [self.contentView addSubview:self.videoCV];
//        [self.contentView addSubview:self.separatorView];
    }
    return self;
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WLKTSchoolVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WLKTSchoolVideoCollectionCell" forIndexPath:indexPath];
    [cell setCellData:self.dataArr[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectedVideoItem:)]) {
        [self.delegate didSelectedVideoItem:indexPath];
    }
}

#pragma mark - get
- (UICollectionView *)videoCV{
    if (!_videoCV) {
        _videoCV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 115 *ScreenRatio_6) collectionViewLayout:self.layout];
        _videoCV.showsVerticalScrollIndicator = NO;
        _videoCV.showsHorizontalScrollIndicator = NO;
        _videoCV.delegate = self;
        _videoCV.dataSource = self;
        _videoCV.backgroundColor = [UIColor whiteColor];
        [_videoCV registerClass:[WLKTSchoolVideoCollectionCell class] forCellWithReuseIdentifier:@"WLKTSchoolVideoCollectionCell"];
    }
    return _videoCV;
}
- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = CGSizeMake(140 *ScreenRatio_6, 115 *ScreenRatio_6);
        _layout.minimumInteritemSpacing = 10 *ScreenRatio_6;
        _layout.sectionInset = UIEdgeInsetsMake(0, 10 *ScreenRatio_6, 0, 0);
    }
    return _layout;
}
//- (UIView *)separatorView{
//    if (!_separatorView) {
//        _separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 119 + 0.5, ScreenWidth, 0.5)];
//        _separatorView.backgroundColor = separatorView_color;
//    }
//    return _separatorView;
//}

@end
