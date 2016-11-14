//
//  ChatMessageAnalyzerImpl.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/9/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import "ChatMessageAnalyzerImpl.h"
#import "NSObject+SBJson.h"
#import "URLAnalyzer.h"
#import "EmoctionsAnalyzer.h"
#import "MentionsAnalyzer.h"

@interface ChatMessageAnalyzerImpl ()



@end

@implementation ChatMessageAnalyzerImpl
@synthesize analysisModules;
@synthesize analysisDelegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.analysisModules = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (instancetype)initWithModuleKeys:(NSArray *) moduleKeys
{
    self = [super init];
    if (self) {
        
        self.analysisModules = [[NSMutableArray alloc] initWithCapacity:moduleKeys.count];
        
        for (NSString *moduleKey in moduleKeys) {
            
            if ([moduleKey isEqualToString:kHipChatAnalysisItemKey_Mentions]) {
                
                [self.analysisModules addObject:[[MentionsAnalyzer alloc] init]];
                
            }else if ([moduleKey isEqualToString:kHipChatAnalysisItemKey_Emoctions]){
                
                [self.analysisModules addObject:[[EmoctionsAnalyzer alloc] init]];
                
            }else if ([moduleKey isEqualToString:kHipChatAnalysisItemKey_Links]){
                
                [self.analysisModules addObject:[[URLAnalyzer alloc] init]];
                
            }else{
                //HandleUnknown types
            }
            
        }
        
    }
    return self;
}

#pragma mark - 
#pragma mark ChatMessageAnalyzer methods
- (void) analyzeChatMessage:(NSString *)message withDelegate:(id<ChatMessageAnalyzerDelegate>)delegate concurrently:(BOOL)concurrently{
    
    self.analysisDelegate = delegate;
    self.finishedAnalysisStages = 0;
    
    
    
    for (id<AnalyzingStrategy> aStrategy in self.analysisModules) {
        
        if (concurrently) {
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [queue addOperationWithBlock:^{
                
                __weak typeof(self) weakSelf = self;

                if (weakSelf) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    
                    [aStrategy analyzeString:message andNotifyDelegate:strongSelf];
                    
                }
                
            }];
        }else{
            [aStrategy analyzeString:message andNotifyDelegate:self];
        }
        
    }
    
}

- (void) analyzeChatMessage:(NSString *)message withDelegate:(id<ChatMessageAnalyzerDelegate>)delegate{
    [self analyzeChatMessage:message withDelegate:delegate concurrently:YES];
}

#pragma mark - 
#pragma mark AnalyzingStrategyDelegate methods

- (void) analyzingStrategy:(id<AnalyzingStrategy>)strategy didFinishAnalysisWithResult:(NSDictionary *)result{
    
    self.finishedAnalysisStages = self.finishedAnalysisStages + 1;
    
    if (self.finishedAnalysisStages == self.analysisModules.count) {
        
        NSMutableDictionary *allResults = [[NSMutableDictionary alloc] initWithCapacity:self.analysisModules.count];
        
        for (id<AnalyzingStrategy> aStrategy in self.analysisModules) {
            
            if ([aStrategy analysisResult]) {
                
                [allResults addEntriesFromDictionary:[aStrategy analysisResult]];
                
            }
            
        }
        
        if (self.analysisDelegate) {
            
            if ([self.analysisDelegate respondsToSelector:@selector(chatMessageAnalyzer:didFinishWithResult:)]) {
                
                [self.analysisDelegate chatMessageAnalyzer:self didFinishWithResult:[allResults JSONRepresentation]];
                
            }
            
        }
        
    }else{
        
        if (self.analysisDelegate) {
            
            if ([self.analysisDelegate respondsToSelector:@selector(chatMessageAnalyzer:didFinishedAnalyzingStage:)]) {
                
                [self.analysisDelegate chatMessageAnalyzer:self didFinishedAnalyzingStage:self.finishedAnalysisStages];
                
            }
            
        }
    }
    
}

#pragma mark

@end
