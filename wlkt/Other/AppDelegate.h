//
//  AppDelegate.h
//  wlkt
//
//  Created by slovelys on 17/3/19.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLKTAppCoordinator.h"
#import <WeiboSDK.h>
#import <WXApi.h>
#import <XGPush.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate, WXApiDelegate, XGPushDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WLKTAppCoordinator *appCoordinator;
@property (copy, nonatomic) void (^backgroundSessionCompletionHandler)(void);
@property (copy, nonatomic) void (^weiboAuthoHandler)(NSDictionary *dic);
@end