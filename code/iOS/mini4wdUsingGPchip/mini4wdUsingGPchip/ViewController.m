//
//  ViewController.m
//  mini4wdUsingGPchip
//
//  Created by ArcherHuang on 2015/12/13.
//  Copyright © 2015年 Makee.io All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import <NMSSH/NMSSH.h>
#import "API.h"

@interface ViewController ()

@end

@implementation ViewController

static NSString *serverIP = @"http://192.168.100.1";
static NSString *serverPort = @":5000";
static NSString *getVideo = @"/api/v1.0/video/on";
static NSString *videoPort = @":8080";
static NSString *postPower = @"/api/v1.0/power/";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _webView.delegate = self;
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", serverIP, serverPort, getVideo];
    [[API sharedInstance] getVideo:url completion:^(id response) {

    } error:^(NSError *err) {
        NSLog(@"error: %@", err);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)powerBtnAction:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", serverIP, serverPort, postPower];
    if ([self.powerBtn.titleLabel.text isEqualToString:@"Power On"]) {
        NSString *fullURL = [NSString stringWithFormat:@"%@%@/?action=stream", serverIP, videoPort];
        NSURL *urlvideo = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlvideo];
        _webView.scalesPageToFit = YES;
        [_webView loadRequest:requestObj];
        NSDictionary *parameters = @{@"power":@"True"};
        [[API sharedInstance] setPower:url params:parameters completion:^(id response) {
            
        } error:^(NSError *err) {
            NSLog(@"error: %@", err);
        }];
        [self.powerBtn setTitle: @"Power Off" forState: UIControlStateNormal];
    }else if ([self.powerBtn.titleLabel.text isEqualToString:@"Power Off"]){
        NSDictionary *parameters = @{@"power":@"False"};
        [[API sharedInstance] setPower:url params:parameters completion:^(id response) {
            
        } error:^(NSError *err) {
            NSLog(@"error: %@", err);
        }];
        [self.powerBtn setTitle: @"Power On" forState: UIControlStateNormal];
    }
    
}

@end
