//
//  EmoctionsAnalyzingStrategyTest.m
//  HipChatExample
//
//  Created by Ehab Asaad Hanna on 11/9/16.
//  Copyright © 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EmoctionsAnalyzer.h"

@interface EmoctionsAnalyzingStrategyTest : XCTestCase<AnalyzingStrategyDelegate>

@property (nonatomic, strong) EmoctionsAnalyzer *emoctionsAnalyzer;
@property (nonatomic, strong) NSDictionary *analysisResult;
@property (nonatomic, copy) void(^DelegateBlock)(NSDictionary *aResult);

@end

@implementation EmoctionsAnalyzingStrategyTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.emoctionsAnalyzer = [[EmoctionsAnalyzer alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"(megusta) it is nice to meet you" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,1,@"should find Exactly 1 mention");
    }];
    
    
    
    
}

- (void)testNonAlphaNumeric {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"(meg%sta) it is nice to meet you" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,0,@"should find Exactly 0 mentions,emoctions with non-alphanumeric chars should be ignored");
    }];
    
    
    
    
}

- (void)testInvalidLength {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"(megustamegustamegusta) it is nice to meet you" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,0,@"should find Exactly 0 mentions, emoctions with length > 15 should be ignored");
    }];
    
    
    
    
}

- (void)testMultiple {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"(coffee) (joedoe) it is nice to meet you" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,2,@"should find Exactly 2 mentions");

    }];
    
    
    
}

- (void)testMultipleNoSpace {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"(coffee)(joedoe) it is nice to meet you" andNotifyDelegate:self];
    
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,2,@"should find Exactly 2 mentions");
    }];

    
}

- (void)testNestedeEmoc {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"((megusta)) ((coffee)  (tea)) it is nice to meet you" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,3,@"should find Exactly 3 mentions");
    }];
    
    
    
    
}

- (void)testAdvancedNestedEmoc {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"(((((((((((((((((megusta))))))))))))))))) ((coffee)  (tea)) it is nice to meet you" andNotifyDelegate:self];
    
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,3,@"should find Exactly 3 mentions");
        
    }];

    
}

- (void)testEmpty {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"() it is nice to meet you" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,0,@"should find Exactly 0 mention");

    }];
    
    
    
}

- (void)testSpace {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"( ) it is nice to meet you" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,0,@"should find Exactly 0 mention");
    }];
    
    
    
    
}

- (void)testUnclosed {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"(megusta it is nice to meet you" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,0,@"should find Exactly 0 mention");
    }];
    
    
    
    
}

- (void)testUneven {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.emoctionsAnalyzer analyzeString:@"(megusta it is (nice) to meet you" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *emoctions = [aResult objectForKey:kHipChatAnalysisItemKey_Emoctions];
        
        XCTAssertEqual(emoctions.count,1,@"should find Exactly 0 mention");
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
