//
//  ViewController.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/7/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import "ViewController.h"

#import "HipChatAnalyzer.h"

@interface ViewController ()<ChatMessageAnalyzerDelegate>

@property (nonatomic, strong) NSDictionary *analysisResult;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    HipChatAnalyzer *hipchatAnalyzer = [[HipChatAnalyzer alloc] init];
//    
//    [hipchatAnalyzer analyzeChatMessage:@"@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016" withDelegate:self];

}

- (void) chatMessageAnalyzer:(id<ChatMessageAnalyzer>)messageAnalyzer didFinishWithResult:(NSString *)jsonString{
    
    NSLog(@"chat message analyzer did finish with result %@",jsonString);
}

- (void) chatMessageAnalyzer:(id<ChatMessageAnalyzer>)messageAnalyzer didFinishedAnalyzingStage:(int)stage{
    
    NSLog(@"chat message analyzer did finish stage %d of %d",stage,(int)[messageAnalyzer analysisModules].count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
