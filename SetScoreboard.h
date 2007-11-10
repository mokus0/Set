//
//  SetScoreboard.h
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2007 James Cook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SetTeam;

@interface SetScoreboard : NSView {
	
		/* array of SetTeam objects in their "presentation order" */
	NSMutableArray *teams;
	
		/* the same objects, indexed by useful data */
	NSMutableDictionary *teamsByName;
	NSMutableDictionary *teamsByKey;
	
	
		/* points awarded for various events */
	NSMutableDictionary *eventPoints;
	
		/* text formatting data */
	NSMutableDictionary *teamNameAttributes;
	NSMutableDictionary *scoreAttributes;
	
		/* the menu where teams "buzz in" */
	IBOutlet NSMenu *setMenu;
}

- (void) awakeFromNib;
- (void) initOutputAttributes;
- (void) loadPrefs;
- (void) savePrefs;

- (NSString *) teamName: (int) num;
- (signed int) teamNumber: (NSString *) name;

- (void) score: (int) points forTeam: (NSString *) team;
- (void) score: (int) points forTeamNum: (unsigned int) team;

- (void) event: (NSString *) event forTeam: (NSString *) team;
- (void) event: (NSString *) event forTeamNum: (unsigned int) team;

- (int) scoreForTeam: (NSString *) team;
- (int) scoreForTeamNum: (unsigned int) team;

- (NSAttributedString *) scoreText;

- (void) resetScores;
- (IBAction) resetScores: (id) sender;

- (NSArray *) teams;
- (unsigned int) numTeams;

- (BOOL) addTeam;
- (BOOL) addTeam: (NSString *) name;
- (BOOL) addTeamWithKeyEquivalent: (NSString *) key;
- (BOOL) addTeam: (NSString *) name withKeyEquivalent: (NSString *) key;
- (SetTeam *) newTeam: (NSString *) name withKeyEquivalent: (NSString *) key;

- (BOOL) dropTeam: (NSString *) name;
- (BOOL) dropTeamNum: (int) num;
- (BOOL) renameTeam: (int) team to: (NSString *) name;


- (int) pointsForEvent: (NSString *) eventId;
- (void) setPoints: (int) points forEvent: (NSString *) eventId;

- (void) drawRect: (NSRect) rect;


@end
