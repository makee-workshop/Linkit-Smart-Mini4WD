//
//  ViewController.m
//  mini4wdUsingGPchip
//
//  Created by ArcherHuang on 2015/12/13.
//  Copyright © 2015年 Makee.io All rights reserved.
//
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
static NSString *postEngine = @"/api/v1.0/enginestatus/";

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

- (IBAction)turnOn:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", serverIP, serverPort, postEngine];
    NSDictionary *parameters = @{@"enginestatus":@"True"};
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@/?action=stream", serverIP, videoPort];
    NSURL *urlvideo = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlvideo];
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:requestObj];
    
    [[API sharedInstance] setEngine:url params:parameters completion:^(id response) {
        [self.turnOnButton setEnabled:NO];
    } error:^(NSError *err) {
        NSLog(@"error: %@", err);
    }];
}

@end
