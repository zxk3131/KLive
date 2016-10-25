//
//  StartLiveViewController.m
//  KLive
//
//  Created by zxk on 16/06/26.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "StartLiveViewController.h"
#import <LFLiveKit/LFLiveKit.h>
#import "UIDevice+Extension.h"
#import "MBProgressHUD+ZZ.h"

@interface StartLiveViewController ()<LFLiveSessionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *beautiful;

@property (weak, nonatomic) IBOutlet UIButton *livingBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

/** RTMP地址 */
@property(nonatomic,copy)NSString * rtmpURL;
@property(nonatomic,strong)LFLiveSession * session;
@property(nonatomic,weak)UIView * livingPreView;

@end

@implementation StartLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupControl];
}

- (void)setupControl{
    
    self.beautiful.layer.cornerRadius = 15;
    self.beautiful.layer.masksToBounds = YES;
    
    self.livingBtn.backgroundColor = KBasicColor;
    self.livingBtn.layer.cornerRadius = 20;
    self.livingBtn.layer.masksToBounds = YES;
    
    self.statusLabel.numberOfLines = 0;
    
    // 默认开启前置摄像头
    self.session.captureDevicePosition = AVCaptureDevicePositionFront;
}

- (BOOL)permission{
    // 判断是否是模拟器
    if ([[UIDevice deviceVersion] isEqualToString:@"iPhone Simulator"]) {
        
        [MBProgressHUD showMessage:@"请用真机进行测试, 此模块不支持模拟器测试"];
        
        return NO;
    }
    
    // 判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        [MBProgressHUD showMessage:@"您的设备没有摄像头或者相关的驱动, 不能进行直播"];
        return NO;
    }
    
    // 判断是否有摄像头权限
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        
        [MBProgressHUD showMessage:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
        
        return NO;
    }
    
    // 开启麦克风权限
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                return YES;
            }
            else {
                [MBProgressHUD showMessage:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                return NO;
            }
        }];
    }
    
    return YES;
}

- (IBAction)beautifulBtn:(UIButton *)sender {
    if (![self permission]) {
        return;
    }
    sender.selected = !sender.selected;
    self.session.beautyFace = !self.session.beautyFace;
}

- (IBAction)switchBtn:(UIButton *)sender {
    if (![self permission]) return;
    
    sender.selected = !sender.selected;
    
    if (sender.selected){
        
        self.session.captureDevicePosition = AVCaptureDevicePositionBack;
    }else{
        
        self.session.captureDevicePosition = AVCaptureDevicePositionFront;
    }
}

- (IBAction)close:(UIButton *)sender {
    if (self.session.state == LFLivePending || self.session.state == LFLiveStart){
        [self.session stopLive];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)beginLive:(id)sender {
    if (![self permission]) return;
    
    self.livingBtn.selected = !self.livingBtn.selected;
    if (self.livingBtn.selected) { // 开始直播
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        // 如果是跟我blog教程搭建的本地服务器, 记得填写你电脑的IP地址
        stream.url = @"rtmp://192.168.1.108:1935/rtmplive/room";
        self.rtmpURL = stream.url;
        [self.session startLive:stream];
    }else{ // 结束直播
        [self.session stopLive];
        self.statusLabel.text = [NSString stringWithFormat:@"状态: 直播被关闭\nRTMP: %@", self.rtmpURL];
    }
}

#pragma mark - LFLiveSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"状态: %@\nRTMP: %@", tempStatus, self.rtmpURL];
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}

#pragma mark - setter getter
- (UIView *)livingPreView{
    if (!_livingPreView) {
        UIView *livingPreView = [[UIView alloc] initWithFrame:self.view.bounds];
        livingPreView.backgroundColor = [UIColor clearColor];
        //livingPreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:livingPreView atIndex:0];
        _livingPreView = livingPreView;
    }
    return _livingPreView;
}

- (LFLiveSession *)session{
    if (_session == nil) {
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
//                                                         captureType:LFLiveCaptureMaskAll];
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingPreView;
    }
    return _session;
}

@end
