//
//  SetTeam.m
//  Set
//
//  Created by James Cook on 11/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "SetTeam.h"


@implementation SetTeam

- (id) init {
	self = [super init];
	
	if (self) {
		name = nil;
		keyEquivalent = nil;
		
		menuItem = nil;
		
		[self resetScore];
	}
	
	return self;
}

- (NSString *) name {
	return name;
}

- (void) setName: (NSString *) newName {
	[newName retain];
	[name release];
	
	name = newName;
}

- (NSString *) keyEquivalent {
	return keyEquivalent;
}

- (void) setKeyEquivalent: (NSString *) newkeyEquivalent {
	[newkeyEquivalent retain];
	[keyEquivalent release];
	
	keyEquivalent = newkeyEquivalent;
}

- (void) resetScore {
	score = 0;
}

- (int) score {
	return score;
}

- (int) score: (int) increaseBy {
	return (score += increaseBy);
}

- (void) setScore: (int) newScore {
	score = newScore;
}

- (NSMenuItem *) addToMenu: (NSMenu *) menu atIndex: (unsigned int) menuIndex {
	[menuItem release];
	
	menuItem = [menu insertItemWithTitle: name action: NULL keyEquivalent: keyEquivalent atIndex: menuIndex];
	return menuItem;
}

- (void) cleanupMenu {
	NSMenu *menu = [menuItem menu];
	[menu removeItem: menuItem];
	
	[menuItem release];
}

@end
