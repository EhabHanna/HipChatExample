//
//  URLAnalyzer.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/7/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import "URLAnalyzer.h"
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface URLAnalyzer ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) NSMutableArray *analysisQueue;
@property (nonatomic, strong) NSMutableArray *analysisResultQueue;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, strong) NSMutableDictionary *currentAnalysisDict;
@property (nonatomic, strong) id<AnalyzingStrategyDelegate> strongDelegate;
@property (nonatomic, strong) NSOperationQueue *originalQueue;

@end

@implementation URLAnalyzer
@synthesize analysisResult;
@synthesize analysisDelegate;

- (void) analyzeString:(NSString *)inputString andNotifyDelegate:(id<AnalyzingStrategyDelegate>)delegate{
    
    self.analysisDelegate = delegate;
    self.strongDelegate = delegate;
    
    NSError *initError = nil;
    
    NSDataDetector *linksDetector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:&initError];
    
    if (!initError) {
        
        NSArray *matches = [linksDetector matchesInString:inputString options:0 range:NSMakeRange(0, [inputString length])];
        
        self.analysisQueue = [[NSMutableArray alloc] initWithCapacity:matches.count];
        
        NSURL *aURL = nil;
        
        for (NSTextCheckingResult *match in matches) {
            
            if ([match resultType] == NSTextCheckingTypeLink) {
                
                aURL = [match URL];
                [self.analysisQueue addObject:aURL];
            
            }
        }
        
        [self beginURLQueueAnalysis];
        
    }
  
}

#pragma mark - 
#pragma mark UIWebViewDelegate methods

- (void) webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    
    webView.delegate = nil;
    __block NSString* text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    __block URLAnalyzer *blockSafeSelf = self;
    
    [self.originalQueue addOperationWithBlock:^{
        [blockSafeSelf finishAnalyzingURLWithResultTitle:text];
    }];
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    webView.delegate = nil;
    
    __block URLAnalyzer *blockSafeSelf = self;
    
    [self.originalQueue addOperationWithBlock:^{
        [blockSafeSelf finishAnalyzingURLWithResultTitle:@"n/a"];
    }];
    
    
}

#pragma mark - 
#pragma mark URL Queue processing

- (void) beginURLQueueAnalysis{
    
    self.currentIndex = 0;
    self.analysisResultQueue = [[NSMutableArray alloc] initWithCapacity:self.analysisQueue.count];
    [self analyzeURLAtCurrentIndex];
}

- (void) analyzeURLAtCurrentIndex{
    
    if (self.currentIndex < self.analysisQueue.count) {
        
        [self beginAnalyzingURL:[self.analysisQueue objectAtIndex:self.currentIndex]];
    }else{
        [self finishURLQueueAnalysis];
    }
    
}

- (void) finishURLQueueAnalysis{
    
    self.analysisResult = [NSMutableDictionary dictionaryWithCapacity:1];
    [self.analysisResult setObject:self.analysisResultQueue forKey:kHipChatAnalysisItemKey_Links];
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.analysisDelegate) {
            
            if ([self.analysisDelegate respondsToSelector:@selector(analyzingStrategy:didFinishAnalysisWithResult:)]) {
                
                [self.analysisDelegate analyzingStrategy:self didFinishAnalysisWithResult:self.analysisResult];
                
            }
            
        }
    }];
    
}

#pragma mark - Individual URL analysis
- (void) beginAnalyzingURL:(NSURL *) aURL{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:2];
    
    
    [result setObject:aURL.absoluteString forKey:@"url"];
    
    self.currentAnalysisDict = result;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
   
    
    if (self.offlineMode || netStatus == NotReachable) {
        [self webView:self.webview didFailLoadWithError:nil];
    }else{
        
        __block URLAnalyzer *blockSafeSelf = self;
        self.originalQueue = [NSOperationQueue currentQueue];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aURL];
            request.timeoutInterval = 30;
            
            blockSafeSelf.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            blockSafeSelf.webview.delegate = blockSafeSelf;
            [blockSafeSelf.webview loadRequest:request];
            
        }];
        
        
    }
    
}

- (void) finishAnalyzingURLWithResultTitle:(NSString *)title{
    
    [self.currentAnalysisDict setObject:title forKey:@"title"];
    [self.analysisResultQueue addObject:self.currentAnalysisDict];
    self.currentIndex = self.currentIndex + 1;
    [self analyzeURLAtCurrentIndex];
}

#pragma mark -



@end
