//
//  ViewController.m
//  AvPlayer-视频
//
//  Created by Qianfeng on 16/1/22.
//  Copyright © 2016年 王鹏宇. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)AVPlayerLayer * playerLayer;
@property (weak, nonatomic) IBOutlet UISlider *progress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createAVPlayer];
}
- (void)createAVPlayer {
    
   // NSString *path = [[NSBundle mainBundle]pathForResource:@"ThinkDiff" ofType:@"3gp"];
    //path 处理一下
  //  path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:@"http://jameswatt.local/MovieTest.mp4"];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    _player = [[AVPlayer alloc]initWithPlayerItem:item];
    
    //添加视屏界面
    //layer 只能添加到 layer 上
    AVPlayerLayer *videoLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    videoLayer.bounds = CGRectMake(0, 0, 400, 200);
    //设置锚点（类似于view的中心点）
    videoLayer.position = CGPointMake(210, 200);
    [self.view.layer addSublayer:videoLayer];
    self.playerLayer = videoLayer;
    //添加观察者
    [self addPlayerObeserve];
    
    //视屏模式
    videoLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//    AVLayerVideoGravityResize (填充整个layer，视屏会变形)
//    AVLayerVideoGravityResizeAspect (默认  不会发生变形)
//    AVLayerVideoGravityResizeAspectFill(按比例填充，不会有黑边)
}
- (void)addPlayerObeserve {
    //第一个参数 时间间隔
    //第二个参数 指定线程
    //第三个参数
    __weak ViewController * weakSelf = self;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float currenSecond = _player.currentTime.value * 1.0 / _player.currentTime.timescale;
        //总共的秒数 = 总共的帧数 / 每秒的帧数
        float totalSecond = _player.currentItem.duration.value * 1.0 / _player.currentItem.duration.timescale;
        float progress = currenSecond / totalSecond;
        //刷新UI
        [weakSelf.progress setValue:progress animated:YES];
    }];
}

- (IBAction)layerFlash:(id)sender {
    
    //[self testLayerAnimation1];
    [self testRatateAnimation2];
    
}
//边界动画 第三方库pop
- (void)testLayerAnimation1 {
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    //动画的开始值
    boundsAnimation.fromValue = [NSValue valueWithCGRect:_playerLayer.bounds];
    //动画的结束值
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 300, 100)];
    //设置动画的时间
    boundsAnimation.duration = 3.0;
    //是否重播
    boundsAnimation.autoreverses = YES;
    //重复次数 NSNotFound 无限次
    boundsAnimation.repeatCount = NSNotFound;
    //添加 layer 层 动画 (核心动画)
    [_playerLayer addAnimation:boundsAnimation forKey:nil];
    NSLog(@"ddd");
}
- (void)testRatateAnimation2 {
    //kvc 键值编码
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    rotateAnimation.duration = 3.0;
    [_playerLayer addAnimation:rotateAnimation forKey:nil];
}
- (IBAction)startPlayer:(id)sender {
    [_player play];
    NSLog(@"diao le");
}
- (IBAction)stopPlayer:(id)sender {
    //当按下 的时候就让视屏暂停
    [_player pause];
}
- (IBAction)last:(UIButton *)sender {
}
- (IBAction)next:(id)sender {
    NSString *nextpath = [[NSBundle mainBundle]pathForResource:@"ThinkDiff" ofType:@"3gp"];
    //path 处理一下
    NSURL *url = [NSURL fileURLWithPath:nextpath];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:item];
}
- (IBAction)sliderChanged:(UISlider *)sender {
    //当变化的时候 就让视屏进度变化
    //当前总的帧数/每秒的帧数 = 当前的秒数
    float currenSecond = _player.currentTime.value * 1.0 / _player.currentTime.timescale;
    //总共的秒数 = 总共的帧数 / 每秒的帧数
    float totalSecond = _player.currentItem.duration.value * 1.0 / _player.currentItem.duration.timescale;
    float progress = currenSecond / totalSecond;
    
    [_player seekToTime:CMTimeMake(_player.currentItem.duration.value * sender.value, _player.currentItem.duration.timescale) completionHandler:^(BOOL finished) {
        
    }];
    
}
- (IBAction)sliderTouchDown:(UISlider *)sender {
    [_player pause];
}
- (IBAction)sliderTouchUpInsider:(UISlider *)sender {
    [_player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
