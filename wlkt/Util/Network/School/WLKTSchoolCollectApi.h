//
//  WLKTSchoolCollectApi.h
//  wlkt
//
//  Created by nanbojiaoyu on 2017/11/29.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "YTKRequest.h"

@interface WLKTSchoolCollectApi : YTKRequest
- (instancetype)initWithSchoolId:(NSString *)suid;
@end
