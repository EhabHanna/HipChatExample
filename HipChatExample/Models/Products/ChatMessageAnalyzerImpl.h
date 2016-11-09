//
//  ChatMessageAnalyzerImpl.h
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/9/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageAnalyzer.h"

@interface ChatMessageAnalyzerImpl : NSObject<ChatMessageAnalyzer>

@property (nonatomic, assign) int finishedAnalysisStages;
- (instancetype)initWithModuleKeys:(NSArray *) moduleKeys;
@end
