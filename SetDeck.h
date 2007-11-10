//
//  SetDeck.h
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetConstants.h"

@class SetCard;
@class SetMatrix;

@interface SetDeck : NSObject {
	BOOL enabled[SetAttributeCount][SetCardsPerSet];
	
	unsigned int numDecks;
	BOOL autoRedeal;
	
	NSMutableArray *cards;
	SetMatrix *field;
}

- (id) init;
- (NSString *) description;

- (NSMutableArray *) fullDeck;

- (SetCard *) next;
- (unsigned int) cardsLeft;
- (unsigned int) cardsInFullDeck;
- (unsigned int) numCardsNotInPlay;

- (void) attachToPlayingField: (SetMatrix *) field;
- (NSArray *) cardsNotInPlay;
- (NSArray *) cardsInPlay;

- (void) loadPrefs;
- (void) loadEnabledMap;

- (void) reset;
- (void) shuffle;

- (SetCard *) autoRedeal;
- (SetCard *) dealRandomCard;
@end
