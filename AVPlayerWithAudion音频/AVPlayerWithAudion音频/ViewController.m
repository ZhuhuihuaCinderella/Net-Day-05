//
//  ViewController.m
//  AVPlayerWithAudion音频
//
//  Created by Qianfeng on 16/1/22.
//  Copyright © 2016年 王鹏宇. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (nonatomic, strong)AVPlayer * player;
@property (weak, nonatomic) IBOutlet UISlider *playSlider;
@property (nonatomic, strong) id periodicTimeObserve;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createPlayBtn];
    [self createStopBtn];
    [self createNextBtn];
    [self createLastBtn];
    [self createPlayer];
   [self.playSlider addTarget:self action:@selector(playSliderChange:) forControlEvents:UIControlEventValueChanged];
    self.playSlider.continuous = NO;
    [self.playSlider addTarget:self action:@selector(playSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
}
- (void)playSliderTouchDown:(UISlider *)sender {
    //当点击slider 的时候 移除时间观察者
    [self removePlayerTimeObserver];
}
- (void)playSliderChange:(UISlider *)sender {
    
    //CMTime
    //value 一共播放了多少帧
    // timescale 每秒几帧
//    _player seekToTime:<#(CMTime)#> completionHandler:<#^(BOOL finished)completionHandler#>
    
    //先暂停
    [_player pause];
    //获得总的时间
    CMTime totalTime = self.player.currentItem.duration;
    //将要寻找的时间 totalTime.value(总的帧数)*sender.value(百分比)
    
    CMTime seekTime = CMTimeMake(totalTime.value * sender.value, totalTime.timescale);
     [_player seekToTime:seekTime completionHandler:^(BOOL finished) {
         [_player play];
         [self addPlayerTimeObserver];
     }];
}
/**
 *  创建播放器
 */
- (void)createPlayer {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"亡灵序曲" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    //创建playItem
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    //创建播放器
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];

    
    //监听播放器的一个状态
    
    [_player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self addPlayerTimeObserver];
    
}
//添加 播放时间观察者
- (void)addPlayerTimeObserver {
    //添加观察者 interval 观察的时间间隔CMTime
    //dispatch_get_main_queue() 主线程
    //[NSOperationQueue mainQueue] 也可以找到主线程
    //UI必须要在线程里面刷新
    //block 块是在那个线程里面执行
    //block 变化的回调
    
    //如果不想block对一个对象强引用，就用weak 来修饰这个变量
    //声明一个弱应用指针
    __weak  ViewController *  WeakSelf = self;
    //（在block块里面直接使用self）这样会导致循环应用
    
    self.periodicTimeObserve =[_player addPeriodicTimeObserverForInterval:CMTimeMake(30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //首先要到 当前的进度
        //当前总的帧数/每秒的帧数 = 当前的秒数
        float currentSecond = self.player.currentTime.value * 1.0 /self.player.currentTime.timescale;
        float totalSecond = self.player.currentItem.duration.value * 1.0 / self.player.currentItem.duration.timescale;
        
        //进度
        float progress = currentSecond / totalSecond;
        //这样写可能导致循环引用(内存泄露)
        //self ->playSlider  ->block  ->self;
        [WeakSelf.playSlider setValue:progress animated:YES];
    }];
}
- (void)removePlayerTimeObserver {
    [_player removeTimeObserver:self.periodicTimeObserve];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"状态变化了");
    if (_player.status == AVPlayerStatusReadyToPlay){
        NSLog(@"准备播放");
    }
}
/**
 *  播放
 */
- (void)createPlayBtn {
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    playBtn.frame = CGRectMake(50, 260, 120, 40);
    playBtn.clipsToBounds = YES;
    playBtn.layer.cornerRadius = 10;
    playBtn.layer.borderColor = [UIColor grayColor].CGColor;
    playBtn.layer.borderWidth = 2.0;
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}
- (void)play {
    [self.player play];
}
/**
 *  暂停
 */
- (void)createStopBtn {
    UIButton *StopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    StopBtn.frame = CGRectMake(240, 260, 120, 40);
    StopBtn.clipsToBounds = YES;
    StopBtn.layer.cornerRadius = 10;
    StopBtn.layer.borderColor = [UIColor grayColor].CGColor;
    StopBtn.layer.borderWidth = 2.0;
    [StopBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [StopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:StopBtn];
}
- (void)stop {
    [_player pause];
}
/**
 *  上一曲
 */
- (void)createLastBtn {
    UIButton *LastBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    LastBtn.frame = CGRectMake(25, 330, 160, 40);
    LastBtn.clipsToBounds = YES;
    LastBtn.layer.cornerRadius = 10;
    LastBtn.layer.borderColor = [UIColor grayColor].CGColor;
    LastBtn.layer.borderWidth = 2.0;
    [LastBtn setTitle:@"上一曲" forState:UIControlStateNormal];
    [LastBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LastBtn];
}
/**
 *  下一曲
 */
- (void)createNextBtn {
    UIButton *NextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    NextBtn.frame = CGRectMake(225, 330, 160, 40);
    NextBtn.clipsToBounds = YES;
    NextBtn.layer.cornerRadius = 10;
    NextBtn.layer.borderColor = [UIColor grayColor].CGColor;
    NextBtn.layer.borderWidth = 2.0;
    [NextBtn setTitle:@"下一曲" forState:UIControlStateNormal];
    [NextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:NextBtn];
}
- (void)next {
    //创建下一曲的item
    NSURL *url = [NSURL URLWithString:@""];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
