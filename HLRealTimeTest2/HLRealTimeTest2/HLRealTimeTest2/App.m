//
//  App.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "App.h"
#import "ViewController.h"

@implementation App

@synthesize rootViewController;

static App *app;

+(App *) instance
{
    if (app != nil)
    {
        return app;
    }
    else
    {
        app = [[App alloc] init];
        return app;
    }
}

-(HeaderViewController *) getHeaderViewController
{
    if (headerViewController == nil)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0 )
            {
                headerViewController = [[HeaderViewController alloc] initWithNibName:@"HeaderViewController_iphone_iOS7" bundle:nil] ;
            }
            else
            {
                headerViewController = [[HeaderViewController alloc] initWithNibName:@"HeaderViewController_iPhone" bundle:nil] ;
            }

        }
        else
        {
            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
            {
                headerViewController = [[HeaderViewController alloc] initWithNibName:@"HeaderViewController_iOS7" bundle:nil];
            }
            else
            {
                headerViewController = [[HeaderViewController alloc] initWithNibName:@"HeaderViewController" bundle:nil] ;
            }
        }
    }
    return headerViewController;
}

-(ShelfViewController  *) getShelfViewController
{
    if (shelfViewController == nil)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            shelfViewController = [[ShelfViewController alloc] initWithNibName:@"ShelfViewController_iPhone" bundle:nil];
        }
        else
        {
            shelfViewController = [[ShelfViewController alloc] initWithNibName:@"ShelfViewController" bundle:nil];

        }
    }
    return shelfViewController;
}

-(DownloadQueue*) getDownloadQueue
{
    if (downloadQueue == nil)
    {
        downloadQueue = [[DownloadQueue alloc] init];
    }
    return downloadQueue;
}

-(appMaker *) getAppMaker
{
    if (apBook == nil)
    {
        apBook = [[appMaker alloc] init];
    }
    return apBook;
}

-(ShelfEntity*) getShelfEntity
{
    if (shelfEntity == nil)
    {
        shelfEntity = [[ShelfEntity alloc] init];
    }
    return shelfEntity;
}

-(void) closeShelf
{
    for (int i = 0; i < [shelfEntity.books count]; i++)
    {
        ShelfBookEntity *entity = [shelfEntity.books objectAtIndex:i];
        entity.cell = nil;
    }
    [shelfViewController.alertView setHandlerBlock:nil];
    [shelfViewController dismissViewControllerAnimated:NO completion:nil];
    [shelfViewController release];
    shelfViewController = nil;
    [headerViewController release];
    headerViewController = nil;
}
@end
