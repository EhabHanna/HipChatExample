//
//  AnalyzingStrategy.h
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/7/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HipChatConstants.h"

@protocol AnalyzingStrategyDelegate;

@protocol AnalyzingStrategy <NSObject>

- (void) analyzeString:(NSString *) inputString andNotifyDelegate:(id<AnalyzingStrategyDelegate>) delegate;

@property (nonatomic, assign) id<AnalyzingStrategyDelegate> analysisDelegate;
@property (nonatomic, strong) NSMutableDictionary *analysisResult;
@end

@protocol AnalyzingStrategyDelegate <NSObject>

- (void) analyzingStrategy:(id<AnalyzingStrategy>) strategy didFinishAnalysisWithResult:(NSDictionary *) result;

@end
