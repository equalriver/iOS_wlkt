//
//  WLKTNewsDetailCommentCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/26.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTNewsDetailCommentCell.h"

@interface WLKTNewsDetailCommentCell ()
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *reportButton;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *reUsernameLabel;
@property (strong, nonatomic) UILabel *reDetailLabel;
@property (strong, nonatomic) UIButton *reReplyButton;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) WLKTNewsDetailReplyList *data;
@end

@implementation WLKTNewsDetailCommentCell
- (instancetype)initWithSingleState:(BOOL)isSingle
{
    self = [super init];
    if (self) {
        if (isSingle) {
            [self.contentView addSubview:self.usernameLabel];
            [self.contentView addSubview:self.detailLabel];
            [self.contentView addSubview:self.likeButton];
            [self.contentView addSubview:self.reportButton];
            [self.contentView addSubview:self.replyButton];
            [self.contentView addSubview:self.separatorView];
            [self makeSingleConstraints];
        }
        else{
            [self.contentView addSubview:self.usernameLabel];
            [self.contentView addSubview:self.detailLabel];
            [self.contentView addSubview:self.likeButton];
            [self.contentView addSubview:self.reportButton];
            [self.contentView addSubview:self.replyButton];
//            [self.contentView addSubview:self.separatorView];
            [self.contentView addSubview:self.bgView];
            [self.bgView addSubview:self.reUsernameLabel];
            [self.bgView addSubview:self.reDetailLabel];
            [self.bgView addSubview:self.reReplyButton];
            [self makeConstraints];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.likeButton];
        [self.contentView addSubview:self.reportButton];
        [self.contentView addSubview:self.replyButton];
        [self.contentView addSubview:self.separatorView];
        [self makeSingleConstraints];
    }
    return self;
}

- (void)setCellData:(WLKTNewsDetailReplyList *)data indexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    _data = data;
    self.usernameLabel.text = [NSString stringWithFormat:@"%@(用户名) %@", data.username, data.displaytime];
    self.detailLabel.text = data.content;
    if (data.replycount.integerValue >= 1) {
        self.reUsernameLabel.text = [NSString stringWithFormat:@"%@(用户名) %@", data.reply.username, data.reply.displaytime];
        self.reDetailLabel.text = data.reply.content;
    }
    if (data.replycount.integerValue > 1) {
        [self.reReplyButton setTitle:[NSString stringWithFormat:@"查看全部%@条回复", data.replycount] forState:UIControlStateNormal];
    }
    [_likeButton setTitle:[NSString stringWithFormat:@" 赞 %@", data.love_num] forState:UIControlStateNormal];
    if ([data.iszan isEqualToString:@"1"]) {
        self.likeButton.selected = YES;
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.usernameLabel.text = nil;
    self.detailLabel.text = nil;
    self.likeButton.selected = false;
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    [self.reReplyButton setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark - action
- (void)reReplyButtonAct:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didClickViewAllReplyButtonWithIndexPath:)]) {
        [self.delegate didClickViewAllReplyButtonWithIndexPath:self.indexPath];
    }
}

- (void)NewsDetailCommentAct:(UIButton *)sender{
    if ([self.data.iszan isEqualToString:@"1"] && sender.tag == NewsDetailCommentLike) {
        [SVProgressHUD showInfoWithStatus:@"已经赞过了"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedNewsDetailCommentButtonByType:button:indexPath:)]) {
        [self.delegate didSelectedNewsDetailCommentButtonByType:sender.tag button:sender indexPath:self.indexPath];
    }
}

#pragma mark -
- (void)makeConstraints{
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(15 * ScreenRatio_6);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(15 * ScreenRatio_6);
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * ScreenRatio_6);
    }];
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.replyButton);
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.reportButton.mas_left).offset(-25 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.replyButton);
    }];
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(15 * ScreenRatio_6);
    }];
//    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
//        make.top.left.mas_equalTo(self.contentView);
//    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth - 20);
        make.top.mas_equalTo(self.replyButton.mas_bottom).offset(10 * ScreenRatio_6);
        make.centerX.bottom.mas_equalTo(self.contentView);
    }];
    [self.reUsernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.bgView).offset(10 * ScreenRatio_6);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-5);
    }];
    [self.reDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.reUsernameLabel);
        make.top.mas_equalTo(self.reUsernameLabel.mas_bottom).offset(5);
    }];
    [self.reReplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reUsernameLabel);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
}

- (void)makeSingleConstraints{
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(15 * ScreenRatio_6);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(15 * ScreenRatio_6);
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * ScreenRatio_6);
    }];
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.replyButton);
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.reportButton.mas_left).offset(-25 * ScreenRatio_6);
        make.centerY.mas_equalTo(self.replyButton);
    }];
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.left.mas_equalTo(self.contentView).offset(10 * ScreenRatio_6);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(15 * ScreenRatio_6);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
        make.top.left.mas_equalTo(self.contentView);
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
- (UIButton *)likeButton{
    if (!_likeButton) {
        _likeButton = [UIButton new];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        [_likeButton setImage:[UIImage imageNamed:@"点赞hui"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateSelected];
        [_likeButton setTitle:@" 赞" forState:UIControlStateNormal];
        [_likeButton setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
        [_likeButton setTitleColor:UIColorHex(33c4da) forState:UIControlStateSelected];
        _likeButton.tag = NewsDetailCommentLike;
        [_likeButton addTarget:self action:@selector(NewsDetailCommentAct:) forControlEvents:UIControlEventTouchUpInside];
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
        _reportButton.tag = NewsDetailCommentReport;
        [_reportButton addTarget:self action:@selector(NewsDetailCommentAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}
- (UIButton *)replyButton{
    if (!_replyButton) {
        _replyButton = [UIButton new];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButton setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
        _replyButton.tag = NewsDetailCommentReply;
        _replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        [_replyButton addTarget:self action:@selector(NewsDetailCommentAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyButton;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = separatorView_color;
    }
    return _separatorView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = fillViewColor;
    }
    return _bgView;
}
- (UILabel *)reUsernameLabel{
    if (!_reUsernameLabel) {
        _reUsernameLabel = [UILabel new];
        _reUsernameLabel.font = [UIFont systemFontOfSize:14 * ScreenRatio_6];
        _reUsernameLabel.textColor = KMainTextColor_3;
    }
    return _reUsernameLabel;
}
- (UILabel *)reDetailLabel{
    if (!_reDetailLabel) {
        _reDetailLabel = [UILabel new];
        _reDetailLabel.font = [UIFont systemFontOfSize:13 * ScreenRatio_6];
        _reDetailLabel.textColor = KMainTextColor_3;
        _reDetailLabel.numberOfLines = 0;
    }
    return _reDetailLabel;
}
- (UIButton *)reReplyButton{
    if (!_reReplyButton) {
        _reReplyButton = [UIButton new];
        [_reReplyButton setTitleColor:UIColorHex(33c4da) forState:UIControlStateNormal];
        _reReplyButton.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
        [_reReplyButton addTarget:self action:@selector(reReplyButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reReplyButton;
}
@end

