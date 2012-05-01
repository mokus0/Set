/*
 *  SetFunctions.c
 *  Set
 *
 *  Created by mokus on Sun Mar 27 2005.
 *  Copyright (c) 2005 James Cook. All rights reserved.
 *
 */

	/* .-====== Primary headers =======-. */
#import <Cocoa/Cocoa.h>
#import "SetFunctions.h"

	/* .-===== Secondary headers ======-. */
#import "SetConstants.h"
#import "SetCard.h"
#import "SetCardCell.h"



	/* .-====== Local Prototypes ======-. */
static BOOL compatible (int a, int b, int c);
static unsigned int completion (unsigned int a, unsigned int b);



	/* .-====== Local Functions =======-. */
static BOOL compatible (int a, int b, int c) {
	if ((a == b) && (a == c))
		return TRUE;
	
	if ((a == b) || (b == c) || (a == c))
		return FALSE;
	
	return TRUE;
}

static unsigned int completion (unsigned int a, unsigned int b) {
	static const unsigned int c[3][3] = {
		{0, 2, 1},
		{2, 1, 0},
		{1, 0, 2}
	};
	
	if ((a > 2) || (b > 2))
		return -1;
	
	return c[a][b];
}



	/* .-====== Public Functions ======-. */
BOOL isSet(SetCard *card1, SetCard *card2, SetCard *card3) {
	if (! compatible(
			[card1 shape],
			[card2 shape],
			[card3 shape]		
		)) return FALSE;
	
	if (! compatible(
			[card1 color],
			[card2 color],
			[card3 color]		
		)) return FALSE;
	
	if (! compatible(
			[card1 number],
			[card2 number],
			[card3 number]		
		)) return FALSE;
	
	if (! compatible(
			[card1 fill],
			[card2 fill],
			[card3 fill]		
		)) return FALSE;
	
	return TRUE;
}

SetCard *finishSet(SetCard *card1, SetCard *card2) {
	SetCard *card3 = [[SetCard alloc]
		initWithShape:  completion ([card1 shape],  [card2 shape])
				color:  completion ([card1 color],  [card2 color])
			   number:  completion ([card1 number], [card2 number])
				 fill:  completion ([card1 fill],   [card2 fill])
		];
	
	return card3;
}

	/* I'm sure there's an elegant algorithm, 
	   but use brute force for now... */
unsigned int numSetsInArray(SetCard **cards, unsigned int numCards) {
	unsigned int set = 0;
	unsigned int i, j, k;
	SetCard *a, *b, *c;
		
	if (numCards < SetCardsPerSet)
		return 0;
	
	for (i = 0; i< (numCards - 2); i++) {
		for (j = i + 1; j < (numCards - 1); j++) {
			for (k = j + 1; k < numCards; k++) {
				a = cards[i];
				b = cards[j];
				c = cards[k];
				
				if (isSet(a, b, c)) {
					set++;
					
					/* skip to next j:
					   if a, b, and c are a set,
					   a, b, and _x_ cannot be */
					k = numCards;
				}
			}
		}
	}
	
	return set;
}

NSArray *setsInArray(SetCard **cards, unsigned int numCards) {
	unsigned int i, j, k;
	SetCard *a, *b, *c;
	NSMutableArray *sets = [NSMutableArray array];
		
	if (numCards < SetCardsPerSet)
		return 0;
	
	for (i = 0; i< (numCards - 2); i++) {
		for (j = i + 1; j < (numCards - 1); j++) {
			for (k = j + 1; k < numCards; k++) {
				a = cards[i];
				b = cards[j];
				c = cards[k];
				
				if (isSet(a, b, c)) {
					NSSet *set = [NSSet setWithObjects: a, b, c, nil];
					[sets addObject: set];
					
					/* skip to next j:
					   if a, b, and c are a set,
					   a, b, and _x_ cannot be */
					k = numCards;
				}
			}
		}
	}
	
	return sets;
}

unsigned int numSetsInCellArray(SetCardCell **cells, unsigned int numCells) {
	SetCard **cards;
	unsigned int numCards = 0;
	unsigned int i;
	unsigned int result;
	
	cards = malloc(numCells * sizeof(*cards));
	

	for (i = 0; i < numCells; i++) {
		SetCard *item = (SetCard *) cells[i];
		
		ifClass(item, SetCardCell)
			item = [(SetCardCell *) item card];
		
		ifClass(item, SetCard)
			cards[numCards++] = item;
	}
	
	result = numSetsInArray(cards, numCards);
	
	free(cards);
	
	return result;
}

NSArray *setsInCellArray(SetCardCell **cells, unsigned int numCells) {
	SetCard **cards;
	unsigned int numCards = 0;
	unsigned int i;
	NSArray *result;
	
	cards = malloc(numCells * sizeof(*cards));
	

	for (i = 0; i < numCells; i++) {
		SetCard *item = (SetCard *) cells[i];
		
		ifClass(item, SetCardCell)
			item = [(SetCardCell *) item card];
		
		ifClass(item, SetCard)
			cards[numCards++] = item;
	}
	
	result = setsInArray(cards, numCards);
	
	free(cards);
	
	return result;
}

unsigned int numSetsInNSArray(NSArray *array) {
	SetCard **cards;
	unsigned int numCards = 0;
	NSEnumerator *itemEnum;
	NSObject *item;
	unsigned int result;
	
	cards = malloc([array count] * sizeof(*cards));
	
	itemEnum = [array objectEnumerator];
	while (item = [itemEnum nextObject]) {
		ifClass(item, SetCardCell)
			item = [(SetCardCell *) item card];
		
		ifClass(item, SetCard)
			cards[numCards++] = (SetCard *) item;
	}
	
	result = numSetsInArray(cards, numCards);
	
	free(cards);
	
	return result;
}

NSArray *setsInNSArray(NSArray *array) {
	SetCard **cards;
	unsigned int numCards = 0;
	NSEnumerator *itemEnum;
	NSObject *item;
	NSArray *result;
	
	cards = malloc([array count] * sizeof(*cards));
	
	itemEnum = [array objectEnumerator];
	while (item = [itemEnum nextObject]) {
		ifClass(item, SetCardCell)
			item = [(SetCardCell *) item card];
		
		ifClass(item, SetCard)
			cards[numCards++] = (SetCard *) item;
	}
	
	result = setsInArray(cards, numCards);
	
	free(cards);
	
	return result;
}


	/* shrinks src to make it the same aspect as dst */
NSRect proportionalRectToRect(NSRect src, NSRect dst) {
	float srcAspect = src.size.height / src.size.width;
	float dstAspect = dst.size.height / dst.size.width;
	
	if (srcAspect != dstAspect) {
		if (srcAspect < dstAspect) {
			// Keep height constant, make narrower
			
			float newWidth = src.size.height / dstAspect;
			float dW = src.size.width - newWidth;
			
			src.origin.x += dW / 2;
			src.size.width = newWidth;
		} else {
			float newHeight = src.size.width * dstAspect;
			float dH = src.size.height - newHeight;
			
			src.size.height = newHeight;
			src.origin.y += dH / 2;
		}
	}
	
	return src;
}
