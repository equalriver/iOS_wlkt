//
//  WLKTActivityDetailLocationCell.h
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/12.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLKTActivity.h"

@interface WLKTActivityDetailLocationCell : UITableViewCell
- (void)setCellData:(WLKTActivity *)data currentCoordinate:(CLLocationCoordinate2D)currentCoordinate;
@end
