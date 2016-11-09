//
//  URLAnalyzer.h
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/7/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyzingStrategy.h"

@interface URLAnalyzer : NSObject<AnalyzingStrategy>

@property (nonatomic, assign) BOOL offlineMode;
@end
