//
//  ViewController.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/7/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import "ViewController.h"

#import "URLAnalyzer.h"

@interface ViewController ()<AnalyzingStrategyDelegate>
@property (nonatomic, strong) URLAnalyzer *urlAnalyzer;
@property (nonatomic, strong) NSDictionary *analysisResult;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
