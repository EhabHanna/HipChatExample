//
//  HipChatAnalyzer.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/9/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import "HipChatAnalyzer.h"

@implementation HipChatAnalyzer

- (instancetype)init
{
    self = [super initWithModuleKeys:@[kHipChatAnalysisItemKey_Mentions,kHipChatAnalysisItemKey_Emoctions,kHipChatAnalysisItemKey_Links]];
    if (self) {
        
    }
    return self;
}

@end
