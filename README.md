# HipChatExample

## Synopsis

This is an example of an analysis module for hip chat, the module can analyse a chat message for emotions, mentions and links.

## Motivation

learning more about string analysis in chat messaging

## Code Example
```
HipChatAnalyzer *hipChatAnalyzerhipChatAnalyzer = [[HipChatAnalyzer alloc] init];
[self.hipChatAnalyzer analyzeChatMessage:@"@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016" withDelegate:self];

- (void) chatMessageAnalyzer:(id<ChatMessageAnalyzer>)messageAnalyzer didFinishWithResult:(NSString *)jsonString{
//add your code here
}
```
## Tests

in xcode open the tests tab and run any of the 32 unit tests provided


## License

Copyright (c) 2016 EhabHanna

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
