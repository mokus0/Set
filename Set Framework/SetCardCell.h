//
//  SetCardCell.h
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SetCard;

@interface SetCardCell : NSButtonCell {
	SetCard *card;
	
	unsigned int row;
	unsigned int col;
}

- (id) initImageCell: (NSImage *) img;
- (NSCellType) type;

- (id) initWithCard: (SetCard *) _card;

- (void) setObjectValue: (SetCard *) newCard;

- (void) setCard: (SetCard *) _card;
- (SetCard *) card;

- (BOOL) isEnabled;

- (void) drawInteriorWithFrame: (NSRect) frame inView: (NSView *) view;
- (void) drawCardBackWithFrame: (NSRect) frame;

@end
