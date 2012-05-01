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
