//
//  PlayerViewController.m
//  demo-ios
//
//  Created by finger on 2017/3/15.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "PlayerViewController.h"
#import "KKAVPlayer.h"

@interface PlayerViewController ()
@property(weak,nonatomic)IBOutlet UILabel *stateLabel;
@property(weak,nonatomic)IBOutlet UISlider *progressSilder;
@property(weak,nonatomic)IBOutlet UILabel *currentTimeLabel;
@property(weak,nonatomic)IBOutlet UILabel *totalTimeLabel;
@property(nonatomic,assign)BOOL seeking;
@end

@implementation PlayerViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    __weak typeof(self)weakSelf = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"i-see-fire" ofType:@"mp4"];
    [[KKAVPlayer sharedInstance]initPlayInfoWithUrl:filePath
                                          mediaType:KKMediaTypeVideo
                                        networkType:KKNetworkTypeLocal
                                            process:^(KKAVPlayer *player, float progress)
    {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf.seeking) {
            strongSelf.progressSilder.value = progress;
        }
        strongSelf.currentTimeLabel.text = [strongSelf timeStringFromSeconds:player.currentPlayTime];
    } compelete:^(KKAVPlayer *player) {
        NSLog(@"compelete");
    } loadStatus:^(KKAVPlayer *player, AVPlayerStatus status) {
        NSLog(@"AVPlayerStatus status:%ld",status);
        if(status == AVPlayerStatusFailed){
            [player releasePlayer];
        }else if(status == AVPlayerStatusReadyToPlay){
            __strong typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.totalTimeLabel.text = [strongSelf timeStringFromSeconds:player.totalTime];
        }
    } bufferPercent:^(KKAVPlayer *player, float bufferPercent) {
        
    } willSeekToPosition:^(KKAVPlayer *player, CGFloat curtPos, CGFloat toPos) {
        [player pause];
    } seekComplete:^(KKAVPlayer *player, CGFloat prePos, CGFloat curtPos) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf setSeeking:NO];
        [player play];
    } buffering:^(KKAVPlayer *player) {
        [player pause];
    } bufferFinish:^(KKAVPlayer *player) {
        [player play];
    } error:^(KKAVPlayer *player, NSError *error) {
        [player releasePlayer];
    }];
    [self.view.layer addSublayer:[KKAVPlayer sharedInstance].playerLayer];
    [[KKAVPlayer sharedInstance]play];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [KKAVPlayer sharedInstance].playerLayer.frame = self.view.bounds;
}

- (IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)play:(id)sender{
    [[KKAVPlayer sharedInstance]play];
}

- (IBAction)pause:(id)sender{
    [[KKAVPlayer sharedInstance] pause];
}

- (IBAction)progressTouchDown:(id)sender{
    self.seeking = YES;
}

- (IBAction)progressTouchUp:(id)sender{
    [KKAVPlayer sharedInstance].seekToPosition = self.progressSilder.value;
}

- (NSString *)timeStringFromSeconds:(CGFloat)seconds{
    return [NSString stringWithFormat:@"%ld:%.2ld", (long)seconds / 60, (long)seconds % 60];
}

- (void)dealloc{
    NSLog(@"%@ dealloc-----",NSStringFromClass([self class]));
    [[KKAVPlayer sharedInstance]releasePlayer];
}

@end
