//
//  ContentViewController.h
//  AePubReader
//
//  Created by Mouee-iMac on 13-6-18.
//
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"
#import "EPub.h"
#import "Chapter.h"

@interface ContentViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView *curWebView;
    
    int curPageInSpineIndex;
    int currentSpineIndex;
	int currentPageInSpineIndex;
	int pagesInCurrentSpineCount;
}

@property int currentTextSize;

@property int tag;

@property (nonatomic, retain) SearchResult* currentSearchResult;

@property (nonatomic, retain) EPub* loadedEpub;

@property (nonatomic, assign) UIWebView *curWebView;

- (void) loadSpine;

- (void) loadSpine:(int)curPageIndex;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult;

@end
