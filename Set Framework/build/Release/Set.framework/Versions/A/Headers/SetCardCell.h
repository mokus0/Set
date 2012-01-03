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
}

- (id) initImageCell: (NSImage *) img;
- (NSCellType) type;

- (id) initWithCard: (SetCard *) _card;

- (void) setObjectValue: (SetCard *) newCard;

- (void) setCard: (SetCard *) _card;
- (SetCard *) card;

- (void) drawInteriorWithFrame: (NSRect) frame inView: (NSView *) view;

@end
