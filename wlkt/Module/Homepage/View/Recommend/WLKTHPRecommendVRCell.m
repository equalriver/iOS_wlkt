//
//  WLKTHPRecommendVRCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/1/24.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTHPRecommendVRCell.h"

@interface WLKTHPRecommendVRCollectionCell: UICollectionViewCell
@property (strong, nonatomic) UIImageView *VRImageIV;
@property (strong, nonatomic) UIImageView *VRImgIcon;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation WLKTHPRecommendVRCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.VRImageIV];
        [self.contentView addSubview:self.titleLabel];
        [self.VRImageIV addSubview:self.VRImgIcon];
        [self.VRImageIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(140 *ScreenRatio_6, 90 *ScreenRatio_6));
            make.top.centerX.mas_equalTo(self.contentView);
        }];
        [self.VRImgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.VRImageIV);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.bottom.centerX.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCellData:(UIImage *)image{
    self.VRImageIV.image = image;
    self.VRImgIcon.hidden = YES;
}

- (void)setCellWithListData:(WLKTSchoolVRList *)data{
    [self.VRImageIV setImageURL:[NSURL URLWithString:data.image]];
    self.titleLabel.text = data.name;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.VRImageIV.image = nil;
    self.titleLabel.text = nil;
}

- (UIImageView *)VRImageIV{
    if (!_VRImageIV) {
        _VRImageIV = [[UIImageView alloc]init];

    }
    return _VRImageIV;
}
- (UIImageView *)VRImgIcon{
    if (!_VRImgIcon) {
        _VRImgIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_panorama"]];
    }
    return _VRImgIcon;
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
@end


/***************************************************************************/
@interface WLKTHPRecommendVRCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *contentCV;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (copy, nonatomic) NSArray<WLKTSchoolVRList *> *imageArr;
@end

@implementation WLKTHPRecommendVRCell
- (instancetype)initWithListArr:(NSArray<WLKTSchoolVRList *> *)array
{
    self = [super init];
    if (self) {
        _imageArr = [NSArray arrayWithArray:array];
        [self.contentView addSubview:self.contentCV];
    }
    return self;
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageArr.count) {
        return self.imageArr.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WLKTHPRecommendVRCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WLKTHPRecommendVRCollectionCell" forIndexPath:indexPath];
    if (!self.imageArr.count) {
        [cell setCellData:[UIImage imageNamed:@"VR"]];
    }
    else{
        [cell setCellWithListData:self.imageArr[indexPath.item]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectedVRPhotoWithIndex:)]) {
        [self.delegate didSelectedVRPhotoWithIndex:indexPath.item];
    }
}

#pragma mark - get
- (UICollectionView *)contentCV{
    if (!_contentCV) {
        _contentCV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120 *ScreenRatio_6) collectionViewLayout:self.layout];
        _contentCV.showsVerticalScrollIndicator = NO;
        _contentCV.showsHorizontalScrollIndicator = NO;
        _contentCV.delegate = self;
        _contentCV.dataSource = self;
        _contentCV.backgroundColor = UIColorHex(ffffff);
        [_contentCV registerClass:[WLKTHPRecommendVRCollectionCell class] forCellWithReuseIdentifier:@"WLKTHPRecommendVRCollectionCell"];
    }
    return _contentCV;
}
- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.itemSize = CGSizeMake(140 *ScreenRatio_6, 120 *ScreenRatio_6);
        _layout.minimumInteritemSpacing = 10 *ScreenRatio_6;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionInset = UIEdgeInsetsMake(0, 10 *ScreenRatio_6, 0, 10 *ScreenRatio_6);
    }
    return _layout;
}
@end
