//
//  MentionsAnalyzingStartegyTest.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/9/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MentionsAnalyzer.h"

@interface MentionsAnalyzingStartegyTest : XCTestCase<AnalyzingStrategyDelegate>

@property (nonatomic, strong) MentionsAnalyzer *mentionsAnalyzer;
@property (nonatomic, strong) NSDictionary *analysisResult;
@property (nonatomic, copy) void(^DelegateBlock)(NSDictionary *aResult);

@end

@implementation MentionsAnalyzingStartegyTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.mentionsAnalyzer = [[MentionsAnalyzer alloc] init];
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    [self.mentionsAnalyzer analyzeString:@ "@chris you around?" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        XCTAssert(YES, @"Pass");
    }];
    
    
}

- (void) testMultiple {
    // This is an example of a functional test case.
    [self.mentionsAnalyzer analyzeString:@ "@chris @john @kambell @jason you around?" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *mentions = [aResult objectForKey:kHipChatAnalysisItemKey_Mentions];
        
        XCTAssertEqual(mentions.count,4,@"should find Exactly 4 mentions");
    }];
    
    
    
}

- (void) testMultipleNoSpaces {
    // This is an example of a functional test case.
    [self.mentionsAnalyzer analyzeString:@ "@chris@john@kambell@jason you around?" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *mentions = [aResult objectForKey:kHipChatAnalysisItemKey_Mentions];
        
        XCTAssertEqual(mentions.count,4,@"should find Exactly 4 mentions");
    }];
    
    
    
}

- (void) testMultiplePunctuation {
    // This is an example of a functional test case.
    [self.mentionsAnalyzer analyzeString:@ "@chris,@john;@kambell-@jason you around?" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *mentions = [aResult objectForKey:kHipChatAnalysisItemKey_Mentions];
        
        XCTAssertEqual(mentions.count,4,@"should find Exactly 4 mentions");
    }];
    
    
    
}

- (void) testSparsed {
    // This is an example of a functional test case.
    [self.mentionsAnalyzer analyzeString:@ "@chris you around? I wanted to ask you about jason? @ramond do you know where he is?" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *mentions = [aResult objectForKey:kHipChatAnalysisItemKey_Mentions];
        
        XCTAssertEqual(mentions.count,2,@"should find Exactly 2 mentions");
    }];
    
   
    
}

- (void) testEmpty {
    // This is an example of a functional test case.
    [self.mentionsAnalyzer analyzeString:@ "@ you around? I wanted to ask you about jason" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *mentions = [aResult objectForKey:kHipChatAnalysisItemKey_Mentions];
        
        XCTAssertEqual(mentions.count,0,@"should find Exactly 0 mentions");
    }];
    
    
    
}

- (void) testMultipleEmpty {
    // This is an example of a functional test case.
    [self.mentionsAnalyzer analyzeString:@ "@@@@@@@ @@@@@@ you around?@@@@ I wanted to ask you about jason" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *mentions = [aResult objectForKey:kHipChatAnalysisItemKey_Mentions];
        
        XCTAssertEqual(mentions.count,0,@"should find Exactly 0 mentions");
    }];
    
    
    
}

- (void) testDoubleMentions {
    // This is an example of a functional test case.
    [self.mentionsAnalyzer analyzeString:@ "@@chris you around?I wanted to ask you about jason" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *mentions = [aResult objectForKey:kHipChatAnalysisItemKey_Mentions];
        
        XCTAssertEqual(mentions.count,1,@"should find Exactly 1 mentions");
    }];
    
   
    
}

- (void) testEmail {
    // This is an example of a functional test case.
    [self.mentionsAnalyzer analyzeString:@ "@@chris you around?I wanted to ask you about jason's email is it jason@gmail.com ?" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *mentions = [aResult objectForKey:kHipChatAnalysisItemKey_Mentions];
        
        XCTAssertEqual(mentions.count,1,@"should find Exactly 1 mentions");
    }];
    
    
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) analyzingStrategy:(id<AnalyzingStrategy>)strategy didFinishAnalysisWithResult:(NSDictionary *)result{
    
    self.analysisResult = result;
    NSLog(@"FinishedWith results \n%@", result);
    self.DelegateBlock(result);
}

@end
