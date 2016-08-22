
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIWebView (SearchWebView)

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end