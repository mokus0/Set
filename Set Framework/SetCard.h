#import <Foundation/Foundation.h>

#import "SetConstants.h"
#import "SetEnums.h"

@interface SetCard : NSObject <NSCopying> {
	SetShape	shape;
	SetColor	color;
	SetNumber   number;
	SetFill		fill;
}

+ (void) setCardColors;
+ (void) setFailsafeColors;

+ (void) drawCardBackWithFrame: (NSRect) frame;

+ (SetCard *) deckFirstCard;
+ (SetCard *) deckCardAfter: (SetCard *) card;

- (id) init;
- (id) initWithShape: (SetShape) s color: (SetColor) c number: (SetNumber) n fill: (SetFill) f;

- (BOOL) isEqual: (id) other;
- (unsigned int) hash;
- (NSString *) description;

- (SetShape) shape;
- (SetColor) color;
- (SetNumber) number;
- (SetFill) fill;

- (void) drawInRect: (NSRect) frame;

- (id) copyWithZone: (NSZone *) zone;

@end
