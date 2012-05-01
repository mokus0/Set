#import "SetCardCell.h"

#import "SetConstants.h"
#import "SetFunctions.h"
#import "SetCard.h"

@implementation SetCardCell

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
	
	[super setObjectValue: newCard];
}

- (void) setCard: (SetCard *) _card {
	[self setObjectValue: _card];
	[self setState: NSOffState];
}

- (SetCard *) card {
	return card;
}

- (void) drawInteriorWithFrame: (NSRect) frame inView: (NSView *) view {
	if (card == nil) {
		[SetCard drawCardBackWithFrame: frame];
	} else {
		float insetW = 2.0 + SetShapeInsetW * NSWidth(frame);
		float insetH = 2.0 + SetShapeInsetH * NSHeight(frame);
		
		frame = NSInsetRect(frame, insetW, insetH);
		
		[card drawInRect: frame];
	}
}

@end
