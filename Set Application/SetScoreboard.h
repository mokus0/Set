//
//  SetScoreboard.h
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2007 James Cook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SetTeam;

@interface SetScoreboard : NSView <NSTableViewDataSource> {
	NSUserDefaults* defaults;
    
		/* array of SetTeam objects in their "presentation order" */
	NSMutableArray *teams;
	
		/* the same objects, indexed by useful data */
	NSMutableDictionary *teamsByName;
	NSMutableDictionary *teamsByKey;
	
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

- (void) loadUserPrefs;
- (void) saveUserPrefs;


- (NSString *) teamName: (int) num;
- (NSUInteger) teamNumber: (NSString *) name;

- (void) score: (NSInteger) points forTeam: (NSString *) team;
- (void) score: (NSInteger) points forTeamNum: (NSUInteger) team;

- (void) event: (NSString *) event forTeam: (NSString *) team;
- (void) event: (NSString *) event forTeamNum: (NSUInteger) team;

- (NSInteger) scoreForTeam: (NSString *) team;
- (NSInteger) scoreForTeamNum: (NSUInteger) team;

- (NSAttributedString *) scoreText;

- (void) resetScores;
- (IBAction) resetScores: (id) sender;

- (NSArray *) teams;
- (NSUInteger) numTeams;

- (BOOL) addTeam;
- (BOOL) addTeam: (NSString *) name;
- (BOOL) addTeamWithKeyEquivalent: (NSString *) key;
- (BOOL) addTeam: (NSString *) name withKeyEquivalent: (NSString *) key;
- (SetTeam *) newTeam: (NSString *) name withKeyEquivalent: (NSString *) key;

- (BOOL) dropTeam: (NSString *) name;
- (BOOL) dropTeamNum: (NSUInteger) num;
- (BOOL) renameTeam: (NSUInteger) team to: (NSString *) name;

- (void) drawRect: (NSRect) rect;

@end
