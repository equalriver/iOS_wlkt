//
//  WLKTSchoolCommentListApi.h
//  wlkt
//
//  Created by nanbojiaoyu on 2017/11/29.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "YTKRequest.h"

@interface WLKTSchoolCommentListApi : YTKRequest
- (instancetype)initWithNewsId:(NSString *)nid page:(NSInteger)page;
@end
