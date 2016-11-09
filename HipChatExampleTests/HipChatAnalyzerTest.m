//
//  HipChatAnalyzerTest.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/9/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "HipChatAnalyzer.h"

@interface HipChatAnalyzerTest : XCTestCase<ChatMessageAnalyzerDelegate>
@property (nonatomic, strong) XCTestExpectation *basicAnalysisExpectation;
@property (nonatomic, strong) XCTestExpectation *basicLinksAnalysisExpectation;
@property (nonatomic, strong) XCTestExpectation *emailTestCaseAnalysisExpectation;
@property (nonatomic, strong) XCTestExpectation *nonHTTPLinksExpectation;
@property (nonatomic, strong) XCTestExpectation *currentExpectation;
@property (nonatomic, strong) HipChatAnalyzer *hipChatAnalyzer;
@end

@implementation HipChatAnalyzerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.hipChatAnalyzer = [[HipChatAnalyzer alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    
    self.basicAnalysisExpectation = [self expectationWithDescription:@"finished basic Analysis"];
    
    self.currentExpectation = self.basicAnalysisExpectation;
    
    [self.hipChatAnalyzer analyzeChatMessage:@"@chris (morning) how are you?" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:120 handler:^(NSError *error) {
        NSLog(@"Back to the drawing board");
    }];
    
}

- (void)testbasicLink {
    // This is an example of a functional test case.
    
    self.basicLinksAnalysisExpectation = [self expectationWithDescription:@"finished basic link Analysis"];
    
    self.currentExpectation = self.basicLinksAnalysisExpectation;
    
    [self.hipChatAnalyzer analyzeChatMessage:@"@chris (morning) www.google.com how are you?" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:120 handler:^(NSError *error) {
        NSLog(@"Back to the drawing board, check url analyzer");
    }];
    
}

- (void)testAsProvidedInEmail {
    // This is an example of a functional test case.
    
    self.emailTestCaseAnalysisExpectation = [self expectationWithDescription:@"finished email provided test case Analysis"];
    
    self.currentExpectation = self.emailTestCaseAnalysisExpectation;
    
    [self.hipChatAnalyzer analyzeChatMessage:@"@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:120 handler:^(NSError *error) {
        NSLog(@"Back to the drawing board, check url analyzer");
    }];
    
}

- (void)testNonHTTPLinks {
    // This is an example of a functional test case.
    
    self.nonHTTPLinksExpectation = [self expectationWithDescription:@"finished non HTTP test case Analysis"];
    
    self.currentExpectation = self.nonHTTPLinksExpectation;
    
    [self.hipChatAnalyzer analyzeChatMessage:@"@bob @john (success) such a cool feature; john@gmail.com 010032344003 tel://21212" withDelegate:self];
    
    [self waitForExpectationsWithTimeout:120 handler:^(NSError *error) {
        NSLog(@"Back to the drawing board, check url analyzer");
    }];
    
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - 
#pragma mark ChatAnalyzerDelegate methods
- (void) chatMessageAnalyzer:(id<ChatMessageAnalyzer>)messageAnalyzer didFinishWithResult:(NSString *)jsonString{
 
    if (self.currentExpectation == self.basicAnalysisExpectation) {
        
        if (jsonString.length > 0) {
            
            NSLog(@"result = %@",jsonString);
            
            [self.basicAnalysisExpectation fulfill];
        }

    }else if (self.currentExpectation == self.basicLinksAnalysisExpectation){
        
        if (jsonString.length > 0) {
            
            NSLog(@"result = %@",jsonString);
            
            [self.basicLinksAnalysisExpectation fulfill];
        }
        
    }else if (self.currentExpectation == self.emailTestCaseAnalysisExpectation){
        
        if (jsonString.length > 0) {
            
            NSLog(@"result = %@",jsonString);
            
            [self.emailTestCaseAnalysisExpectation fulfill];
        }
        
    }else if (self.currentExpectation == self.nonHTTPLinksExpectation){
        
        if (jsonString.length > 0) {
            
            NSLog(@"result = %@",jsonString);
            
            [self.nonHTTPLinksExpectation fulfill];
        }
        
    }
    
}

@end
