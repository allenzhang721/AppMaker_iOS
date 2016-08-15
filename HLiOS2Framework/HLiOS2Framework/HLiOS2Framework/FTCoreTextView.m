//
//  FTCoreTextView.m
//  FTCoreText
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTCoreTextView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "HLCoreTextNode.h"

#define SYSTEM_VERSION_LESS_THAN(v)			([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


NSString * const FTCoreTextTagDefault = @"_default";
NSString * const FTCoreTextTagImage = @"_image";
NSString * const FTCoreTextTagBullet = @"_bullet";
NSString * const FTCoreTextTagPage = @"_page";
NSString * const FTCoreTextTagLink = @"_link";

NSString * const FTCoreTextDataURL = @"url";
NSString * const FTCoreTextDataName = @"FTCoreTextDataName";
NSString * const FTCoreTextDataFrame = @"FTCoreTextDataFrame";
NSString * const FTCoreTextDataAttributes = @"FTCoreTextDataAttributes";

typedef enum {
	FTCoreTextTagTypeOpen,
	FTCoreTextTagTypeClose,
	FTCoreTextTagTypeSelfClose
} FTCoreTextTagType;

@interface FTCoreTextView ()

@property (nonatomic, assign) CTFramesetterRef framesetter;
@property (nonatomic, retain) HLCoreTextNode *rootNode;

@end

@implementation FTCoreTextView

@synthesize text = _text;
@synthesize processedString = _processedString;
@synthesize path = _path;
@synthesize URLs = _URLs;
@synthesize images = _images;
@synthesize delegate = _delegate;
@synthesize framesetter = _framesetter;
@synthesize rootNode = _rootNode;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize attributedString = _attributedString;


CTFontRef CTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName, 
                                            font.pointSize, 
                                            NULL);
    return ctFont;
}

#pragma mark - FTCoreTextView business
#pragma mark -

- (void)didMakeChanges
{
	_coreTextViewFlags.updatedAttrString = NO;
	_coreTextViewFlags.updatedFramesetter = NO;
}

#pragma mark - UI related

- (NSDictionary *)dataForPoint:(CGPoint)point
{
	NSMutableDictionary *returnedDict = [NSMutableDictionary dictionary];
	
	CGMutablePathRef mainPath = CGPathCreateMutable();
    if (!_path) {
        CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));  
    }
    else {
        CGPathAddPath(mainPath, NULL, _path);
    }
	
    CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
    CGPathRelease(mainPath);
	
    NSArray *lines = (NSArray *)CTFrameGetLines(ctframe);
    NSInteger lineCount = [lines count];
    CGPoint origins[lineCount];
    
    if (lineCount != 0) {
		
		CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
		
		for (int i = 0; i < lineCount; i++) {
			CGPoint baselineOrigin = origins[i];
			//the view is inverted, the y origin of the baseline is upside down
			baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
			
			CTLineRef line = (CTLineRef)[lines objectAtIndex:i];
			CGFloat ascent, descent;
			CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
			
			CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
			
			if (CGRectContainsPoint(lineFrame, point)) {
				//we look if the position of the touch is correct on the line
				
				CFIndex index = CTLineGetStringIndexForPosition(line, point);

				NSArray *urlsKeys = [_URLs allKeys];
				
				for (NSString *key in urlsKeys) {
					NSRange range = NSRangeFromString(key);
					if (index >= range.location && index < range.location + range.length) {
						NSURL *url = [_URLs objectForKey:key];
						if (url) [returnedDict setObject:url forKey:FTCoreTextDataURL];
						break;
					}
				}
			
                //frame
                CFArrayRef runs = CTLineGetGlyphRuns(line);
                for(CFIndex j = 0; j < CFArrayGetCount(runs); j++) {
                    CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                    NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
                    
                    NSString *name = [attributes objectForKey:FTCoreTextDataName];
                    if (![name isEqualToString:@"_link"]) continue;
                    
                    [returnedDict setObject:attributes forKey:FTCoreTextDataAttributes];
                    
                    CGRect runBounds;
                    runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                    runBounds.size.height = ascent + descent;
                    
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                    runBounds.origin.x = baselineOrigin.x + self.frame.origin.x + xOffset + 0;
                    runBounds.origin.y = baselineOrigin.y + lineFrame.size.height - ascent; 
                    
                    [returnedDict setObject:NSStringFromCGRect(runBounds) forKey:FTCoreTextDataFrame];
                    
                }
            }
			if (returnedDict.count > 0) break;
		}
	}
	CFRelease(ctframe);
	return returnedDict;
}

- (void)updateFramesetterIfNeeded
{
    if (!_coreTextViewFlags.updatedAttrString) {
		if (_framesetter != NULL) CFRelease(_framesetter);
		_framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
		_coreTextViewFlags.updatedAttrString = YES;
    }
}

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size
{
	CGSize suggestedSize;
		[self updateFramesetterIfNeeded];
		if (_framesetter == NULL) {
			return CGSizeZero;
		}
		suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, CFRangeMake(0, 0), NULL, size, NULL);
		suggestedSize = CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));

    return suggestedSize;
}

/*!
 * @abstract handy method to fit to the suggested height in one call
 *
 */

- (void)fitToSuggestedHeight
{
	CGSize suggestedSize = [self suggestedSizeConstrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
	CGRect viewFrame = self.frame;
	viewFrame.size.height = suggestedSize.height;
	self.frame = viewFrame;
}

- (void)applyStyle:(HLCoreTextNode *)node inRange:(NSRange)styleRange onString:(NSMutableAttributedString **)attributedString
{
//    [*attributedString addAttribute:(id)FTCoreTextDataName
//							  value:(id)style.name
//							  range:styleRange];
//    [*attributedString addAttribute:(id)kCTVerticalFormsAttributeName
//							  value:(id)[NSNumber numberWithBool:YES]
//							  range:styleRange];
	[*attributedString addAttribute:(id)kCTForegroundColorAttributeName
							  value:(id)node.color.CGColor
							  range:styleRange];
    
    
	if (node.isUnderLine)
    {
		NSNumber *underline = [NSNumber numberWithInt:kCTUnderlineStyleSingle];
		[*attributedString addAttribute:(id)kCTUnderlineStyleAttributeName
								  value:(id)underline
								  range:styleRange];
	}	
	
	CTFontRef ctFont = CTFontCreateFromUIFont(node.font);
	
	[*attributedString addAttribute:(id)kCTFontAttributeName
							  value:(id)ctFont
							  range:styleRange];
	CFRelease(ctFont);
	
	CTTextAlignment alignment = node.alignment;
//	CGFloat maxLineHeight = style.maxLineHeight;
//	CGFloat minLineHeight = style.minLineHeight;
//	CGFloat paragraphLeading = style.leading;
	
//	CGFloat paragraphSpacingBefore = 0;//style.paragraphInset.top;
//	CGFloat paragraphSpacingAfter = style.paragraphInset.bottom;
//	CGFloat paragraphFirstLineHeadIntent = style.paragraphInset.left;
//	CGFloat paragraphHeadIntent = style.paragraphInset.left;
//	CGFloat paragraphTailIntent = style.paragraphInset.right;
	
	//if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
//	paragraphSpacingBefore = 0;
	//}
	
	CFIndex numberOfSettings = 1;
//	CGFloat tabSpacing = 28.f;
	
//	BOOL applyParagraphStyling = style.applyParagraphStyling;
//	
//	if ([style.name isEqualToString:[self defaultTagNameForKey:FTCoreTextTagBullet]]) {
//		applyParagraphStyling = YES;
//	}
//	else if ([style.name isEqualToString:@"_FTBulletStyle"]) {
//		applyParagraphStyling = YES;
//		numberOfSettings++;
//		tabSpacing = style.paragraphInset.right;
//		paragraphSpacingBefore = 0;
//		paragraphSpacingAfter = 0;
//		paragraphFirstLineHeadIntent = 0;
//		paragraphTailIntent = 0;
//	}
//	else if ([style.name hasPrefix:@"_FTTopSpacingStyle"]) {
//		[*attributedString removeAttribute:(id)kCTParagraphStyleAttributeName range:styleRange];
//	}
//	
//	if (applyParagraphStyling) {
//		
//		CTTextTabRef tabArray[] = { CTTextTabCreate(0, tabSpacing, NULL) };
//		
//		CFArrayRef tabStops = CFArrayCreate( kCFAllocatorDefault, (const void**) tabArray, 1, &kCFTypeArrayCallBacks );
//		CFRelease(tabArray[0]);
//		
		CTParagraphStyleSetting settings[] = {
			{kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
//			{kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
//			{kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight},
//			{kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
//			{kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacingAfter},
//			{kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &paragraphFirstLineHeadIntent},
//			{kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &paragraphHeadIntent},
//			{kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &paragraphTailIntent},
//			{kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &paragraphLeading},
//			{kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStops}//always at the end
		};
		
		CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, numberOfSettings);
		[*attributedString addAttribute:(id)kCTParagraphStyleAttributeName
								  value:(id)paragraphStyle
								  range:styleRange];
//		CFRelease(tabStops);
		CFRelease(paragraphStyle);
//	}
}

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andAttributedString:nil];
}

- (id)initWithFrame:(CGRect)frame andAttributedString:(NSAttributedString *)attributedString
{
	self = [super initWithFrame:frame];
	if (self) {
		_attributedString = [attributedString retain];
		[self doInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
	_framesetter = NULL;
	_URLs = [[NSMutableDictionary alloc] init];
    _images = [[NSMutableArray alloc] init];
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.contentMode = UIViewContentModeRedraw;
	[self setUserInteractionEnabled:YES];
}

- (void)dealloc
{
	if (_framesetter) CFRelease(_framesetter);
	if (_path) CGPathRelease(_path);
	[_rootNode release];
    [_nodeArray release];
    [_text release];
    [_processedString release];
    [_URLs release];
    [_images release];
	[_shadowColor release];
	[_attributedString release];
    [super dealloc];
}

#pragma mark - Custom Setters

- (void)setNodeArray:(NSArray *)nodeArray
{
    [_nodeArray release];
    _nodeArray = [nodeArray retain];
    _coreTextViewFlags.textChangesMade = YES;
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [_text release];
    _text = [text retain];
	_coreTextViewFlags.textChangesMade = YES;
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)setPath:(CGPathRef)path
{
    _path = CGPathRetain(path);
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)setShadowColor:(UIColor *)shadowColor
{
	[_shadowColor release];
	_shadowColor = [shadowColor retain];
	if ([self superview]) [self setNeedsDisplay];
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
	_shadowOffset = shadowOffset;
	if ([self superview]) [self setNeedsDisplay];
}

#pragma mark - Custom Getters

- (NSAttributedString *)attributedString
{
	if (!_coreTextViewFlags.updatedAttrString) {
		_coreTextViewFlags.updatedAttrString = YES;
		
		if (_processedString == nil || _coreTextViewFlags.textChangesMade) {
			_coreTextViewFlags.textChangesMade = NO;
            
            NSMutableString *string = [NSMutableString string];
			for (int i = 0; i < _nodeArray.count; i++)
            {
                HLCoreTextNode *node = [_nodeArray objectAtIndex:i];
                
                string = [NSMutableString stringWithFormat:@"%@", [string stringByAppendingString:node.text]];
            }
            self.processedString = string;
		}
		
		if (_processedString) {
			
			NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_processedString];
			
            int loc = 0;
            for (int i = 0; i < _nodeArray.count; i++)
            {
                HLCoreTextNode *node = [_nodeArray objectAtIndex:i];
                NSRange range = NSMakeRange(loc, node.text.length);
                [self applyStyle:node inRange:range onString:&string];
                loc += range.length;
            }
			
			[_attributedString release];
			_attributedString = string;
		}
	}
	return _attributedString;
}

#pragma mark - View lifecycle

/*!
 * @abstract draw the actual coretext on the context
 *
 */

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self.backgroundColor setFill];
	CGContextFillRect(context, rect);
	
    [self updateFramesetterIfNeeded];
    
    CGMutablePathRef mainPath = CGPathCreateMutable();
    
    if (!_path) {
        CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    }
    else {
        CGPathAddPath(mainPath, NULL, _path);
    }
    
    CTFrameRef drawFrame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
    
    if (drawFrame == NULL) {
        NSLog(@"FTCoreText unable to render: %@", self.processedString);
    }
    else {
        
        if (_shadowColor) {
            CGContextSetShadowWithColor(context, _shadowOffset, 0.f, _shadowColor.CGColor);
        }
        
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        // draw text
        CTFrameDraw(drawFrame, context);
    }
    // cleanup
    if (drawFrame) CFRelease(drawFrame);
    CGPathRelease(mainPath);
}

#pragma mark User Interaction

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
		if (self.delegate && ([self.delegate respondsToSelector:@selector(touchedData:inCoreTextView:)] || [self.delegate respondsToSelector:@selector(coreTextView:receivedTouchOnData:)])) {
			CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
			NSDictionary *data = [self dataForPoint:point];
			if (data) {
				if ([self.delegate respondsToSelector:@selector(coreTextView:receivedTouchOnData:)]) {
					[self.delegate coreTextView:self receivedTouchOnData:data];
				}
				else {
					if ([self.delegate respondsToSelector:@selector(touchedData:inCoreTextView:)]) {
						[self.delegate touchedData:data inCoreTextView:self];
					}
				}
			}
		}
}

@end

