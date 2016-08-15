//
//  DetailViewController.h
//  AePubReader
//
//  Created by Federico Frappi on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLZipArchive.h"
#import "EPub.h"
#import "Chapter.h"
#import "ContentViewController.h"
#import "HLBookController.h"

@class SearchResultsViewController;
@class SearchResult;

@interface EPubViewController : UIViewController <ChapterDelegate, UISearchBarDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
    UIToolbar *toolbar;

    UIBarButtonItem* chapterListButton;
	
	UIBarButtonItem* decTextSizeButton;
	UIBarButtonItem* incTextSizeButton;
    
    UISlider* pageSlider;
    UILabel* currentPageLabel;
			
	EPub* loadedEpub;
	int currentTextSize;
	int totalPagesCount;
    
    BOOL epubLoaded;
    BOOL paginating;
    BOOL searching;
    BOOL isAfter;
    BOOL textFontChange;
    
    UIPopoverController* chaptersPopover;
    UIPopoverController* searchResultsPopover;

    SearchResultsViewController* searchResViewController;
    SearchResult* currentSearchResult;
    
    UIPageViewController *curPageViewController;
}

- (IBAction) showChapterIndex:(id)sender;
- (IBAction) increaseTextSizeClicked:(id)sender;
- (IBAction) decreaseTextSizeClicked:(id)sender;
- (IBAction) slidingStarted:(id)sender;
- (IBAction) slidingEnded:(id)sender;
- (IBAction) doneClicked:(id)sender;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult;

- (void) loadEpub:(NSURL*) epubURL;

@property (nonatomic, assign) HLBookController *bookController;

@property (nonatomic, retain) ContentViewController *curContentViewController;

@property (nonatomic, retain) EPub* loadedEpub;

@property (nonatomic, retain) SearchResult* currentSearchResult;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *chapterListButton;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *decTextSizeButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *incTextSizeButton;

@property (nonatomic, retain) IBOutlet UISlider *pageSlider;
@property (nonatomic, retain) IBOutlet UILabel *currentPageLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property BOOL searching;

@property BOOL isHideBackBtn;

@property int curPageIndex;

@end
