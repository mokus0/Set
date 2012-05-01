//
//  SetMatrix.h
//  Set
//
//  Created by mokus on Mon Mar 28 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SetConstants.h"

@class SetCard;
@class SetCardCell;

@interface SetMatrix : NSMatrix {
	unsigned int colsVisible;
	unsigned int minColsVisible;
	
	unsigned int colsToDeal;
	unsigned int cardsDealt;
	BOOL mightBeSparse;
	
	SetCardCell *cells[SetMaxCards];
	NSString *(*keymap)[SetMaxRows][SetMaxCols];
	
	NSMutableArray *selection;
	BOOL limitSelection;
}

- (void) awakeFromNib;

- (void) loadPrefs;
- (void) loadLivePrefs;
- (void) loadGamePrefs;

- (void) initCells;
- (void) resetCells;

- (unsigned int) maxRows;
- (unsigned int) maxCols;

- (unsigned int) colsToDeal;
- (void) setColsToDeal: (unsigned int) cols;

- (unsigned int) colsDealt;
- (unsigned int) colsVisible;

- (unsigned int) displayColsNeeded;

- (void) resizeDisplay;
- (void) resizeDisplay:  (unsigned int) cols;

- (SetCard *) cardAtRow: (unsigned int) row column: (unsigned int) col;
- (void) setCard: (SetCard *) card atRow: (unsigned int) row column: (unsigned int) col;


- (void) applyKeymap;

- (IBAction) setDvorak: (id) sender;
- (IBAction) setQwerty: (id) sender;
- (IBAction) toggleDvQw: (NSMenuItem *) sender;

- (void) selectSetCardCell: (SetCardCell *) cell;
- (void) deselectSetCardCell: (SetCardCell *) cell;
- (void) removeSelection;

- (BOOL) fullSelection;
- (unsigned int) cardsSelected;
- (SetCard *) selected: (unsigned int) num;
- (void) deselectAllSetCardCells;

- (BOOL) selectCard: (SetCard *) card;
- (NSSet *) selectedCards;

- (BOOL) hasRoomForCards;
- (BOOL) hasRoomForCards: (unsigned int) count;

- (BOOL) deal: (SetCard *) card;

- (BOOL) shouldCompact;
- (void) compact;

- (unsigned int) cardsNeeded;
- (void) recountCards;

- (NSArray *) cardsInPlay;

- (unsigned int) numSets;
- (BOOL) hasNoSets;
- (BOOL) selectionIsSet;

- (IBAction) debug: (id) sender;
- (IBAction) debugFindSet: (id) sender;

@end
