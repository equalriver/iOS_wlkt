//
//  WLKTHPRecommendDiscountCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/1/24.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTHPRecommendDiscountCell.h"

@interface RecommendDiscountItemView: UIView
@property (strong, nonatomic) UIImageView *iconIV;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation RecommendDiscountItemView
- (instancetype)initWithImage:(NSString *)img title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.iconIV.image = [UIImage imageNamed:img];
        self.titleLabel.text = title;
        [self addSubview:self.iconIV];
        [self addSubview:self.titleLabel];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15 *ScreenRatio_6, 15 *ScreenRatio_6));
            make.left.centerY.mas_equalTo(self);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconIV.mas_right).offset(10 *ScreenRatio_6);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self).offset(-10 *ScreenRatio_6);
        }];
    }
    return self;
}

- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [UIImageView new];
    }
    return _iconIV;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _titleLabel.textColor = KMainTextColor_3;
    }
    return _titleLabel;
}
@end

@interface WLKTHPRecommendDiscountCell ()
@property (strong, nonatomic) UIImageView *imgIV;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *rawpriceLabel;
@property (strong, nonatomic) UIImageView *viewsIV;
@property (strong, nonatomic) UILabel *viewsLabel;
@property (strong, nonatomic) UIView *strikethroughLine;
@end

@implementation WLKTHPRecommendDiscountCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.contentView addSubview:self.imgIV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.rawpriceLabel];
        [self.imgIV addSubview:self.viewsIV];
        [self.imgIV addSubview:self.viewsLabel];
        [self makeConstraints];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imgIV.image = nil;
    self.titleLabel.text = nil;
    self.priceLabel.text = nil;
    self.rawpriceLabel.attributedText = nil;
    self.viewsLabel.text = nil;
    self.strikethroughLine = nil;
}

- (void)setCellData:(WLKTCourse *)data{
    [self.imgIV setImageURL:[NSURL URLWithString:data.img]];
    self.titleLabel.text = data.coursename;
    self.priceLabel.text = data.showprice;
    
    if (data.oldprice.length) {
        NSString *s = [NSString stringWithFormat:@"原价  %@", data.oldprice];
        NSMutableAttributedString *ats = [[NSMutableAttributedString alloc]initWithString:s attributes:@{NSForegroundColorAttributeName: KMainTextColor_9, NSFontAttributeName: [UIFont systemFontOfSize:10 *ScreenRatio_6]}];
        [self.rawpriceLabel addSubview:self.strikethroughLine];
        [self.strikethroughLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([s getSizeWithHeight:13 Font:10.5 *ScreenRatio_6].width);
            make.centerY.mas_equalTo(self.rawpriceLabel);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(self.rawpriceLabel).offset(-1);
        }];
        self.rawpriceLabel.attributedText = ats;
    }
    
    self.viewsLabel.text = [NSString stringWithFormat:@"%ld", data.hits];
    
    if (data.yharr.count == 1) {
        //one
        self.titleLabel.numberOfLines = 3;
        RecommendDiscountItemView *item_1 = [[RecommendDiscountItemView alloc]initWithImage:data.yharr[0].tag title:data.yharr[0].title];
        [self.contentView addSubview:item_1];
        [item_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imgIV.mas_right).offset(10 *ScreenRatio_6);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 *ScreenRatio_6);
        }];
    }
    if (data.yharr.count == 2) {
        //two
        self.titleLabel.numberOfLines = 2;
        RecommendDiscountItemView *item_1 = [[RecommendDiscountItemView alloc]initWithImage:data.yharr[0].tag title:data.yharr[0].title];
        [self.contentView addSubview:item_1];
        [item_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imgIV.mas_right).offset(10 *ScreenRatio_6);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 *ScreenRatio_6);
        }];
        RecommendDiscountItemView *item_2 = [[RecommendDiscountItemView alloc]initWithImage:data.yharr[1].tag title:data.yharr[1].title];
        [self.contentView addSubview:item_2];
        [item_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.mas_equalTo(item_1);
            make.top.mas_equalTo(item_1.mas_bottom).offset(5 *ScreenRatio_6);
        }];
    }
    if (data.yharr.count == 3) {
        //three
        self.titleLabel.numberOfLines = 1;
        RecommendDiscountItemView *item_1 = [[RecommendDiscountItemView alloc]initWithImage:data.yharr[0].tag title:data.yharr[0].title];
        [self.contentView addSubview:item_1];
        [item_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imgIV.mas_right).offset(10 *ScreenRatio_6);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5 *ScreenRatio_6);
        }];
        RecommendDiscountItemView *item_2 = [[RecommendDiscountItemView alloc]initWithImage:data.yharr[1].tag title:data.yharr[1].title];
        [self.contentView addSubview:item_2];
        [item_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.mas_equalTo(item_1);
            make.top.mas_equalTo(item_1.mas_bottom).offset(5 *ScreenRatio_6);
        }];
        RecommendDiscountItemView *item_3 = [[RecommendDiscountItemView alloc]initWithImage:data.yharr[2].tag title:data.yharr[2].title];
        [self.contentView addSubview:item_3];
        [item_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.mas_equalTo(item_1);
            make.top.mas_equalTo(item_2.mas_bottom).offset(5 *ScreenRatio_6);
        }];
    }
 
}

- (void)makeConstraints{
    [self.imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150 *ScreenRatio_6, 105 *ScreenRatio_6));
        make.left.mas_equalTo(self.contentView).offset(10 *ScreenRatio_6);
        make.top.mas_equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgIV.mas_right).offset(10 *ScreenRatio_6);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
        make.top.mas_equalTo(self.contentView);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5 *ScreenRatio_6);
        make.left.mas_equalTo(self.imgIV.mas_right).offset(10 *ScreenRatio_6);
    }];
    [self.rawpriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.priceLabel);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
        make.left.mas_equalTo(self.priceLabel.mas_right).offset(5);
    }];
    [self.viewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self.imgIV).offset(-10 *ScreenRatio_6);
    }];
    [self.viewsIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 9));
        make.right.mas_equalTo(self.viewsLabel.mas_left).offset(-2);
        make.centerY.mas_equalTo(self.viewsLabel);
    }];

}

#pragma mark - get
- (UIImageView *)imgIV{
    if (!_imgIV) {
        _imgIV = [UIImageView new];

    }
    return _imgIV;
}
- (UIImageView *)viewsIV{
    if (!_viewsIV) {
        _viewsIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"预览b"]];
    }
    return _viewsIV;
}
- (UILabel *)viewsLabel{
    if (!_viewsLabel) {
        _viewsLabel = [UILabel new];
        _viewsLabel.font = [UIFont systemFontOfSize:10 *ScreenRatio_6];
        _viewsLabel.textColor = UIColorHex(ffffff);
        _viewsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _viewsLabel;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15 *ScreenRatio_6 weight:UIFontWeightSemibold];
        _titleLabel.textColor = KMainTextColor_3;
        _titleLabel.numberOfLines = 3;
    }
    return _titleLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont systemFontOfSize:14 *ScreenRatio_6];
        _priceLabel.textColor = kMainTextColor_red;
    }
    return _priceLabel;
}
- (UILabel *)rawpriceLabel{
    if (!_rawpriceLabel) {
        _rawpriceLabel = [UILabel new];
        _rawpriceLabel.textColor = KMainTextColor_9;
    }
    return _rawpriceLabel;
}
- (UIView *)strikethroughLine{
    if (!_strikethroughLine) {
        _strikethroughLine = [UIView new];
        _strikethroughLine.backgroundColor = KMainTextColor_9;
    }
    return _strikethroughLine;
}
@end
