//
//  ViewController.m
//  系统视频播放
//
//  Created by Qianfeng on 16/1/22.
//  Copyright © 2016年 王鹏宇. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()
{
     MPMoviePlayerController *_mp;
    //第三方比较出名的视频 解码
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createMP];
}
- (void)createMP {
    
    NSURL *url = [NSURL URLWithString:@"http://jameswatt.local/MovieTest.mp4"];

    _mp = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    //mp 是系统创建的直接添加到self.view 上
    [self.view addSubview:_mp.view];
    
    //设置
    _mp.view.frame = CGRectMake(0, 0, 400, 200);
    //播放
    [_mp play];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
