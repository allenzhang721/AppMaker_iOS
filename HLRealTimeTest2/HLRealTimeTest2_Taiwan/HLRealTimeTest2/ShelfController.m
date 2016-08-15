//
//  ShelfController.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "ShelfController.h"
#import "GMGridViewLayoutStrategies.h"
#import "ShellCell.h" 
#import "App.h"



@implementation ShelfController
@synthesize gridView;
@synthesize shelfEntity;
@synthesize isClean;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.isClean = NO;
        self.shelfEntity = [[App instance] getShelfEntity];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reDownload:) name:@"bookRedownloadNotification" object:nil];
        
        //删除按钮点击提示
        {
            self.alertView = [URBAlertView dialogWithTitle:@"" message:@""];
            [self.alertView setBackgroundImage:[UIImage imageNamed:@"TW_image_deleteinfo"]];
            self.alertView.blurBackground = NO;
            [self.alertView setButtonBackgroundImage:[UIImage imageNamed:@"ipad_btn.png"]];
            
            [self.alertView addButtonWithTitle:@"取消" sideLeft:YES];
            [self.alertView addButtonWithTitle:@"刪除" sideLeft:NO];
            UIColor *buttonTitleColor = [UIColor colorWithRed:0.549 green:0.024 blue:0.082 alpha:1];
            [self.alertView setButtonTextAttributes:@{UITextAttributeTextColor:buttonTitleColor} forState:UIControlStateNormal];
            [self.alertView setButtonTextAttributes:@{UITextAttributeTextColor:buttonTitleColor} forState:UIControlStateHighlighted];
            [self.alertView setTitleFont:[UIFont systemFontOfSize:25]];
            [self.alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
             {
                 if (buttonIndex == 1)
                 {
                     [self.alertView hideWithCompletionBlock:^
                      {
                          [self.gridView removeObjectAtIndex:self.alertView.tag withAnimation:GMGridViewItemAnimationFade];
                          ShelfBookEntity *entity  = [self.shelfEntity.books objectAtIndex:self.alertView.tag];
                          [entity remove];
                          [self.shelfEntity.books removeObjectAtIndex:self.alertView.tag];
                          [self.gridView reloadData];
                          [self updateBgView];
                          [self.shelfEntity save];
                          
                      }];
                 }
                 else
                 {
                     [self.alertView hideWithCompletionBlock:^{}];
                 }
             }];
        }
        
        //Info按钮点击提示,aboutView
        if (!self.infoAlertView) {
            
            self.infoAlertView = [URBAlertView dialogWithTitle:@"" message:@""];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                [self.infoAlertView setBackgroundImage:[UIImage imageNamed:@"TW_image_about"]];
            }
            else
            {
                [self.infoAlertView setBackgroundImage:[UIImage imageNamed:@"TW_image_about_iPad"]];
            }
            
            self.infoAlertView.blurBackground = YES;
            
            float infoWidth = self.infoAlertView.backgroundImage.size.width;
            float infoHeight = self.infoAlertView.backgroundImage.size.height;
            
            NSLog(@"self.infoAlertView.frame%@",NSStringFromCGRect(self.infoAlertView.frame));
            
            UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, infoHeight / 9, infoWidth / 14 * 14, 30)];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                label.frame = CGRectMake(0, infoHeight / 12, infoWidth / 14 * 14, 30);
            }
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:10];
            label.text = @"Versions 1.0";         //版本号
            //            [self.infoAlertView addSubview:label];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [self.infoAlertView addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)reDownload:(NSNotification *)notification
{
    ShelfBookEntity *entity = [notification object];
    int index = [self.shelfEntity.books indexOfObject:entity];
    
    ShelfBookEntity *bookEntity = [[[ShelfBookEntity alloc] init] autorelease];
    bookEntity.downloadurl  = entity.downloadurl;
    bookEntity.coverurl     = entity.coverurl;
    bookEntity.bookNameUrl  = entity.bookNameUrl;
    
    [self.gridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade];
    [entity remove];
    [self.shelfEntity.books removeObjectAtIndex:index];
    [self.gridView reloadData];
    [self updateBgView];
    [self.shelfEntity save];
    
    [self.shelfEntity.books insertObject:bookEntity atIndex:0];
    [self addNewBook];
    
    
}

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    [self.infoAlertView hideWithAnimation:URBAlertAnimationFlipVertical];
}

-(void) openBook:(NSString *) bookpath
{
//    @try {
        [[App instance] closeShelf];
    
    if ([[[App instance] getAppMaker] loadBookEntity:bookpath] == YES) {
        
//        [[[App instance] getAppMaker] openBookWithRootViewController:nil bookDirectoryPath:bookpath theDelegate:nil hiddenBackIcon:NO hiddenShareIcon:NO];
        [[[App instance] getAppMaker] hideWeiboButton];
        [[[App instance] getAppMaker] setup];
        [[[App instance] getAppMaker] openBook];
        [[[App instance] getAppMaker] startView];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"書籍內容出錯！" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alertView show];
        [[[App instance] getAppMaker] closeBook];
    }
    
//    }
//    @catch (NSException *exception) {
//        [[[App instance] getAppBook] closeBook];
//        
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"title" message:@"书籍已损坏，请重新下载。" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil] autorelease];
//        [alert show];
//    }
//    @finally {
//        
//    }
    
}

-(void) openEditing
{
    self.gridView.editing = YES;
}

-(void) closeEditing
{
    self.gridView.editing = NO;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position;
{
    ShelfBookEntity *entity = [self.shelfEntity.books objectAtIndex:position];
    if (entity.canOpen == YES)
    {
        if ([entity.tempid isEqualToString:@"smartApps"] == YES)
        {
            NSString *demoBookPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"book"];
            [self openBook:demoBookPath];
        }
        else
        {
            [self openBook:[entity getBookPath]];
        }
    }
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    self.alertView.tag = index;
    [self.alertView showWithAnimation:URBAlertAnimationFlipVertical];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(160, 230 - 32);      //每个Cell的大小
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    if (self.isClean == NO)
    {
        return [shelfEntity.books count];
    }
    else
    {
        return 0;
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gv cellForItemAtIndex:(NSInteger)index
{
    ShellCell *cell =  (ShellCell*)[gv dequeueReusableCell];
    ShelfBookEntity *entity = [self.shelfEntity.books objectAtIndex:index];
    if (!cell)
    {
        cell = [[[ShellCell alloc] init] autorelease];
    }
    cell.entity = entity;
    entity.cell = cell;
    [cell update];
    [entity update];
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(ShellCell *)cell
{
    //[cell beginMove];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(ShellCell *)cell
{
    [self.shelfEntity save];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [self.shelfEntity.books exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    ShelfBookEntity *entity = [self.shelfEntity.books objectAtIndex:index];
    if ([entity.tempid isEqualToString:@"smartApps"])
    {
        return NO;
    }
    return YES;
}

-(void) setup
{
    if (self.gridView != nil)
    {
        gridView.style = GMGridViewStyleSwap;
        gridView.backgroundColor = [UIColor clearColor];
        gridView.dataSource      = self;
        gridView.actionDelegate  = self;
        gridView.sortingDelegate = self;
        gridView.centerGrid = NO;
        gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
        gridView.clipsToBounds = YES;
        gridView.userInteractionEnabled = YES;
        gridView.alwaysBounceVertical  = YES;
        gridView.showsVerticalScrollIndicator   = NO;
        gridView.showsHorizontalScrollIndicator = NO;
        gridView.showsVerticalScrollIndicator   = NO;
        gridView.bounces                        = YES;
        gridView.alwaysBounceVertical           = YES;
        gridView.alwaysBounceHorizontal         = NO;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            gridView.minEdgeInsets                  = UIEdgeInsetsMake(65, 0, 0, 0);
            gridView.itemVerSpacing                 = 45;
            gridView.itemSpacing                    = 0;
        }
        else
        {
            gridView.minEdgeInsets                  = UIEdgeInsetsMake(70, 35, 0, 0);
            gridView.itemVerSpacing                 = 45;
            gridView.itemSpacing                    = 20;
        }
    }
}

-(void) updateBgView
{
    if (self.bgView == nil)
    {
        self.bgView = [[[UIView alloc] init] autorelease];
        [self.gridView addSubview:self.bgView];
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.bgView.frame = CGRectMake(0, 30, self.gridView.frame.size.width, self.gridView.contentSize.height);
        [self.bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone_break_line.png"]]];

    }
    else
    {
        self.bgView.frame = CGRectMake(0, 50, self.gridView.frame.size.width, self.gridView.contentSize.height);
        [self.bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_break_line.png"]]];
    }
    [self.gridView sendSubviewToBack:self.bgView];
}

-(void) addNewBook
{
    [self.gridView insertObjectAtIndex:0 withAnimation:GMGridViewItemAnimationFade];
    [self updateBgView];
    [self.shelfEntity save];
}

-(void) reloadDataFromFile
{
    
}

-(void) removeBlockHandle
{
    [self.alertView setHandlerBlock:nil];
}

-(void) reload
{
    [self.gridView reloadData];
    [self updateBgView];
    [self.gridView sendSubviewToBack:self.bgView];
}

- (void)dealloc
{
    [self.alertView removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.bgView release];
    [super dealloc];
}
@end
