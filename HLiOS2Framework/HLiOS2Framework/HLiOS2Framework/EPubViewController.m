//
//  DetailViewController.m
//  AePubReader
//
//  Created by Federico Frappi on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EPubViewController.h"
#import "ChapterListViewController.h"
#import "SearchResultsViewController.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"
#import "Chapter.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface EPubViewController()

@end

@implementation EPubViewController

@synthesize loadedEpub, toolbar, isHideBackBtn = isHideBackBtn;
@synthesize chapterListButton, decTextSizeButton, incTextSizeButton;
@synthesize currentPageLabel, pageSlider, searching;
@synthesize currentSearchResult;
@synthesize curPageIndex;

#pragma mark -

- (void) loadEpub:(NSURL*) epubURL{
//    currentSpineIndex = 0;
//    currentPageInSpineIndex = 0;
//    pagesInCurrentSpineCount = 0;
    curPageIndex = 1;
    totalPagesCount = 0;
	searching = NO;
    epubLoaded = NO;
    self.loadedEpub = [[[EPub alloc] initWithEPubPath:[epubURL path]] autorelease];
    
    [self resetCoverImgSize];
    
    self.curContentViewController.loadedEpub = self.loadedEpub;
    epubLoaded = YES;
//    NSLog(@"loadEpub");
	[self updatePagination];
}

- (void)resetCoverImgSize
{
    int curBookIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"curBookIndex"] intValue];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/UnzippedEpub%d/OEBPS/Images/", curBookIndex]];
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
        for (int i = 0; i < fileArray.count; i++)
        {
            NSString *imgName = [fileArray objectAtIndex:i];
            NSArray *nameArray = [imgName componentsSeparatedByString:@"."];
            if ([[nameArray objectAtIndex:[nameArray count] - 1] isEqualToString:@"jpg"] || [[nameArray objectAtIndex:[nameArray count] - 1] isEqualToString:@"png"])
            {
                
                NSString *strPath=[NSString stringWithFormat:@"%@%@", path, imgName];
                UIImage *img = [UIImage imageWithContentsOfFile:strPath];
 
                float webWidth = self.curContentViewController.curWebView.frame.size.width;
                float webHeight = self.curContentViewController.curWebView.frame.size.height;
                float imgWidth = img.size.width;
                float imgHeight = img.size.height;
                NSData *data = nil;
                if (imgWidth > webWidth || imgHeight > webHeight)
                {
                    CGSize size;
                    if (webWidth / webHeight < imgWidth / imgHeight)
                    {
                        size = CGSizeMake(webWidth, imgHeight / imgWidth * webWidth);
                    }
                    else
                    {
                        size = CGSizeMake(imgWidth / imgHeight * webHeight, webHeight);
                    }
                    UIGraphicsBeginImageContext(size);
                    [img drawInRect:CGRectMake(0,0,size.width, size.height)];
                    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    data = UIImageJPEGRepresentation(newImage, 1);
                    NSFileManager *fileManager = [NSFileManager defaultManager];

                    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
                    [fileManager createFileAtPath:[path stringByAppendingString:[NSString stringWithFormat:@"%@", imgName]] contents:data attributes:nil];
                    
                }
            }
        }
    }
    
    
    
}

//将图片放缩到指定大小
- (UIImage*)imageResize:(UIImage*)image size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    //    NSLog(@"willTransitionToViewControllers");
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
//    NSLog(@"didFinishAnimating %i",((ContentViewController *)[pageViewController.viewControllers objectAtIndex:0]).tag);
    int pageIndex = ((ContentViewController *)[pageViewController.viewControllers objectAtIndex:0]).tag;
    curPageIndex = pageIndex + 1;
    if (completed) {
        [currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",pageIndex + 1, totalPagesCount]];
        [pageSlider setValue:(float)100*(float)(pageIndex + 1)/(float)totalPagesCount animated:YES];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
//    NSLog(@"Before");
    isAfter = NO;
    int pageIndex = ((ContentViewController *)viewController).tag;

    if (pageIndex > 0) {
        pageIndex --;
    }
    else
    {
        isAfter = YES;
        return nil;
    }

    return [self getContentViewController:pageIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
//    NSLog(@"After");
    isAfter = YES;
    int pageIndex = ((ContentViewController *)viewController).tag;
    if (pageIndex < totalPagesCount - 1) {
        pageIndex ++;
    }
    else
    {
        return nil;
    }
    
    return [self getContentViewController:pageIndex];
}

- (ContentViewController *)getContentViewController:(int)pageIndex
{
    [chaptersPopover dismissPopoverAnimated:YES];
    [searchResultsPopover dismissPopoverAnimated:YES];
    
    ContentViewController *contentViewController = [[[ContentViewController alloc] init] autorelease];
    contentViewController.tag = pageIndex;
    contentViewController.currentTextSize = currentTextSize;
    contentViewController.loadedEpub = self.loadedEpub;
    contentViewController.currentSearchResult = self.currentSearchResult;
    [contentViewController loadSpine:pageIndex + 1];
    return contentViewController;
}

- (void) chapterDidFinishLoad:(Chapter *)chapter{
    totalPagesCount+=chapter.pageCount;

	if(chapter.chapterIndex + 1 < [loadedEpub.spineArray count]){
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] setDelegate:self];
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:self.curContentViewController.view.bounds fontPercentSize:currentTextSize];
		[currentPageLabel setText:[NSString stringWithFormat:@"?/%d", totalPagesCount]];
	} else {
        if (curPageIndex > totalPagesCount) {
            curPageIndex = totalPagesCount;
            ((ContentViewController *)[curPageViewController.viewControllers objectAtIndex:0]).tag = totalPagesCount -1;
        }
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",curPageIndex, totalPagesCount]];
		[pageSlider setValue:(float)100*(float)curPageIndex/(float)totalPagesCount animated:YES];
		paginating = NO;
//		NSLog(@"Pagination Ended!");
        curPageViewController.view.userInteractionEnabled = YES;
	}
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult{
	self.currentSearchResult = theResult;

	[chaptersPopover dismissPopoverAnimated:YES];
	[searchResultsPopover dismissPopoverAnimated:YES];
    
    int pageCount = 0;
	for(int i=0; i<spineIndex; i++)
    {
		pageCount += [(Chapter *)[loadedEpub.spineArray objectAtIndex:i] pageCount];
	}
	pageCount += pageIndex + 1;
	
    self.curContentViewController = [self getContentViewController:pageCount - 1];
    [curPageViewController setViewControllers:[NSArray arrayWithObject:self.curContentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    curPageIndex = self.curContentViewController.tag + 1;
    
	if(!paginating){
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",pageCount, totalPagesCount]];
		[pageSlider setValue:(float)100*(float)pageCount/(float)totalPagesCount animated:YES];
	}
}

- (IBAction) increaseTextSizeClicked:(id)sender{
	if(!paginating){
		if(currentTextSize+25<=200){
            textFontChange = YES;
			currentTextSize+=25;
			[self updatePagination];
			if(currentTextSize == 200){
				[incTextSizeButton setEnabled:NO];
			}
			[decTextSizeButton setEnabled:YES];
		}
	}
}
- (IBAction) decreaseTextSizeClicked:(id)sender{
	if(!paginating){
		if(currentTextSize-25>=50){
            textFontChange = YES;
			currentTextSize-=25;
			[self updatePagination];
			if(currentTextSize==50){
				[decTextSizeButton setEnabled:NO];
			}
			[incTextSizeButton setEnabled:YES];
		}
	}
}

- (IBAction) doneClicked:(id)sender{
//    [self dismissModalViewControllerAnimated:YES];
    if (paginating) {
        return;
    }
    [self.bookController close];
}

- (void)setIsHideBackBtn:(BOOL)hideBackBtn
{
    isHideBackBtn = hideBackBtn;
    if (hideBackBtn)
    {
        NSMutableArray *toolbarButtons = [self.toolbar.items mutableCopy];
        [toolbarButtons removeObject:self.doneButton];
        [self.toolbar setItems:toolbarButtons animated:YES];
    }
}

- (BOOL)isHideBackBtn
{
    return self.isHideBackBtn;
}

- (IBAction) slidingStarted:(id)sender{
    int targetPage = ((pageSlider.value/(float)100)*(float)totalPagesCount);
    if (targetPage==0) {
        targetPage++;
    }
	[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d", targetPage, totalPagesCount]];
}

- (IBAction) slidingEnded:(id)sender{
	int targetPage = (int)((pageSlider.value/(float)100)*(float)totalPagesCount);
    if (targetPage <= 0) {
        targetPage = 1;
    }
    if (targetPage > totalPagesCount) {
        targetPage = totalPagesCount - 1;
    }
    
	self.curContentViewController = [self getContentViewController:targetPage - 1];
    [curPageViewController setViewControllers:[NSArray arrayWithObject:self.curContentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    curPageIndex = self.curContentViewController.tag + 1;
}

- (IBAction) showChapterIndex:(id)sender{
	if(chaptersPopover==nil){
		ChapterListViewController* chapterListView = [[ChapterListViewController alloc] initWithNibName:@"ChapterListViewController" bundle:[NSBundle mainBundle]];
		[chapterListView setEpubViewController:self];
		chaptersPopover = [[UIPopoverController alloc] initWithContentViewController:chapterListView];
		[chaptersPopover setPopoverContentSize:CGSizeMake(400, 600)];
		[chapterListView release];
	}
	if ([chaptersPopover isPopoverVisible]) {
		[chaptersPopover dismissPopoverAnimated:YES];
	}else{
		[chaptersPopover presentPopoverFromBarButtonItem:chapterListButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];		
	}
}


- (void) updatePagination{
	if(epubLoaded){
        if(!paginating){
            curPageViewController.view.userInteractionEnabled = NO;
//            NSLog(@"Pagination Started!");
            paginating = YES;
            totalPagesCount=0;
            if (!textFontChange)
            {
                [self.curContentViewController loadSpine];
            }
            else
            {
                textFontChange = NO;
                self.curContentViewController = [self getContentViewController:((ContentViewController *)[curPageViewController.viewControllers objectAtIndex:0]).tag];
                [curPageViewController setViewControllers:[NSArray arrayWithObject:self.curContentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }
            
            [[loadedEpub.spineArray objectAtIndex:0] setDelegate:self];
            [[loadedEpub.spineArray objectAtIndex:0] loadChapterWithWindowSize:self.curContentViewController.view.bounds fontPercentSize:currentTextSize];
            [currentPageLabel setText:@"?/?"];
        }
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	if(searchResultsPopover==nil){
		searchResultsPopover = [[UIPopoverController alloc] initWithContentViewController:searchResViewController];
		[searchResultsPopover setPopoverContentSize:CGSizeMake(400, 600)];
	}
	if (![searchResultsPopover isPopoverVisible]) {
		[searchResultsPopover presentPopoverFromRect:searchBar.bounds inView:searchBar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
//	NSLog(@"Searching for %@", [searchBar text]);
	if(!searching){
		searching = YES;
		[searchResViewController searchString:[searchBar text]];
        [searchBar resignFirstResponder];
	}
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.currentSearchResult = nil;
    }
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    NSLog(@"shouldAutorotate");
//    [self updatePagination];
	return YES;
}

#pragma mark -
#pragma mark View lifecycle

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        curPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (iPhone5)
            {
                curPageViewController.view.frame = CGRectMake(0, 0, 320, 568);
            }
            else
            {
                curPageViewController.view.frame = CGRectMake(0, 0, 320, 480);
            }
        }
        else
        {
            curPageViewController.view.frame = CGRectMake(0, 0, 768, 1024);
        }
        curPageViewController.delegate = self;
        curPageViewController.dataSource = self;
        [self.view addSubview:curPageViewController.view];
        
        self.curContentViewController = [[[ContentViewController alloc] init] autorelease];
        self.curContentViewController.tag = 0;
        [curPageViewController setViewControllers:[NSArray arrayWithObject:self.curContentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self.view bringSubviewToFront:toolbar];
        [self.view bringSubviewToFront:pageSlider];
        [self.view bringSubviewToFront:currentPageLabel];
        
        
        currentTextSize = 100;
        
        [pageSlider setThumbImage:[UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
        [pageSlider setMinimumTrackImage:[[UIImage imageNamed:@"orangeSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
        [pageSlider setMaximumTrackImage:[[UIImage imageNamed:@"yellowSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
        
        searchResViewController = [[SearchResultsViewController alloc] initWithNibName:@"SearchResultsViewController" bundle:[NSBundle mainBundle]];
        searchResViewController.epubViewController = self;
    }
    return self;
}

- (void)viewDidUnload {
    
	self.toolbar = nil;
	self.chapterListButton = nil;
	self.decTextSizeButton = nil;
	self.incTextSizeButton = nil;
	self.pageSlider = nil;
	self.currentPageLabel = nil;	
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
    [curPageViewController release];
    self.doneButton = nil;
    self.chapterListButton = nil;
	self.decTextSizeButton = nil;
	self.incTextSizeButton = nil;
    self.toolbar = nil;
	self.pageSlider = nil;
	self.currentPageLabel = nil;
    self.curContentViewController = nil;
	self.loadedEpub = nil;
	chaptersPopover = nil;
	searchResultsPopover = nil;
	searchResViewController = nil;
	currentSearchResult = nil;
    [super dealloc];
}

@end
