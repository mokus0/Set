//
//  SetCardCell.m
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

	/* .-====== Primary headers =======-. */
#import "SetCardCell.h"

	/* .-===== Secondary headers ======-. */
#import "SetConstants.h"
#import "SetFunctions.h"
#import "SetCard.h"

	/* .-======== Local Data ==========-. */
static NSColor *cardBackColor = nil;
static NSImage *cardBack = nil;
static NSSize cardBackSize = {0.0, 0.0};


	/* .-==== Class Implementation ====-. */
@implementation SetCardCell

+ (void)initialize {
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSString *cardBackPath = [mainBundle pathForResource: @"cardBack" ofType: @"tiff"];
	
	if (cardBackPath)
		cardBack = [[NSImage alloc] initWithContentsOfFile: cardBackPath];
	else
		NSLog(@"SetCardCell: Failed to locate card back image");
	
	[cardBack setScalesWhenResized: TRUE];
	[cardBack setFlipped: TRUE];
	
	cardBackSize = [cardBack size];
	
	cardBackColor = [NSColor colorWithCalibratedHue: (280.0 / 360) saturation: 1.0 brightness: (60.0/100) alpha: 1.0];
	[cardBackColor retain];
}

- (id) initImageCell: (NSImage *) img {
	self = [super initImageCell: img];
	if (self) {
		card = nil;
	}
	return self;
}

- (NSCellType) type { return NSImageCellType; }


- (id) initWithCard: (SetCard *) _card {
	self = [super initImageCell: nil];
	if (self) {
		card = [_card copy];
	}
	return self;
}

- (void) awakeFromNib {
	card = nil;
}

- (void) setObjectValue: (SetCard *) newCard {
	card = newCard;
}

- (void) setCard: (SetCard *) _card {
	[self setObjectValue: _card];
	[self setState: NSOffState];
}

- (SetCard *) card {
	return card;
}

- (BOOL) isEnabled {
	return card ? TRUE : FALSE;
}

- (void) drawInteriorWithFrame: (NSRect) frame inView: (NSView *) view {
	if (card == nil) {
		[self drawCardBackWithFrame: frame];
	} else {
		float insetW = 2.0 + SetShapeInsetW * NSWidth(frame);
		float insetH = 2.0 + SetShapeInsetH * NSHeight(frame);
		
		frame = NSInsetRect(frame, insetW, insetH);
		
		[card drawInRect: frame];
	}
}

- (void) drawCardBackWithFrame: (NSRect) frame {
	NSRect imgSrc = NSMakeRect(0, 0, cardBackSize.width, cardBackSize.height);
	NSRect imgDst = NSInsetRect(frame, 2.0, 2.0);
	
	imgSrc = proportionalRectToRect(imgSrc, imgDst);
	[cardBackColor set];
	[NSBezierPath fillRect: imgDst];
	
	[cardBack drawInRect:	imgDst
			fromRect:   imgSrc
			operation:  NSCompositeCopy
			fraction:   1.0
		];
}

@end
