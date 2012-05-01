//
//  SetMatrix.m
//  Set
//
//  Created by mokus on Mon Mar 28 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

	/* .-====== Primary headers =======-. */
#import "SetMatrix.h"

	/* .-===== Secondary headers ======-. */
#import "SetDefaults.h"
#import "SetFunctions.h"
#import "SetCardCell.h"
#import "SetCard.h"


	/* .-========= Local Data =========-. */
static NSString *qwerty[SetMaxRows][SetMaxCols] = {
	{@"q", @"w", @"e", @"r", @"t", @"y", @"u"},
	{@"a", @"s", @"d", @"f", @"g", @"h", @"j"},
	{@"z", @"x", @"c", @"v", @"b", @"n", @"m"}
};

static NSString *dvorak[SetMaxRows][SetMaxCols] = {
	{@"'", @",", @".", @"p", @"y", @"f", @"g"},
	{@"a",  @"o", @"e", @"u", @"i", @"d", @"h"},
	{@";",  @"q", @"j", @"k", @"x", @"b", @"m"}
};



	/* .-====== Local Prototypes ======-. */
static inline unsigned int cardNum(unsigned int row, unsigned int col);
static inline unsigned int cardRow(unsigned int num);
static inline unsigned int cardCol(unsigned int num);



	/* .-==== Handy Little Macros =====-. */
#define cardExists(num)		([cells[num] card] ? TRUE : FALSE)
#define cardFree(num)		(! cardExists(num))



	/* .-==== Class Implementation ====-. */
@implementation SetMatrix

- (void) awakeFromNib {
	selection = [[NSMutableArray alloc] init];
	limitSelection = TRUE;
	
	[self loadPrefs];
}

- (void) loadPrefs {
	[self loadGamePrefs];
	[self loadLivePrefs];
}

- (void) loadLivePrefs {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSNumber *limitSelectionNS = [defaults objectForKey: SetPrefs_limitSelection];
	NSNumber *minColsVisibleNS = [defaults objectForKey: SetPrefs_colsToShow];
	
	ifClass (limitSelectionNS, NSNumber)
		limitSelection = [limitSelectionNS boolValue];
	
	ifClass (minColsVisibleNS, NSNumber)
		minColsVisible = [minColsVisibleNS unsignedIntValue];
	
	[self applyKeymap];
}

- (void) loadGamePrefs {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSNumber *colsToDealNS = [defaults objectForKey: SetPrefs_colsToDeal];
	
	ifClass (colsToDealNS, NSNumber)
		colsToDeal = [colsToDealNS unsignedIntValue];
	else
		colsToDeal = 4;
}

- (void) initCells {
	int i, j;
	SetCardCell *template = [self cellAtRow:0 column: 0];
	
	cardsDealt = 0;
	mightBeSparse = FALSE;
	
	for (j = 0; j < SetMaxCols; j++) {
		for (i = 0; i < SetMaxRows; i++) {
			cells[cardNum(i,j)] = [template copy];
			
			[cells[cardNum(i,j)] setCard: nil];
			[cells[cardNum(i,j)] setField: self row: i column: j];
			
			[self putCell: cells[cardNum(i,j)] atRow: i column: j];
		}
	}
	
	[self applyKeymap];
	
	[self resizeDisplay];
}

- (void) resetCells {
	int n;
	
	[self loadPrefs];
	
	cardsDealt = 0;
	mightBeSparse = FALSE;
	
	for (n = 0; n < SetMaxCards; n++) {
			[cells[n] setCard: nil];
	}
}


- (unsigned int) maxRows {
	return SetMaxRows;
}

- (unsigned int) maxCols {
	return SetMaxCols;
}


- (unsigned int) colsToDeal {
	return colsToDeal;
}

- (void) setColsToDeal: (unsigned int) cols {
	colsToDeal = cols;
}

- (unsigned int) colsDealt {
	return cardsDealt / SetMaxRows;
}

- (unsigned int) colsVisible {
	[self getNumberOfRows: NULL columns: (NSInteger *)&colsVisible];
	
	return colsVisible;
}

- (unsigned int) displayColsNeeded {
	unsigned int colsNeeded = 0;
	
	if (cardsDealt > 0)
		colsNeeded = (cardsDealt - 1) / SetMaxRows + 1;
	
	if (colsNeeded < minColsVisible)
		return minColsVisible;
	
	return colsNeeded;
}

- (void) resizeDisplay {
	unsigned int colsNeeded = [self displayColsNeeded];
	
	if ([self colsVisible] != colsNeeded) {
		[self resizeDisplay: colsNeeded];
	}
}

- (void) resizeDisplay:  (unsigned int) cols {
	unsigned int cellsVisible = cols * SetMaxRows;
	unsigned int n;
	NSRect frame;
	
	[self renewRows: SetMaxRows columns: cols];
	
	for (n = 0; n < cellsVisible; n++) {
		[self putCell: cells[n] atRow: cardRow(n) column: cardCol(n)];
	}
	
		/* Ewww... */
	frame = [self frame];
	
	frame.size.width += 1;
	[self setFrame: frame];
	
	frame.size.width -= 1;
	[self setFrame: frame];
	
	[self setNeedsDisplay: TRUE];
}

- (SetCard *) cardAtRow: (unsigned int) row column: (unsigned int) col {
	if ((row >= SetMaxRows) || (col >= SetMaxCols))
		return nil;
	
	return [cells[cardNum(row, col)] card];
}

- (void) setCard: (SetCard *) card atRow: (unsigned int) row column: (unsigned int) col {
	if ((row >= SetMaxRows) || (col >= SetMaxCols))
		return;
	
	[cells[cardNum(row, col)] setCard: card];
	
	if (card == nil)
		mightBeSparse = TRUE;
}


- (void) applyKeymap {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *keymapNS = [defaults objectForKey: SetPrefs_keymap];
	keymap = &qwerty;
	
	ifClass(keymapNS, NSString) {
		if ([keymapNS caseInsensitiveCompare: SetPrefs_keymap_dv] == NSOrderedSame)
			keymap = &dvorak;
		
		if ([keymapNS caseInsensitiveCompare: SetPrefs_keymap_qw] == NSOrderedSame)
			keymap = &qwerty;
	}
	
	int i, j;
	
	for (j = 0; j < SetMaxCols; j++) {
		for (i = 0; i < SetMaxRows; i++) {
			[cells[cardNum(i,j)] setKeyEquivalent: (*keymap)[i][j]];
		}
	}
}

- (IBAction) setDvorak: (id) sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: SetPrefs_keymap_dv forKey: SetPrefs_keymap];
	
	[self applyKeymap];
}

- (IBAction) setQwerty: (id) sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: SetPrefs_keymap_qw forKey: SetPrefs_keymap];
	
	[self applyKeymap];
}

- (IBAction) toggleDvQw: (NSMenuItem *) sender {
	if (keymap != &qwerty) {
		[self setQwerty: sender];
		[sender setTitle: @"Dvorak"];
	} else {
		[self setDvorak: sender];
		[sender setTitle: @"Qwerty"];
	}
}


- (void) selectSetCardCell: (SetCardCell *) cell {
	if ([selection containsObject: cell])
		[selection removeObject: cell];
	
	if (limitSelection && ([selection count] >= SetMaxSelected)) {
		SetCardCell *removed = [selection objectAtIndex: 0];
		[selection removeObjectAtIndex: 0];
		
		[removed setState: NSOffState];
	}
	
	[selection addObject: cell];
}

- (void) deselectSetCardCell: (SetCardCell *) cell {
	[selection removeObject: cell];
}

- (void) removeSelection {
	SetCardCell *cell;
	
	while ((cell = [selection lastObject])) {
		[cell setCard: nil];
	}
	
	mightBeSparse = TRUE;
}


- (BOOL) fullSelection {
	return ([selection count] == SetMaxSelected);
}

- (unsigned int) cardsSelected {
	return [selection count];
}

- (SetCard *) selected: (unsigned int) num {
	if (num >= [selection count]) return nil;
	
	return [(SetCardCell *) [selection objectAtIndex: num] card];
}

- (void) deselectAllSetCardCells {
	SetCardCell *cell;
	
	while ([selection count] && (cell = [selection objectAtIndex: 0])) {
		[cell setState: NSOffState];
	}
}

- (BOOL) selectCard: (SetCard *) card {
	unsigned int n;
	
	for (n = 0; n < cardsDealt; n++) {
		if ([card isEqual: [cells[n] card]]) {
			[cells[n] setState: NSOnState];
			return TRUE;
		}
	}
	
	return FALSE;
}

- (NSSet *) selectedCards {
	NSEnumerator *cellEnum;
	SetCardCell *cell;
	
	NSMutableSet *result = [NSMutableSet set];
	
	cellEnum = [selection objectEnumerator];
	while (cell = [cellEnum nextObject]) {
		SetCard *card = [cell card];
		
		if (card)
			[result addObject: card];
	}
	
	return result;
}

- (BOOL) hasRoomForCards {
	if (cardsDealt < (SetMaxRows * SetMaxCols))
		return TRUE;
	
	if (mightBeSparse) {
		int i;
		
		for (i = 0; i < SetMaxCards; i++) {
			if (cardFree(i))
				return TRUE;
		}
	}
	
	return FALSE;
}

- (BOOL) hasRoomForCards: (unsigned int) n {
	if (cardsDealt + n <= (SetMaxRows * SetMaxCols))
		return TRUE;
	
	if (mightBeSparse) {
		int i;
		
		for (i = 0; i < SetMaxCards; i++) {
			if (cardFree(i))
				n--;
			
			if (n == 0)
				return TRUE;
		}
	}
	
	return FALSE;
}

- (BOOL) deal: (SetCard *) card {
	if (mightBeSparse) {
		unsigned int n;
		
		for (n = 0; n < cardsDealt; n++) {
			if (cardFree(n)) {
				[cells[n] setCard: card];
				return TRUE;
			}
		}
	}
	
	if ([self hasRoomForCards]) {
		[cells[cardsDealt] setCard: card];
		cardsDealt++;
		
		[self resizeDisplay];
		return TRUE;
	}
	
	return FALSE;
}

- (BOOL) shouldCompact {
	return (cardsDealt > colsToDeal * SetMaxRows) && mightBeSparse;
}

- (void) compact {
	signed int src, dst;
	
	src = cardsDealt - 1;
	
		/* Rewind src to last card */
	while ((src > 0) && cardFree(src)) {
		src--;
	}
	
	dst = src - 1;
	
		/* fill holes */
	while ((dst > 0) && (src > dst)) {
			/* dst = next hole */
		while ((dst > 0) && cardExists(dst))
			dst--;
		
			/* src = next card */
		while ((src > dst) && cardFree(src))
			src--;
		
		if ((src > dst) && cardFree(dst)) {
			SetCardCell *srcCell = cells[src];
			SetCardCell *dstCell = cells[dst];
		
			[dstCell setCard: [srcCell card]];
			[srcCell setCard: nil];
		}
		
	}
	
	[self recountCards];	/* Sanity check, etc. */
	[self resizeDisplay];
}

- (unsigned int) cardsNeeded {
	unsigned int cardsNeeded = 0;
	unsigned int n;
	
	for (n = 0; n < cardsDealt; n++) {
		if (cardFree(n))
			cardsNeeded++;
	}
	
	return cardsNeeded;
}

- (void) recountCards {
	unsigned int n;
	
	for (n = SetMaxCards - 1; cardFree(n); n--);
	
	cardsDealt = n + 1;
	
	while (n-- > 0) {
		if (cardFree(n)) {
			mightBeSparse = TRUE;
			return;
		}
	}
	
	mightBeSparse = FALSE;
}

- (NSArray *) cardsInPlay {
	unsigned int i;
	NSMutableArray *cards = [NSMutableArray array];
	
	for (i = 0; i < cardsDealt; i++) {
		SetCard *card = [cells[i] card];
		
		ifClass (card, SetCard)
			[cards addObject: card];
	}
	
	return cards;
}

- (unsigned int) numSets {
	return numSetsInCellArray(cells, SetMaxCards);
}

- (BOOL) hasNoSets {
	return ![self numSets];
}

- (BOOL) selectionIsSet {
	return (BOOL) numSetsInNSArray(selection);
}


- (IBAction) debug: (id) sender {
	int i;
	unsigned int selSets;
	NSArray *fieldSets;
	
	selSets = numSetsInNSArray(selection);
	fieldSets = setsInCellArray(cells, SetMaxCards);
	
	NSLog(@"------------------------");
	NSLog(@"Sets in field:");
	
	if ([fieldSets count]) {
		NSEnumerator *setEnum = [fieldSets objectEnumerator];
		NSArray *set;
		
		while (set = [setEnum nextObject]) {
			NSEnumerator *cardEnum = [set objectEnumerator];
			SetCard *card;
			NSMutableString *string = [NSMutableString string];
			
			while (card = [cardEnum nextObject]) {
				[string appendString: [card description]];
			}
			
			NSLog(@"%@", string);
		}
	} else {
		NSLog(@"<none>");
	}

	NSLog(@"------------------------");
	NSLog(@"cardsDealt: %u", cardsDealt);
	NSLog(@"colsVisible: %u", [self colsVisible]);
	NSLog(@"displayColsNeeded: %u", [self displayColsNeeded]);
	NSLog(@"mightBeSparse: %u", mightBeSparse);
	NSLog(@"selection: <%u items>", (unsigned) [selection count]);
	NSLog(@"sets in selection: %u", (unsigned) selSets);
	NSLog(@"sets in field: %u", (unsigned) [fieldSets count]);
	NSLog(@"------------------------");

	NSLog(@"selection = %@", [self selectedCards]);
	
	
	for (i = 0; i < SetMaxCards; i++) {
		if (cardExists(i))
			NSLog(@"cell(%d) = %@", i, [cells[i] card]);
	}
	
	NSLog(@"------------------------");
}


- (IBAction) debugFindSet: (id) sender {
	NSArray *sets = setsInCellArray(cells, SetMaxCards);
	unsigned int numSets;
	
	if ((numSets = [sets count])) {
		unsigned int setNum;
		NSArray *set;
		NSEnumerator *cardEnum;
		SetCard *card;
		
		setNum = [sets indexOfObject: [self selectedCards]];
		if (setNum != NSNotFound) {
			setNum += 1;
			setNum %= numSets;
		} else {
			setNum = 0;
		}
		
		set = [sets objectAtIndex: setNum];
		
		cardEnum = [set objectEnumerator];
		while (card = [cardEnum nextObject]) {
			[self selectCard: card];
		}
	} else {
		[self deselectAllSetCardCells];
	}
}

@end



	/* .-====== Local Functions =======-. */
inline unsigned int cardNum(unsigned int row, unsigned int col) {
	return (col * SetMaxRows) + row;
}

inline unsigned int cardRow(unsigned int num) {
	return num % SetMaxRows;
}

inline unsigned int cardCol(unsigned int num) {
	return num / SetMaxRows;
}
