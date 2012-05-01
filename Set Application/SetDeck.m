//
//  SetDeck.m
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

	/* .-====== Primary headers =======-. */
#import "SetDeck.h"

	/* .-===== Secondary headers ======-. */
#import "setConstants.h"
#import "setEnums.h"
#import "setDefaults.h"
#import "SetCard.h"
#import "SetMatrix.h"
#import "dbRandomGenerator.h"



	/* .-====== Local Prototypes ======-. */
static inline unsigned int numElements(BOOL *array);
static inline BOOL cardAllowed(SetCard *card, BOOL enabled[SetAttributeCount][SetCardsPerSet]);
static NSInteger shuffleSort(id a, id b, int *r);



	/* .-==== Class Implementation ====-. */
@implementation SetDeck

- (id) init {
	self = [super init];
	if (self) {
		cards = nil;
		field = nil;
		
		[self reset];
		
		if (cards == nil) self = nil;
	}
	return self;
}

- (NSString *) description {
	unsigned int cardsLeft = [self cardsLeft];
	NSEnumerator *i;
	SetCard *card;
	
	NSMutableString *descr = [NSMutableString stringWithFormat:
			@"<SetDeck: 0x%08x (%u/%u cards%@)>",
				self,
				cardsLeft,
				[self cardsInFullDeck],
				autoRedeal ? @" - autoRedeal ON" : @""
		];
	
	i = [cards objectEnumerator];
	card = [i nextObject];
	
	return descr;
}

- (NSMutableArray *) fullDeck {
	NSMutableArray *deck = [[NSMutableArray alloc] init];
	unsigned int decksLeft;
	
	decksLeft = numDecks;
	
	while(decksLeft--) {
		SetCard *card;
		
		card = [SetCard deckFirstCard];
		
		while (card) {
			if (cardAllowed(card, enabled))
				[deck addObject: card];
			
			card = [SetCard deckCardAfter: card];
		}
	}
	
	return deck;
}

- (SetCard *) next {
	SetCard * card = nil;
	
	if (numDecks > 0) {
		card = [cards lastObject];
		
		if (card) {
			[cards removeLastObject];
		} else {
			card = [self autoRedeal];
		}
	} else {
		card = [self dealRandomCard];
	}
	
	return card;
}

- (unsigned int) cardsLeft {
	if (numDecks == 0)
		return [self cardsInFullDeck];
	
	if (autoRedeal)
		return [self numCardsNotInPlay];
	
	return [cards count];
}

- (unsigned int) cardsInFullDeck {
	unsigned int i;
	unsigned int num = numDecks;
	
	if (numDecks == 0)
		return (unsigned int) -1;   /* practical infinity */
	
	for (i = 0; i < SetAttributeCount; i++) {
		num *= numElements(enabled[i]);
	}
	
	return num;
}

- (unsigned int) numCardsNotInPlay {
	NSArray *cardsInPlay = [self cardsInPlay];
	unsigned int numCards = [self cardsInFullDeck];
	
	return numCards - [cardsInPlay count];
}

- (void) attachToPlayingField: (SetMatrix *) _field {
	ifClass (_field, SetMatrix)
		field = _field;
}

- (NSArray *) cardsNotInPlay {
	NSArray *cardsInPlay = [self cardsInPlay];
	NSMutableArray *fullDeck = [self fullDeck];
	
	[fullDeck removeObjectsInArray: cardsInPlay];
	
	return fullDeck;
}

- (NSArray *) cardsInPlay {
	if (field)
		return [field cardsInPlay];
	else
		return [NSArray array];
}

- (void) loadPrefs {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *numDecksNS = [defaults objectForKey: SetPrefs_decks];
	NSNumber *autoRedealNS = [defaults objectForKey: SetPrefs_dealContinuous];
	NSNumber *zeroDeckNS = [defaults objectForKey: SetPrefs_dealRandom];
	
	BOOL zeroDeck = FALSE;
	
	numDecks = 1;
	autoRedeal = FALSE;
	
	ifClass(zeroDeckNS, NSNumber)
		zeroDeck = [zeroDeckNS boolValue];
	
	if (zeroDeck) {
		numDecks = 0;
		autoRedeal = FALSE;
	} else {
		ifClass(numDecksNS, NSNumber)
			numDecks = [numDecksNS unsignedIntValue];
		ifClass(autoRedealNS, NSNumber)
			autoRedeal = [autoRedealNS boolValue];
	}
	
	[self loadEnabledMap];
}

- (void) loadEnabledMap {
	static NSString *sourceKeys[SetAttributeCount] = {
			SetPrefs_deckShapes,
			SetPrefs_deckColors,
			SetPrefs_deckNumbers,
			SetPrefs_deckFills
		};
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	unsigned int i, j;
	
	for (i = 0; i < SetAttributeCount; i++) {
		NSArray *row = [defaults objectForKey: sourceKeys[i]];
		
		if((! isClass(row, NSArray)) || ([row count]) > SetCardsPerSet)
			row = nil;
		
		for (j = 0; j < SetCardsPerSet; j++) {
			enabled[i][j] = TRUE;
			
			if (row) {
				NSNumber *value = [row objectAtIndex: j];
				ifClass (value, NSNumber)
					enabled[i][j] = [value boolValue];
			}
		}
	}
}

- (void) reset {
	NSMutableArray *oldDeck = cards;
	
	[self loadPrefs];
	
	cards = [self fullDeck];
	[oldDeck release];
}

- (void) shuffle {
	int numCards = [cards count];
	int shuffleCount = numCards * numCards;
	NSArray *newDeck;
	NSMutableArray *oldDeck = cards;
	
	newDeck = [cards sortedArrayUsingFunction: (NSInteger (*)(id, id, void *)) shuffleSort context: &shuffleCount];
	
	cards = [newDeck mutableCopy];
	[oldDeck release];
}

- (SetCard *) autoRedeal {
	SetCard *card;
	
	cards = [[self cardsNotInPlay] mutableCopy];
	
	[self shuffle];
	
	card = [cards lastObject];
	if (card)
		[cards removeLastObject];
	
	return card;
}

- (SetCard *) dealRandomCard {
	dbRandomGenerator *rand = (dbRandomGenerator *) [dbRandomGenerator sharedInstance];
	SetCard *card = nil;
	
	do {
		card = [[SetCard alloc] initWithShape: ([rand random] % SetCardsPerSet)
				color:		([rand random] % SetCardsPerSet)
				number:		([rand random] % SetCardsPerSet)
				fill:		([rand random] % SetCardsPerSet)
			];
		
		[card autorelease];
	} while (! cardAllowed(card, enabled));
	
	return card;
}

@end



	/* .-====== Local Functions =======-. */
static inline unsigned int numElements(BOOL *array) {
	unsigned int i;
	unsigned int num = 0;
	
	for (i = 0; i < SetCardsPerSet; i++) {
		if (array[i]) {
			num++;
		}
	}
	
	return num;
}

static inline BOOL cardAllowed(SetCard *card, BOOL enabled[SetAttributeCount][SetCardsPerSet]) {
	if (! enabled[Shape][[card shape]])
		return FALSE;
	
	if (! enabled[Color][[card color]])
		return FALSE;
	
	if (! enabled[Number][[card number]])
		return FALSE;
	
	if (! enabled[Fill][[card fill]])
		return FALSE;
	
	return TRUE;
}

static NSInteger shuffleSort(id a, id b, int *shuffleCount)
{
	dbRandomGenerator *rand = (dbRandomGenerator *) [dbRandomGenerator sharedInstance];
	
	if (*shuffleCount == 0)
		return NSOrderedAscending;
	*shuffleCount -= 1;
	
	if ([rand random] & 0x01)
        return NSOrderedAscending;
    else
		return NSOrderedDescending;
}

