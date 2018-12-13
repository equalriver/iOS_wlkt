//
//  WLKTSchoolVideoPlayVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/1/17.
//  Copyright © 2018年 neimbo. All rights reserved.
//
#import <AliyunVodPlayerViewSDK/AliyunVodPlayerViewSDK.h>
#import "WLKTSchoolVideoPlayVC.h"
#import "UIViewController+State.h"
#import "WLKTGetVideoTokenApi.h"
#import "WLKTGetVideoTokenData.h"
#import <sys/utsname.h>

@interface WLKTSchoolVideoPlayVC ()<AliyunVodPlayerViewDelegate>
@property (strong, nonatomic) AliyunVodPlayerView *playerView;
@property (copy, nonatomic) NSString *vid;
@property (nonatomic, assign) BOOL isLock;
@property (nonatomic,assign) BOOL isStatusHidden;
@end

#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

@implementation WLKTSchoolVideoPlayVC
- (instancetype)initWithVideoId:(NSString *)vid
{
    self = [super init];
    if (self) {
        _vid = vid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"视频";
    self.view.backgroundColor = [UIColor blackColor];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.playerView != nil) {
        [self.playerView stop];
        [self.playerView releasePlayer];
        [self.playerView removeFromSuperview];
        self.playerView = nil;
    }
}

- (void)setPlayerData:(WLKTGetVideoTokenData *)data{
    CGFloat width = 0;
    CGFloat height = 0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ) {
        width = ScreenWidth;
        height = ScreenHeight * 9 / 16.0;
    }else{
        width = ScreenHeight;
        height = ScreenHeight * 9 / 16.0;
    }
    self.playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,44, width, height) andSkin:AliyunVodPlayerViewSkinRed];
    //测试封面地址，请使用https 地址。
    //    self.playerView.coverUrl = [NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4046104436,1338839104&fm=27&gp=0.jpg"];
    self.playerView.isScreenLocked = NO;
    self.playerView.fixedPortrait = NO;
    self.isLock = self.playerView.isScreenLocked || self.playerView.fixedPortrait ? YES : NO;
//    [self.playerView setTitle:data.title];
    //    self.playerView.circlePlay = YES;
    [self.playerView setDelegate:self];
    [self.playerView setAutoPlay:YES];
    //边下边播缓存沙箱位置
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [pathArray objectAtIndex:0];
    //maxsize:单位 mb    maxDuration:单位秒 ,在prepare之前调用。
    [self.playerView setPlayingCache:YES saveDir:docDir maxSize:100 maxDuration:5000];
    
    //隐藏全屏显示按钮
//    if (self.playerView.subviews.count > 2) {
//        NSArray *arr = self.playerView.subviews[2].subviews;
//        for (UIView *v in arr) {
//            if (v.tag == 2) {
//                v.hidden = YES;
//            }
//        }
//    }
    //查看缓存文件时打开。
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerun) userInfo:nil repeats:YES];
    
    //播放器播放方式
    [self.playerView playViewPrepareWithVid:self.vid accessKeyId:data.AccessKeyId accessKeySecret:data.AccessKeySecret securityToken:data.SecurityToken];
    [self.view addSubview:self.playerView];
}

- (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform;
}
/*
//适配iphone x 界面问题，没有在 viewSafeAreaInsetsDidChange 这里做处理 ，主要 旋转监听在 它之后获取。
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSString *platform =  [self iphoneType];
    
    //iphone x
    if (![platform isEqualToString:@"iPhone10,3"] && ![platform isEqualToString:@"iPhone10,6"]) {
        return;
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    UIDevice *device = [UIDevice currentDevice] ;
    switch (device.orientation) {//device.orientation
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortraitUpsideDown:{
            if (self.isStatusHidden) {
                CGRect frame = self.playerView.frame;
                frame.origin.x = VIEWSAFEAREAINSETS(self.view).left;
                frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
                frame.size.width = ScreenWidth - VIEWSAFEAREAINSETS(self.view).left *2;
                frame.size.height = ScreenHeight - VIEWSAFEAREAINSETS(self.view).bottom - VIEWSAFEAREAINSETS(self.view).top;
                self.playerView.frame = frame;
            }else{
                CGRect frame = self.playerView.frame;
                frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
                //竖屏全屏时 isStatusHidden 来自是否 旋转回调。
                if (self.playerView.fixedPortrait && self.isStatusHidden) {
                    frame.size.height = ScreenHeight - VIEWSAFEAREAINSETS(self.view).top - VIEWSAFEAREAINSETS(self.view).bottom;
                }
                self.playerView.frame = frame;
            }
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            //
            CGRect frame = self.playerView.frame;
            frame.origin.x = VIEWSAFEAREAINSETS(self.view).left;
            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
            frame.size.width = ScreenWidth - VIEWSAFEAREAINSETS(self.view).left*2;
            frame.size.height = ScreenHeight - VIEWSAFEAREAINSETS(self.view).bottom;
            self.playerView.frame = frame;
        }
            
            break;
        case UIDeviceOrientationPortrait:
        {
            //
            CGRect frame = self.playerView.frame;
            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
            //竖屏全屏时 isStatusHidden 来自是否 旋转回调。
            if (self.playerView.fixedPortrait && self.isStatusHidden) {
                frame.size.height = ScreenHeight - VIEWSAFEAREAINSETS(self.view).top - VIEWSAFEAREAINSETS(self.view).bottom;
            }
            self.playerView.frame = frame;
            
        }
            break;
        default:
            
            break;
    }
    
#else
#endif
    NSLog(@"top----%f",self.playerView.frame.origin.y);
    
}
*/
- (void)loadData{
    self.state = WLKTViewStateLoading;
    WLKTGetVideoTokenApi *api = [[WLKTGetVideoTokenApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        self.state = WLKTViewStateNormal;
        WLKTGetVideoTokenData *data = [WLKTGetVideoTokenData modelWithJSON:request.responseJSONObject[@"Credentials"]];
        if (data) {
            [self setPlayerData:data];

        }
    } failure:^(__kindof YTKBaseRequest *request) {
        self.state = WLKTViewStateError;
        WS(weakSelf);
        self.loadingBlock = ^{
            [weakSelf loadData];
        };
    }];
}

- (void)monitoringNetworkForVideo:(void(^)(void))handle{
    if (![YYReachability reachability].reachable) {
        return;
    }
    if ([YYReachability reachability].status == YYReachabilityStatusWWAN) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"当前为移动网络，播放将产生流量费用！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *def = [UIAlertAction actionWithTitle:@"继续播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !handle ?: handle();
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:def];
        [ac addAction:cancel];
        [self presentViewController:ac animated:YES completion:nil];
    }
    else{
        !handle ?: handle();
    }
}

#pragma mark - AliyunVodPlayerViewDelegate
- (void)onBackViewClickWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    if (self.playerView != nil) {
        [self.playerView stop];
        [self.playerView releasePlayer];
        [self.playerView removeFromSuperview];
        self.playerView = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onPause:(NSTimeInterval)currentPlayTime{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onResume:(NSTimeInterval)currentPlayTime{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onStop:(NSTimeInterval)currentPlayTime{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onSeekDone:(NSTimeInterval)seekDoneTime{
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen{
    self.isLock = isLockScreen;
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onVideoQualityChanged:(AliyunVodPlayerVideoQuality)quality{
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);
    
    self.isStatusHidden = isFullScreen ;
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)onCircleStartWithVodPlayerView:(AliyunVodPlayerView *)playerView {
    
}


- (void)onFinishWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView {
    
}


#pragma mark - 锁屏功能
/**
 * 说明：播放器父类是UIView。
 屏幕锁屏方案需要用户根据实际情况，进行开发工作；
 如果viewcontroller在navigationcontroller中，需要添加子类重写navigationgController中的 以下方法，根据实际情况做判定 。
 */

- (BOOL)shouldAutorotate{
    return !self.isLock;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (self.isLock) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft |UIInterfaceOrientationMaskLandscapeRight;

    }
}

-(BOOL)prefersStatusBarHidden
{
    if (IsIphoneX) {
        return false;
    }
    return YES;
}

@end
