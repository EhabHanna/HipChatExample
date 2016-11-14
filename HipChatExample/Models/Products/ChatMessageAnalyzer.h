//
//  ChatMessageAnalyzer.h
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/9/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyzingStrategy.h"

@protocol ChatMessageAnalyzerDelegate;
@protocol ChatMessageAnalyzer <NSObject,AnalyzingStrategyDelegate>

@property (nonatomic, strong) NSMutableArray *analysisModules;
@property (nonatomic, assign) id<ChatMessageAnalyzerDelegate> analysisDelegate;

- (void) analyzeChatMessage:(NSString *) message withDelegate:(id<ChatMessageAnalyzerDelegate>) delegate concurrently:(BOOL) concurrently;
- (void) analyzeChatMessage:(NSString *) message withDelegate:(id<ChatMessageAnalyzerDelegate>) delegate;

@end


@protocol ChatMessageAnalyzerDelegate <NSObject>

- (void) chatMessageAnalyzer:(id<ChatMessageAnalyzer>) messageAnalyzer didFinishWithResult:(NSString *) jsonString;

@optional
- (void) chatMessageAnalyzer:(id<ChatMessageAnalyzer>)messageAnalyzer didFinishedAnalyzingStage:(int) stage;
@end
