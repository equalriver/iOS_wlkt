//
//  XLTBaseTableViewCell.m
//  lsg
//
//  Created by 朱琨 on 16/5/20.
//  Copyright © 2016年 Talenton. All rights reserved.
//

#import "XLTBaseTableViewCell.h"

@implementation XLTBaseTableViewCell

- (void)setModel:(id)model {
    _model = model;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath model:(id)model {
    return [tableView fd_heightForCellWithIdentifier:[self identifier] cacheByIndexPath:indexPath configuration:^(XLTBaseTableViewCell *cell) {
        cell.model = model;
    }];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithModel:(id)model {
    return [tableView fd_heightForCellWithIdentifier:[self identifier] cacheByKey:[model valueForKey:[self cacheKey]] configuration:^(XLTBaseTableViewCell *cell) {
        cell.model = model;
    }];
}

+ (void)tableView:(UITableView *)tableView invalidateHeightAtIndexPath:(NSIndexPath *)indexPath {
    [tableView.fd_indexPathHeightCache invalidateHeightAtIndexPath:indexPath];
}

+ (void)tableView:(UITableView *)tableView invalidateHeightWithModel:(id)model {
    [tableView.fd_keyedHeightCache invalidateHeightForKey:[model valueForKey:[self cacheKey]]];
}

+ (void)invalidateAllHeightCacheOfTableView:(UITableView *)tableView {
    if ([self cacheKey]) {
       [tableView.fd_keyedHeightCache invalidateAllHeightCache];
    } else {
       [tableView.fd_indexPathHeightCache invalidateAllHeightCache]; 
    }
}

+ (NSString *)identifier {
    [NSException raise:NSInternalInconsistencyException format:@"You muse override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

+ (NSString *)cacheKey {
    [NSException raise:NSInternalInconsistencyException format:@"You muse override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

@end
