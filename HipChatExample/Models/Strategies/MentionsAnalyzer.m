//
//  MentionsAnalyzer.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/7/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import "MentionsAnalyzer.h"

@implementation MentionsAnalyzer
@synthesize analysisResult;
@synthesize analysisDelegate;

- (void) analyzeString:(NSString *)inputString andNotifyDelegate:(id<AnalyzingStrategyDelegate>)delegate{
    
    self.analysisDelegate = delegate;
    
    inputString = [self stringByRemovingEmailsFromInputString:inputString];
    
    NSMutableArray *mentions = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSScanner *theScanner = [NSScanner scannerWithString:inputString];
    [theScanner setCharactersToBeSkipped:nil];
    NSCharacterSet *startEmoc = [NSCharacterSet characterSetWithCharactersInString:@"@"];
    NSCharacterSet *endEmoc = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *mention = nil;
    
    while (![theScanner isAtEnd]) {
        
        [theScanner scanUpToCharactersFromSet:startEmoc intoString:NULL];
        
        if (theScanner.scanLocation == inputString.length) {
            break;
        }else{
            [theScanner setScanLocation: [theScanner scanLocation]+1];
        }
        
        [theScanner scanUpToCharactersFromSet:endEmoc intoString:&mention];
        
        if (mention && mention.length > 0) {

            [mentions addObject:mention];
            mention = nil;
            
        }
    }
    
    self.analysisResult = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [self.analysisResult setObject:mentions forKey:kHipChatAnalysisItemKey_Mentions];
    
    if (self.analysisDelegate) {
        
        if ([self.analysisDelegate respondsToSelector:@selector(analyzingStrategy:didFinishAnalysisWithResult:)]) {
            
            [self.analysisDelegate analyzingStrategy:self didFinishAnalysisWithResult:self.analysisResult];
            
        }
        
    }
    
}

- (NSString *) stringByRemovingEmailsFromInputString:(NSString *) inputString{

    NSError *initError = nil;
    
    NSDataDetector *linksDetector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:&initError];
    
    if (!initError) {
        
        NSString *result = inputString;
        
        NSArray *matches = [linksDetector matchesInString:inputString options:0 range:NSMakeRange(0, [inputString length])];
        
        NSURL *aURL = nil;
        
        for (NSTextCheckingResult *match in matches) {
            
            if ([match resultType] == NSTextCheckingTypeLink) {
                
                aURL = [match URL];
                
                if ([aURL.scheme isEqualToString:@"mailto"]) {
                    
                    result = [result stringByReplacingCharactersInRange:match.range withString:@""];
                    
                }
                
            }
        }
        
        return result;
        
    }
    
    return inputString;
    
}

@end
