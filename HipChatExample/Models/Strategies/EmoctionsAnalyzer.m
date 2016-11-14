//
//  EmoctionsAnalyzer.m
//  HipChatExample
//
//  Created by Ehab Asaad's Mac Mini on 11/7/16.
//  Copyright (c) 2016 Ehab Asaad's Mac Mini. All rights reserved.
//

#import "EmoctionsAnalyzer.h"

@implementation EmoctionsAnalyzer
@synthesize analysisResult;
@synthesize analysisDelegate;

- (void) analyzeString:(NSString *)inputString andNotifyDelegate:(id<AnalyzingStrategyDelegate>)delegate{
    
    self.analysisDelegate = delegate;

    NSMutableArray *emoctions = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSScanner *theScanner = [NSScanner scannerWithString:inputString];
    [theScanner setCharactersToBeSkipped:nil];
    NSCharacterSet *startEmoc = [NSCharacterSet characterSetWithCharactersInString:@"("];
    NSCharacterSet *endEmoc = [NSCharacterSet characterSetWithCharactersInString:@"()"];
    NSString *emoction = nil;
    
    while (![theScanner isAtEnd]) {
        
        [theScanner scanUpToCharactersFromSet:startEmoc intoString:NULL];
        
        if (theScanner.scanLocation == inputString.length) {
            break;
        }else{
            [theScanner setScanLocation: [theScanner scanLocation]+1];
        }
        
        [theScanner scanUpToCharactersFromSet:endEmoc intoString:&emoction];
        
        if (emoction) {
             
            if ([self isValidEmoction:emoction]) {
                [emoctions addObject:emoction];
                emoction = nil;
            }else{
                emoction = nil;
            }

        }
    }
    
    self.analysisResult = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [self.analysisResult setObject:emoctions forKey:kHipChatAnalysisItemKey_Emoctions];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.analysisDelegate) {
            
            if ([self.analysisDelegate respondsToSelector:@selector(analyzingStrategy:didFinishAnalysisWithResult:)]) {
                
                [self.analysisDelegate analyzingStrategy:self didFinishAnalysisWithResult:self.analysisResult];
                
            }
            
        }
    }];

}

- (BOOL) isValidEmoction:(NSString *) aString{
    
    NSCharacterSet *validChars = [NSCharacterSet alphanumericCharacterSet];
    
    NSCharacterSet *inverse = [validChars invertedSet];
    
    NSRange r = [aString rangeOfCharacterFromSet:inverse];
    
    if (r.location != NSNotFound) {
        return NO;
    }
    
    if (aString.length > 15) {
        return NO;
    }
    
    return YES;
}
@end
