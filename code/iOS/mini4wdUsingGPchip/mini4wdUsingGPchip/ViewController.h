//
//  ViewController.h
//  mini4wdUsingGPchip
//
//  Created by ArcherHuang on 2015/12/13.
//  Copyright © 2015年 Makee.io All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)turnOn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *turnOnButton;


@end

