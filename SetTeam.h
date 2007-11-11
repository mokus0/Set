//
//  SetTeam.h
//  Set
//
//  Created by James Cook on 11/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SetTeam : NSObject {
	NSString *name;
	NSString *keyEquivalent;
	
	int score;
	
	NSMenuItem *menuItem;
}

- (NSString *) name;
- (void) setName: (NSString *) name;

- (NSString *) keyEquivalent;
- (void) setKeyEquivalent: (NSString *) keyEquivalent;

- (void) resetScore;
- (int) score;
- (int) score: (int) increaseBy;
- (void) setScore: (int) score;

- (NSMenuItem *) addToMenu: (NSMenu *) menu atIndex: (unsigned int) menuIndex;
- (void) cleanupMenu;

@end
