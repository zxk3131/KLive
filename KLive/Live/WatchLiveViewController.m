//
//  WatchLiveViewController.m
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "WatchLiveViewController.h"
#import "BottomTollView.h"
#import "LiveEndView.h"
#import "MBProgressHUD+ZZ.h"
#import "UIImage+Extension.h"
#import "RequestTool.h"

#import "PerInfoView.h"

@interface WatchLiveViewController ()

/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;

/** 底部的工具栏 */
@property(nonatomic, weak) BottomTollView *bottomToolView;
/** 顶部主播相关视图 */
@property(nonatomic, weak) PerInfoView *perInfoView;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;
/** 直播结束的界面 */
@property (nonatomic, weak) LiveEndView *endView;
//@property (nonatomic, weak) XLUserInfoView *userinfoView;

@property (nonatomic, assign) BOOL hidden;

/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WatchLiveViewController

static NSString *reuserID = @"cell";

- (instancetype)init{
    if (self == [super init]) {
        self.bottomToolView.hidden = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (UIImageView *)placeHolderView
{
    if (_placeHolderView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.view.bounds;
        
        imageView.image = [UIImage imageNamed:@"profile_user_414x414"];
        
        [self.view addSubview:imageView];
//        [MBProgressHUD showMessage:@"加载中" toView:self.view];
        _placeHolderView = imageView;
        // 强制布局
        [_placeHolderView layoutIfNeeded];
    }
    return _placeHolderView;
}

- (BottomTollView *)bottomToolView
{
    if (_bottomToolView == nil) {
        
        BottomTollView *bottomToolView = [[BottomTollView alloc] init];
        
        __weak typeof(self) weakSekf = self;
        [bottomToolView setClickToolBlock:^(NSInteger tag) {
            
            switch (tag) {
                case 1:
                    [weakSekf quit];
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self.view insertSubview:bottomToolView aboveSubview:weakSekf.placeHolderView];
        
        [bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@-10);
            make.height.equalTo(@40);
        }];
        _bottomToolView = bottomToolView;
    }
    return _bottomToolView;
}

- (PerInfoView *)perInfoView
{
    if (_perInfoView == nil) {
        PerInfoView *perInfoView = [PerInfoView perInfoView];
        
        [self.view insertSubview:perInfoView aboveSubview:self.placeHolderView];
        [perInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
        }];
        _perInfoView = perInfoView;
    }
    return _perInfoView;
}

- (CAEmitterLayer *)emitterLayer
{
    
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(self.moviePlayer.view.frame.size.width-50,self.moviePlayer.view.frame.size.height-50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30_", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        }
        
        emitterLayer.emitterCells = array;
        [self.moviePlayer.view.layer addSublayer:emitterLayer];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}

- (LiveEndView *)endView
{
    __weak typeof(self) weakSelf = self;
    
    if (!_endView) {
        LiveEndView *endView = [LiveEndView liveEndView];
        endView.hotModel = self.hotModel;
        
        [self.view addSubview:endView];
        [endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [endView setQuitBlock:^{
            
            [weakSelf quit];
        }];
        _endView = endView;
    }
    return _endView;
}

- (void)setHotModel:(HotModel *)hotModel
{
    _hotModel = hotModel;
    self.perInfoView.hotModel = hotModel;
    
    
    [self plarFLV:hotModel.flv placeHolderUrl:hotModel.bigpic];
    
}

#pragma mark - private method


- (void)plarFLV:(NSString *)flv placeHolderUrl:(NSString *)placeHolderUrl
{
    
//    if (_moviePlayer) {
//        if (_moviePlayer) {
//            [self.view insertSubview:self.placeHolderView aboveSubview:self.moviePlayer.view];
//        }
//        
//        [_moviePlayer shutdown];
//        [_moviePlayer.view removeFromSuperview];
//        _moviePlayer = nil;
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//    }
//    
//    // 如果切换主播, 取消之前的动画
//    if (_emitterLayer) {
//        [_emitterLayer removeFromSuperlayer];
//        _emitterLayer = nil;
//    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placeHolderUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __weak typeof(self) weakSelf = self;
            
            if(image){
                weakSelf.placeHolderView.image = [UIImage blurImage:image blur:0.8];
            }
        });
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    //开启硬解码
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:flv withOptions:options];
    moviePlayer.view.frame = self.view.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
    moviePlayer.shouldAutoplay = NO;
    
    [self.view insertSubview:moviePlayer.view atIndex:0];
    
    [moviePlayer prepareToPlay];
    
    self.moviePlayer = moviePlayer;
    
    // 设置监听
    [self initObserver];
    
    
    // 开始来访动画
    [self.emitterLayer setHidden:NO];
}


- (void)initObserver
{
    [self.moviePlayer play];
    
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    //状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
}

#pragma mark - notify method

- (void)stateDidChange
{
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        
        if (!self.moviePlayer.isPlaying) {
            
            [self.moviePlayer play];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                
                if (weakSelf.placeHolderView) {
                    [weakSelf.placeHolderView removeFromSuperview];
                    weakSelf.placeHolderView = nil;
                }
            });
        }
    }else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
    }
}

- (void)didFinish
{
    // 因为网速或者其他原因导致直播stop了, 也要显示GIF
//    if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled && !self.gifView) {
//        [MBProgressHUD showMessage:@"加载中..." toView:self.moviePlayer.view];
//        return;
//    }
    
    
    //    方法：
    //      1、重新获取直播地址，服务端控制是否有地址返回。
    //      2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    __weak typeof(self)weakSelf = self;
    
    [RequestTool getLiveURL:self.hotModel.flv completionDataBlock:^(id resule, NSError *error) {
        if (error) {
            [weakSelf.moviePlayer shutdown];
            [weakSelf.moviePlayer.view removeFromSuperview];
            weakSelf.moviePlayer = nil;
            weakSelf.endView.hidden = NO;

        }
    }];
    
}

/*
 * 退出直播间
 */
- (void)quit
{
    
    if (_bottomToolView){
        
        [_bottomToolView removeFromSuperview];
        _bottomToolView = nil;
    }
    
    if (_perInfoView) {
        
        [_perInfoView removeFromSuperview];
        _perInfoView = nil;
    }
    
    if (_moviePlayer) {
        
        [self.moviePlayer pause];
        [self.moviePlayer stop];
        [self.moviePlayer shutdown];
        [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.view removeFromSuperview];
        self.view = nil;
    }];
}

@end
