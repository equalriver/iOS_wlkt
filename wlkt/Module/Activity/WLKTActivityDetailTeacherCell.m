//
//  WLKTActivityDetailTeacherCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/12.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTActivityDetailTeacherCell.h"

@interface ActivityDetailTeacherCollectionCell: UICollectionViewCell
@property (strong, nonatomic) UIImageView *imgIV;
@property (strong, nonatomic) UILabel *teacherNameLabel;
//@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *tag_1_label;
@property (strong, nonatomic) UILabel *tag_2_label;
@property (strong, nonatomic) UILabel *tag_3_label;
- (void)setCellData:(WLKTCourseDetailNewTeacher *)data;

@end

@implementation ActivityDetailTeacherCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgIV];
        [self.contentView addSubview:self.teacherNameLabel];
        //        [self.contentView addSubview:self.tagLabel];
        [self.contentView addSubview:self.tag_1_label];
        [self.contentView addSubview:self.tag_2_label];
        [self.contentView addSubview:self.tag_3_label];
        [self makeConstraints];
    }
    return self;
}

- (void)setCellData:(WLKTCourseDetailNewTeacher *)data{
    [self.imgIV setImageURL:[NSURL URLWithString:data.headimg]];
    self.teacherNameLabel.text = data.name;
    NSArray *tagsArr = [data.tags componentsSeparatedByString:@"\\n"];
    switch (tagsArr.count) {
        case 1:
            self.tag_1_label.text = tagsArr[0];
            break;
        case 2:
            self.tag_1_label.text = tagsArr[0];
            break;
        case 3:
            self.tag_1_label.text = tagsArr[0];
            self.tag_2_label.text = tagsArr[1];
            break;
        case 4:
            self.tag_1_label.text = tagsArr[0];
            self.tag_2_label.text = tagsArr[1];
            self.tag_3_label.text = tagsArr[2];
            break;
        default:
            break;
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imgIV.image = nil;
    self.teacherNameLabel.text = nil;
    self.tag_1_label.text = nil;
    self.tag_2_label.text = nil;
    self.tag_3_label.text = nil;
}

- (void)makeConstraints{
    [self.imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
    }];
    [self.teacherNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.left.mas_equalTo(self.imgIV.mas_right).offset(10 * ScreenRatio_6);
        make.right.mas_equalTo(self.contentView).offset(-2);
    }];
    //    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.teacherNameLabel);
    //        make.top.mas_equalTo(self.teacherNameLabel.mas_bottom).offset(10);
    //    }];
    [self.tag_1_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.teacherNameLabel);
        make.top.mas_equalTo(self.teacherNameLabel.mas_bottom).offset(5);
    }];
    [self.tag_2_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.teacherNameLabel);
        make.top.mas_equalTo(self.tag_1_label.mas_bottom).offset(2);
    }];
    [self.tag_3_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.teacherNameLabel);
        make.top.mas_equalTo(self.tag_2_label.mas_bottom).offset(2);
    }];
}

#pragma mark - get
- (UIImageView *)imgIV{
    if (!_imgIV) {
        _imgIV = [UIImageView new];
        _imgIV.layer.masksToBounds = YES;
    }
    return _imgIV;
}
- (UILabel *)teacherNameLabel{
    if (!_teacherNameLabel) {
        _teacherNameLabel = [UILabel new];
        _teacherNameLabel.font = [UIFont systemFontOfSize:13 * ScreenRatio_6];
        _teacherNameLabel.textColor = KMainTextColor_3;
    }
    return _teacherNameLabel;
}
//- (UILabel *)tagLabel{
//    if (!_tagLabel) {
//        _tagLabel = [UILabel new];
//        _tagLabel.font = [UIFont systemFontOfSize:12];
//        _tagLabel.textColor = UIColorHex(999999);
//        _tagLabel.text = @"标签";
//    }
//    return _tagLabel;
//}
- (UILabel *)tag_1_label{
    if (!_tag_1_label) {
        _tag_1_label = [UILabel new];
        _tag_1_label.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _tag_1_label.textColor = UIColorHex(37becc);
    }
    return _tag_1_label;
}
- (UILabel *)tag_2_label{
    if (!_tag_2_label) {
        _tag_2_label = [UILabel new];
        _tag_2_label.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _tag_2_label.textColor = UIColorHex(37becc);
    }
    return _tag_2_label;
}
- (UILabel *)tag_3_label{
    if (!_tag_3_label) {
        _tag_3_label = [UILabel new];
        _tag_3_label.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _tag_3_label.textColor = UIColorHex(37becc);
    }
    return _tag_3_label;
}

@end

/****************************************************************************/
@interface WLKTActivityDetailTeacherCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *contentCV;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (copy, nonatomic) NSArray<WLKTCourseDetailNewTeacher *> *teacherArr;
@end

@implementation WLKTActivityDetailTeacherCell
- (instancetype)initWithTeacherArray:(NSArray<WLKTCourseDetailNewTeacher *> *)array
{
    self = [super init];
    if (self) {
        _teacherArr = [NSArray arrayWithArray:array];
        [self.contentView addSubview:self.contentCV];
    }
    return self;
}


#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.teacherArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ActivityDetailTeacherCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityDetailTeacherCollectionCell" forIndexPath:indexPath];
    [cell setCellData:self.teacherArr[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectedTeacherItem:)]) {
        [self.delegate didSelectedTeacherItem:indexPath];
    }
}

#pragma mark - get
- (UICollectionView *)contentCV{
    if (!_contentCV) {
        _contentCV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 130) collectionViewLayout:self.layout];
        _contentCV.delegate = self;
        _contentCV.dataSource = self;
        _contentCV.backgroundColor = UIColorHex(ffffff);
        _contentCV.showsHorizontalScrollIndicator = NO;
        [_contentCV registerClass:[ActivityDetailTeacherCollectionCell class] forCellWithReuseIdentifier:@"ActivityDetailTeacherCollectionCell"];
    }
    return _contentCV;
}
- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.itemSize = CGSizeMake(160, 105);
        _layout.minimumInteritemSpacing = 5 * ScreenRatio_6;
        _layout.sectionInset = UIEdgeInsetsMake(0, 10 * ScreenRatio_6, 15 * ScreenRatio_6, 0);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

@end

