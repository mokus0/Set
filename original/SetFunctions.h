/*
 *  SetFunctions.h
 *  Set
 *
 *  Created by mokus on Sun Mar 27 2005.
 *  Copyright (c) 2005 James Cook. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@class SetCard;
@class SetCardCell;

	/* .-==== Set-finding functions ====-. */
BOOL isSet(SetCard *card1, SetCard *card2, SetCard *card3);
SetCard *finishSet(SetCard *card1, SetCard *card2);

unsigned int numSetsInArray(SetCard **cards, unsigned int numCards);
unsigned int numSetsInCellArray(SetCardCell **cells, unsigned int numCells);

unsigned int numSetsInNSArray(NSArray *array);

NSArray *setsInArray(SetCard **cards, unsigned int numCards);
NSArray *setsInCellArray(SetCardCell **cells, unsigned int numCells);

NSArray *setsInNSArray(NSArray *array);



	/* .-==== NSRect-al functions ====-. */
NSRect proportionalRectToRect(NSRect src, NSRect dst);
