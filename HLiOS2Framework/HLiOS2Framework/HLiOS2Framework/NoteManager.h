//
//  NoteManager.h
//  MoueePDFViewer
//
//  Created by Mouee-iMac on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NoteManager : NSObject

@property(nonatomic, retain) NSString *pageid;
@property(nonatomic, readonly) NSMutableDictionary *notesArray;
@property(nonatomic, retain) NSMutableDictionary *noteBtnDic;
@property(nonatomic, readonly) NSMutableDictionary *rangeDic;
@property(nonatomic, retain) NSString *rootPath;

-(id)initWithId:(NSString *)pageId rootPath:(NSString*)path;
-(void)save;
-(int)addNote:(NSString *)text atPos:(CGPoint)pos withRange:(NSString *)rangeStr;
-(void)removeNote:(NSInteger)noteId;

-(void)saveNote:(int)noteid withText:(NSString *)text;
-(NSString *)getNoteText:(int)noteid;

@end


@interface NoteButton : UIButton

@end