//
//  ViewController.m
//  KKAVPlayer
//
//  Created by kkfinger on 2019/2/15.
//  Copyright © 2019 kkfinger. All rights reserved.
//

#import "ViewController.h"
#import "PlayerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *play = [UIButton new];
    [play setTitle:@"播放" forState:UIControlStateNormal];
    [play setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [play.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [play setFrame:CGRectMake(self.view.center.x-40, self.view.center.y-20, 80, 40)];
    [play addTarget:self action:@selector(playClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:play];
}

- (void)playClicked{
    PlayerViewController * obj = [[PlayerViewController alloc] init];
    [self.navigationController pushViewController:obj animated:YES];
}


@end
