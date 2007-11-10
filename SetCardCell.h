//
//  SetCardCell.h
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SetMatrix;
@class SetCard;

@interface SetCardCell : NSButtonCell {
	SetCard *card;
	
		/* used only to tell the matrix when we are selected */
		/*		-- does not retain */
	SetMatrix *field;
	unsigned int row;
	unsigned int col;
}

- (id) initImageCell: (NSImage *) img;
- (NSCellType) type;

- (id) initWithCard: (SetCard *) _card;

- (void) setObjectValue: (SetCard *) newCard;

- (void) setCard: (SetCard *) _card;
- (SetCard *) card;

- (void) setField: (SetMatrix *) _field row: (unsigned int) _row column: (unsigned int) _col;

- (BOOL) isEnabled;
- (void) setState: (int) state;

- (void) drawInteriorWithFrame: (NSRect) frame inView: (NSView *) view;
- (void) drawCardBackWithFrame: (NSRect) frame;

@end
