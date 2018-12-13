//
//  WLKTSchoolNewsDetailCommentCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/11/23.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTSchoolNewsDetailCommentCell.h"

@interface WLKTSchoolNewsDetailCommentCell ()
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *reportButton;
@property (strong, nonatomic) UIView *separatorView;

@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation WLKTSchoolNewsDetailCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.likeButton];
        [self.contentView addSubview:self.reportButton];
        [self.contentView addSubview:self.separatorView];
        [self makeConstraints];
    }
    return self;
}

- (void)setCellData:(WLKTSchoolNewsDetailComment *)data indexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.usernameLabel.text = data.username;
    self.detailLabel.text = data.content;
    [_likeButton setTitle:[NSString stringWithFormat:@" 赞 %@", data.love_num] forState:UIControlStateNormal];
    self.timeLabel.text = data.create_time;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.usernameLabel.text = nil;
    self.detailLabel.text = nil;
    self.timeLabel.text = nil;
    self.likeButton.selected = false;
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)SchoolNewsDetailCommentAct:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectedSchoolNewsDetailCommentButtonByType:button:indexPath:)]) {
        [self.delegate didSelectedSchoolNewsDetailCommentButtonByType:sender.tag button:sender indexPath:self.indexPath];
    }
}

- (void)makeConstraints{
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(15 * ScreenRatio_6);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(15 * ScreenRatio_6);
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(15 * ScreenRatio_6);
    }];
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.timeLabel);
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.reportButton.mas_left).offset(-25 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.timeLabel);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
        make.left.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark - get
- (UILabel *)usernameLabel{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.font = [UIFont systemFontOfSize:14 * ScreenRatio_6];
        _usernameLabel.textColor = KMainTextColor_3;
    }
    return _usernameLabel;
}
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:13 * ScreenRatio_6];
        _detailLabel.textColor = KMainTextColor_3;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        _timeLabel.textColor = KMainTextColor_9;
    }
    return _timeLabel;
}
- (UIButton *)likeButton{
    if (!_likeButton) {
        _likeButton = [UIButton new];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        [_likeButton setImage:[UIImage imageNamed:@"点赞hui"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateSelected];
        [_likeButton setTitle:@" 赞" forState:UIControlStateNormal];
        [_likeButton setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
        [_likeButton setTitleColor:UIColorHex(33c4da) forState:UIControlStateSelected];
        _likeButton.tag = SchoolNewsDetailCommentLike;
        [_likeButton addTarget:self action:@selector(SchoolNewsDetailCommentAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}
- (UIButton *)reportButton{
    if (!_reportButton) {
        _reportButton = [UIButton new];
        _reportButton.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        [_reportButton setImage:[UIImage imageNamed:@"举报"] forState:UIControlStateNormal];
        [_reportButton setTitle:@" 举报" forState:UIControlStateNormal];
        [_reportButton setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
        _reportButton.tag = SchoolNewsDetailCommentReport;
        [_reportButton addTarget:self action:@selector(SchoolNewsDetailCommentAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = separatorView_color;
    }
    return _separatorView;
}
@end
