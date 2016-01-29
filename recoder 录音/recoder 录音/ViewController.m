//
//  ViewController.m
//  recoder 录音
//
//  Created by Qianfeng on 16/1/22.
//  Copyright © 2016年 王鹏宇. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AVAudioRecorderDelegate>
@property (nonatomic, strong)AVAudioRecorder *recoder;
@property (nonatomic, strong)AVPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createRecoder];
}
- (void)createRecoder {
    // 对我们的avaudioSession(录音回话) 进行一下设置 （非必须）
    NSString *error = [NSString new];
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    NSLog(@"%@",error);
    //录音的时候需要一个存储路径
    //存到沙盒中
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
    NSString *recoderPath = [libPath stringByAppendingPathComponent:@"record.aac"];
    NSURL *url = [NSURL fileURLWithPath:recoderPath];
    
    //2. 第二个参数是个字典
    NSDictionary *setting = @{//设置格式
                              AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                              //设置比特率
                              AVSampleRateKey:@(44100),
                              //声道
                              AVNumberOfChannelsKey:@(2)
                              };
    //实例化一个录音AVAudioRecorder的时候，URL 是必须的,setting 可以为空， 如果URL指定的地方已经存在一个文件了， 录音之后就会被覆盖
    _recoder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
    _recoder.delegate = self;
}
- (IBAction)recoder:(UIButton *)sender {
    //开始录音
    if ([_recoder record]) {
        NSLog(@"开始录音");
    }else {
        NSLog(@"开始录音失败");
    }
    
}
- (IBAction)play:(UIButton *)sender {
    _player = [[AVPlayer alloc] initWithURL:_recoder.url];
    [_player play];
}

- (IBAction)pause:(UIButton *)sender {
    //暂停录音
    [_recoder pause];
}
- (IBAction)stop:(UIButton *)sender {
    //停止录音
    [_recoder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"录音结束");
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"编码出错");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
