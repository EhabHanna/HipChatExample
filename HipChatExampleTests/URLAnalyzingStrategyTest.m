//
//  URLAnalyzingStrategyTest.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/9/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "URLAnalyzer.h"

@interface URLAnalyzingStrategyTest : XCTestCase<AnalyzingStrategyDelegate>

@property (nonatomic, strong) URLAnalyzer *urlAnalyzer;
@property (nonatomic, strong) NSDictionary *analysisResult;
@property (nonatomic, copy) void(^DelegateBlock)(NSDictionary *aResult);

@end
@implementation URLAnalyzingStrategyTest
@synthesize analysisResult;
@synthesize urlAnalyzer;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.urlAnalyzer = [[URLAnalyzer alloc] init];
    self.urlAnalyzer.offlineMode = YES;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    
     [self.urlAnalyzer analyzeString:@ "@https://gmail.com have you checked it today?" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *urls = [aResult objectForKey:kHipChatAnalysisItemKey_Links];
        XCTAssertEqual(urls.count,1,@"should find Exactly 1 mentions");

    }];
    
   
}
- (void)testEmail {
    // This is an example of a functional test case.
    
    [self.urlAnalyzer analyzeString:@ "@hey you should send a message to john@gmail.com, he will give you something cool" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *urls = [aResult objectForKey:kHipChatAnalysisItemKey_Links];
        XCTAssertEqual(urls.count,1,@"should find Exactly 1 mentions");
    }];
    
    
}

- (void)testmultiple {
    // This is an example of a functional test case.
    
    [self.urlAnalyzer analyzeString:@ "@hey https://samsung.com & john@gmail.com, these are links" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *urls = [aResult objectForKey:kHipChatAnalysisItemKey_Links];
        XCTAssertEqual(urls.count,2,@"should find Exactly 2 mentions");
    }];
    
    
}

- (void)testEncoded {
    // This is an example of a functional test case.
    
    [self.urlAnalyzer analyzeString:@ "@hey check this out http%3A%2F%2Fwww.w3schools.com%2Fhtml%2Fhtml_urlencode.asp" andNotifyDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    [self setDelegateBlock:^(NSDictionary *aResult) {
        
        id self = weakSelf;
        NSArray *urls = [aResult objectForKey:kHipChatAnalysisItemKey_Links];
        XCTAssertEqual(urls.count,1,@"should find Exactly 1 mentions");
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
