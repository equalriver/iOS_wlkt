//
//  WLKTCourseDetailOtherCourseCollectionCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/11/1.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTCourseDetailOtherCourseCollectionCell.h"

@interface WLKTCourseDetailOtherCourseCollectionCell ()
@property (strong, nonatomic) UIImageView *imgIV;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *saleCountLabel;
@end

@implementation WLKTCourseDetailOtherCourseCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgIV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.saleCountLabel];
        [self makeConstraints];
    }
    return self;
}

- (void)setCellData:(WLKTCourseDetailNewAbout_list *)data{
    [self.imgIV setImageURL:[NSURL URLWithString:data.img]];
    self.titleLabel.text = data.coursename;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", data.showprice];
    self.saleCountLabel.text = [NSString stringWithFormat:@"收藏%@", data.shoucang];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imgIV.image = nil;
    self.titleLabel.text = nil;
    self.priceLabel.text = nil;
    self.saleCountLabel.text = nil;
}

- (void)makeConstraints{
    [self.imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(170 * ScreenRatio_6, 100 * ScreenRatio_6));
        make.top.mas_equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.imgIV.mas_bottom).offset(8 * ScreenRatio_6);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10 * ScreenRatio_6);
    }];
    [self.saleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.priceLabel.mas_bottom);
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
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _titleLabel.textColor = KMainTextColor_3;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _priceLabel.textColor = UIColorHex(e43b3b);
    }
    return _priceLabel;
}
- (UILabel *)saleCountLabel{
    if (!_saleCountLabel) {
        _saleCountLabel = [UILabel new];
        _saleCountLabel.font = [UIFont systemFontOfSize:10 * ScreenRatio_6];
        _saleCountLabel.textColor = KMainTextColor_9;
        _saleCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _saleCountLabel;
}

@end
