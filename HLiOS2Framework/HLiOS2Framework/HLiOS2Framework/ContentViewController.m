//
//  ContentViewController.m
//  AePubReader
//
//  Created by Mouee-iMac on 13-6-18.
//
//
#import <Foundation/Foundation.h>
#import "ContentViewController.h"
#import "UIWebView+SearchWebView.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface ContentViewController ()

@end

@implementation ContentViewController

@synthesize loadedEpub, currentSearchResult, currentTextSize, curWebView;

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        CGRect rect = CGRectZero;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (iPhone5)
            {
                rect = CGRectMake(20, 63, 280, 450);
            }
            else
            {
                rect = CGRectMake(20, 63, 280, 360);
            }
        }
        else
        {
            rect = CGRectMake(20, 63, 728, 862);
        }

        curWebView = [[[UIWebView alloc] initWithFrame:rect] autorelease];
        curWebView.backgroundColor = [UIColor clearColor];
        curWebView.userInteractionEnabled = NO;
        [curWebView setDelegate:self];
        
        currentTextSize = 100;

        [self.view addSubview:curWebView];
    }
    return self;
}

- (void) loadSpine
{
    [self loadSpine:0 atPageIndex:0 highlightSearchResult:nil];
}

- (void) loadSpine:(int)curPageIndex
{
    int targetPage = curPageIndex;
    if (targetPage==0) {
        targetPage++;
    }
	int pageSum = 0;
	int chapterIndex = 0;
	int pageIndex = 0;
	for(chapterIndex = 0; chapterIndex < [loadedEpub.spineArray count]; chapterIndex++){
		pageSum+=[[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount];
        //		NSLog(@"Chapter %d, targetPage: %d, pageSum: %d, pageIndex: %d", chapterIndex, targetPage, pageSum, (pageSum-targetPage));
		if(pageSum>=targetPage){
			pageIndex = [[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
			break;
		}
	}
    
	[self loadSpine:chapterIndex atPageIndex:pageIndex highlightSearchResult:self.currentSearchResult];
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult{
	self.currentSearchResult = theResult;
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
    
	NSURL* url = [NSURL fileURLWithPath:[[loadedEpub.spineArray objectAtIndex:spineIndex] spinePath]];
	[curWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) gotoPageInCurrentSpine:(int)pageIndex{
	float pageOffset = pageIndex*curWebView.bounds.size.width;
    
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	
	[curWebView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[curWebView stringByEvaluatingJavaScriptFromString:goTo];	
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
	
	NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
	"mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
	"ruleIndex = mySheet.cssRules.length;"
	"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
	"}"
	"}";
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", theWebView.frame.size.height, theWebView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", currentTextSize];
	NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
    
	
	[theWebView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[theWebView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[theWebView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[theWebView stringByEvaluatingJavaScriptFromString:insertRule2];
	
	[theWebView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	
	[theWebView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
	
	if(currentSearchResult!=nil){
        //	NSLog(@"Highlighting %@", currentSearchResult.originatingQuery);
        [theWebView highlightAllOccurencesOfString:currentSearchResult.originatingQuery];
	}
	
	
	int totalWidth = [[theWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	pagesInCurrentSpineCount = (int)((float)totalWidth/theWebView.bounds.size.width);
	
	[self gotoPageInCurrentSpine:currentPageInSpineIndex];
}

-(void)dealloc
{
    [currentSearchResult release];
    [loadedEpub release];
    [super dealloc];
}

@end
