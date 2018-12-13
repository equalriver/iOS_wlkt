//
//  WLKTNewsVideoCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/25.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTNewsVideoCell.h"

@interface WLKTNewsVideoCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *classifyLabel;
@property (strong, nonatomic) UILabel *sourseLabel;
@property (strong, nonatomic) UIImageView *lookTimeIV;
@property (strong, nonatomic) UILabel *lookTimeLabel;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UIImageView *videoTagIV;
@property (strong, nonatomic) UIImageView *videoIV;

@end

@implementation WLKTNewsVideoCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.classifyLabel];
        [self.contentView addSubview:self.sourseLabel];
        [self.contentView addSubview:self.lookTimeIV];
        [self.contentView addSubview:self.lookTimeLabel];
        [self.contentView addSubview:self.separatorView];
        [self.contentView addSubview:self.videoIV];
        [self.contentView addSubview:self.videoTagIV];
        [self makeConstraints];
    }
    return self;
}

- (void)setCellData:(WLKTNewsNormalNewsList *)data videoTapHandle:(void(^)(void))videoTapHandle{
    self.titleLabel.text = data.title;
    self.classifyLabel.text = data.newstag;
    self.classifyLabel.textColor = [UIColor colorWithHexString:data.tagcolor];
    self.classifyLabel.layer.borderColor = [UIColor colorWithHexString:data.tagcolor].CGColor;
    [self.classifyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(data.newstag.length *15 *ScreenRatio_6, 15));
    }];
    
    self.sourseLabel.text = [NSString stringWithFormat:@"%@·%@", data.from, data.displaytime];
    self.lookTimeLabel.text = [NSString stringWithFormat:@"观看 %@", data.hits_num];
    [self.videoIV setImageURL:[NSURL URLWithString:data.thumb_image]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        videoTapHandle();
    }];
    [self.videoIV addGestureRecognizer:tap];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.titleLabel.text = nil;
    self.classifyLabel.text = nil;
    self.sourseLabel.text = nil;
    self.lookTimeLabel.text = nil;
    self.videoIV.image = nil;
}

- (void)makeConstraints{
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 20 *ScreenRatio_6, 180 *ScreenRatio_6));
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10*ScreenRatio_6);
    }];
    [self.videoTagIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.videoIV);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 *ScreenRatio_6);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 *ScreenRatio_6);
        make.top.mas_equalTo(self.videoIV.mas_bottom).offset(10 *ScreenRatio_6);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView);
    }];
    [self.classifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 *ScreenRatio_6);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10 *ScreenRatio_6);
        make.size.mas_equalTo(CGSizeMake(30, 15));
    }];
    [self.sourseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.classifyLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.classifyLabel);
    }];
    [self.lookTimeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sourseLabel.mas_right).offset(20 *ScreenRatio_6);
        make.centerY.mas_equalTo(self.classifyLabel);
    }];
    [self.lookTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lookTimeIV.mas_right).offset(5);
        make.centerY.mas_equalTo(self.classifyLabel);
    }];
}

#pragma mark - get
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17 *ScreenRatio_6 weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
- (UILabel *)classifyLabel{
    if (!_classifyLabel) {
        _classifyLabel = [UILabel new];
        _classifyLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _classifyLabel.layer.borderWidth = 0.5;
        _classifyLabel.layer.cornerRadius = 3 *ScreenRatio_6;
        _classifyLabel.layer.masksToBounds = YES;
        _classifyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _classifyLabel;
}
- (UILabel *)sourseLabel{
    if (!_sourseLabel) {
        _sourseLabel = [UILabel new];
        _sourseLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _sourseLabel.textColor = KMainTextColor_9;
    }
    return _sourseLabel;
    
}
- (UIImageView *)lookTimeIV{
    if (!_lookTimeIV) {
        _lookTimeIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"编辑"]];
    }
    return _lookTimeIV;
}
- (UILabel *)lookTimeLabel{
    if (!_lookTimeLabel) {
        _lookTimeLabel = [UILabel new];
        _lookTimeLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _lookTimeLabel.textColor = KMainTextColor_9;
    }
    return _lookTimeLabel;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = separatorView_color;
    }
    return _separatorView;
}
- (UIImageView *)videoTagIV{
    if (!_videoTagIV) {
        _videoTagIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新闻视频"]];
    }
    return _videoTagIV;
}
- (UIImageView *)videoIV{
    if (!_videoIV) {
        _videoIV = [UIImageView new];
        _videoIV.userInteractionEnabled = YES;
        _videoIV.layer.masksToBounds = YES;
    }
    return _videoIV;
}

@end
