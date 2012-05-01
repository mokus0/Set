//
//  SetScoreboard.m
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2007 James Cook. All rights reserved.
//

	/* .-====== Primary headers =======-. */
#import "SetScoreboard.h"

	/* .-===== Secondary headers ======-. */
#import "SetConstants.h"
#import "SetTeam.h"
#import "SetDefaults.h"


	/* .-==== Handy Little Macros =====-. */
#define		teamNameExists(name)	((name != nil) && teamByName(name) != nil)
#define		keyExists(key)			((key != nil) && (teamByKey(key) != nil))
#define		teamByNumber(team)		([teams objectAtIndex: team])
#define		teamByName(team)		([teamsByName objectForKey: team])
#define		teamByKey(team)			([teamsByKey objectForKey: team])

	/* .-==== Class Implementation ====-. */
@implementation SetScoreboard

- (void) awakeFromNib {
    defaults = [NSUserDefaults standardUserDefaults];
    
	teams = [[NSMutableArray alloc] init];
	teamsByName = [[NSMutableDictionary alloc] init];
	teamsByKey = [[NSMutableDictionary alloc] init];
	
	[self initOutputAttributes];
	
	[self loadPrefs];
}

- (void) initOutputAttributes {
	NSMutableParagraphStyle *Left, *Right;
	
	Left = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[Left setAlignment: NSLeftTextAlignment];
	[Left setLineBreakMode: NSLineBreakByTruncatingTail];
	
	Right = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[Right setAlignment: NSRightTextAlignment];
	[Right setLineBreakMode: NSLineBreakByWordWrapping];
	
	
	teamNameAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
		[NSNumber numberWithInt: NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
		Left, NSParagraphStyleAttributeName,
		nil
	];
	
	scoreAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
		Right, NSParagraphStyleAttributeName,
		nil
	];
}

- (void) loadPrefs {
	[self loadUserPrefs];
}

- (void) savePrefs {
	[self saveUserPrefs];
}

- (void) loadUserPrefs {
	NSArray *teamsPrefs = [defaults arrayForKey: SetPrefs_teams];
	
	NSEnumerator *teamEnum = [teamsPrefs objectEnumerator];
	NSDictionary *dictionary;
	
	while (dictionary = [teamEnum nextObject]) {
		ifClass(dictionary, NSDictionary) {
			NSString *teamName = [dictionary objectForKey: SetPrefs_teams_name];
			NSString *teamKey = [dictionary objectForKey: SetPrefs_teams_key];
			NSNumber *teamScore = [dictionary objectForKey: SetPrefs_teams_score];
			
			if (isClass(teamName, NSString) && isClass(teamKey, NSString)) {
				SetTeam *newTeam = [self newTeam: teamName withKeyEquivalent: teamKey];
				
				ifClass(teamScore, NSNumber)
					[newTeam setScore: [teamScore intValue]];
			}
		}
	}
}

- (void) saveUserPrefs {
	unsigned int numTeams = [self numTeams];
	NSMutableArray *teamsPrefs = [NSMutableArray arrayWithCapacity: numTeams];
	unsigned int i;
	
	for (i = 0; i < numTeams; i++) {
		SetTeam *team = teamByNumber(i);
		
		NSDictionary *teamInfo = [NSDictionary dictionaryWithObjectsAndKeys:
				[team name],
					SetPrefs_teams_name,
				[team keyEquivalent],
					SetPrefs_teams_key,
				[NSNumber numberWithInt: [team score]],
					SetPrefs_teams_score,
				nil
			];
		
		[teamsPrefs addObject: teamInfo];
	}
	
	[defaults setObject: teamsPrefs forKey: SetPrefs_teams];
}

- (NSString *) teamName: (int) num {
	return [teamByNumber(num) name];
}

- (NSUInteger) teamNumber: (NSString *) name {
	SetTeam *team = teamByName(name);
	
	if (team)
		return [teams indexOfObject: team];
	else
		return -1;
}

- (void) score: (NSInteger) points forTeam: (NSString *) name {
	SetTeam *team = teamByName(name);
	
	ifClass (team, SetTeam) {
		[team score: points];
		
		[self saveUserPrefs];
		[self setNeedsDisplay: TRUE];
	}
}

- (void) score: (NSInteger) points forTeamNum: (NSUInteger) num {
	SetTeam *team = teamByNumber(num);
	
	ifClass (team, SetTeam) {
		[team score: points];
		
		[self saveUserPrefs];
		[self setNeedsDisplay: TRUE];
	}
}

- (NSInteger) eventValue: (NSString *) event {
    NSDictionary *scoring = [defaults dictionaryForKey: SetPrefs_scoring];
    NSNumber *value = [scoring objectForKey: event];
    return (value ? [value intValue] : 0);
}

- (void) event: (NSString *) event forTeam: (NSString *) team {
	[self score: [self eventValue: event] forTeam: team];
}

- (void) event: (NSString *) event forTeamNum: (NSUInteger) team {
	[self score: [self eventValue: event] forTeam: [self teamName: team]];
}

- (NSInteger) scoreForTeam: (NSString *) name {
	SetTeam *team = teamByName(name);
	
	ifClass (team, SetTeam)
		return [team score];
	
	return 0;
}

- (NSInteger) scoreForTeamNum: (NSUInteger) num {
	SetTeam *team = teamByNumber(num);
	
	ifClass (team, SetTeam)
		return [team score];
	
	return 0;
}


- (NSAttributedString *) scoreText {
	unsigned int team;
	unsigned int numTeams = [teams count];
	
	NSAttributedString *newline1 = [[NSAttributedString alloc] initWithString: @"\n" attributes: teamNameAttributes];
	NSAttributedString *newline2 = [[NSAttributedString alloc] initWithString: @"\n" attributes: scoreAttributes];
	NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: @"" attributes: teamNameAttributes];
	
	[text beginEditing];
	
	for (team = 0; team < numTeams; team++) {
		NSAttributedString *teamName = [[NSAttributedString alloc] initWithString: [self teamName: team] attributes: teamNameAttributes];
		NSAttributedString *scoreText = [[NSAttributedString alloc] initWithString: [[NSNumber numberWithInt: [teamByNumber(team) score]] stringValue] attributes: scoreAttributes];
		
		[text appendAttributedString: teamName];
		[text appendAttributedString: newline1];
		[text appendAttributedString: scoreText];
		[text appendAttributedString: newline2];
		
		[teamName autorelease];
		[scoreText autorelease];
	}
	
	[newline1 autorelease];
	[newline2 autorelease];
	
	[text endEditing];
	[text autorelease];
	
	return text;
}


- (void) resetScores {
	SetTeam *team;
	NSEnumerator *teamEnum = [teams objectEnumerator];
	
	while (team = [teamEnum nextObject]) {
		[team resetScore];
		
		[self saveUserPrefs];
		[self setNeedsDisplay: TRUE];
	}
}

- (IBAction) resetScores: (id) sender {
	[self resetScores];
}


- (NSArray *) teams {
	return [teamsByName allKeys];
}

- (NSUInteger) numTeams {
	return [teams count];
}

- (NSString *) nextUntiltedName {
		/* Choose a name if none is given */
	int i = 0;
	
	for (i = 0; TRUE; i++) {
		NSString *name;
		if (i)	name = [NSString stringWithFormat: @"Untitled %d", i];
		else	name = @"Untitled";
		
		if (! teamNameExists(name))
			return name;
	}
}

- (NSString *) nextUntiltedKey {
		/* Choose a keyEquivalent if none is given */
	int i;
	
	for (i = 1; i < 16; i++) {
		NSString *key;
		key = [NSString stringWithFormat: @"%x", i];
		
		if (! keyExists(key))
			return key;
	}
	
	return nil;
}

- (BOOL) addTeam {
	return [self addTeam: [self nextUntiltedName] withKeyEquivalent: [self nextUntiltedKey]];
}

- (BOOL) addTeam: (NSString *) name {
	return [self addTeam: name withKeyEquivalent: [self nextUntiltedKey]];
}

- (BOOL) addTeamWithKeyEquivalent: (NSString *) key {
	return [self addTeam: [self nextUntiltedName] withKeyEquivalent: key];
}

- (BOOL) addTeam: (NSString *) name withKeyEquivalent: (NSString *) key {
	if ([self newTeam: name withKeyEquivalent: key])
		return TRUE;
	
	return FALSE;
}

- (SetTeam *) newTeam: (NSString *) name withKeyEquivalent: (NSString *) key {
	SetTeam *newTeam;
	NSMenuItem *menuItem;
	unsigned int menuIndex;
	
	if ((name == nil) || (key == nil))
		return nil;
	
	if (teamNameExists(name) || keyExists(name))
		return nil;
	
	newTeam = [[SetTeam alloc] init];
	[newTeam setName: name];
	if (key) [newTeam setKeyEquivalent: key];
	
	[teams addObject: newTeam];
	[teamsByName setObject: newTeam forKey: name];
	[teamsByKey setObject: newTeam forKey: key];
	
	menuIndex = [teams indexOfObject: newTeam];
	menuItem = [newTeam addToMenu: setMenu atIndex: menuIndex];
	[menuItem setEnabled: TRUE];
	[menuItem setTarget: [[self window] windowController]];
	[menuItem setAction: @selector(evaluate:)];
	
	[newTeam release];
	
	[self saveUserPrefs];
	[self setNeedsDisplay: TRUE];
	
	return newTeam;
}

- (BOOL) dropTeamNum: (NSUInteger) num {
	NSString *name = [self teamName: num];
	
	if (name)
		return [self dropTeam: name];
	else
		return FALSE;
}

- (BOOL) dropTeam: (NSString *) name {
	SetTeam *team = [teamByName(name) retain];
	
	if (team) {
		NSString *key = [team keyEquivalent];
		
		[team cleanupMenu];
		
		[teams removeObject: team];
		[teamsByName removeObjectForKey: name];
		[teamsByKey removeObjectForKey: key];
		
		[team release];
		
		[self saveUserPrefs];
		[self setNeedsDisplay: TRUE];
		
		return TRUE;
	}
	
	return FALSE;
}

- (BOOL) renameTeam: (NSUInteger) num to: (NSString *) newName {
	SetTeam *team = teamByNumber(num);
	if (! teamNameExists(newName)) {
		NSString *oldName = [self teamName: num];
		
		[team setName: newName];
		
		[teamsByName removeObjectForKey: oldName];
		[teamsByName setObject: team forKey: newName];
		
		[self saveUserPrefs];
		[self setNeedsDisplay: TRUE];
		return TRUE;
	}
	
	return FALSE;
}


- (void)drawRect:(NSRect)rect {
	NSAttributedString *text= [self scoreText];
	
	if (text == nil)
		text = [[[NSAttributedString alloc] initWithString: @"(nil)"] autorelease];
	
	[text drawInRect: rect];
}



- (NSInteger) numberOfRowsInTableView: (NSTableView *) view {
	return [teams count];
}

- (NSString *) tableView: (NSTableView *) view objectValueForTableColumn: (NSTableColumn *) column row: (NSInteger) r {
	NSInteger c = [[column identifier] intValue];
	
	switch (c) {
		case 1:	// name
			return [self teamName: r];
			break;
		case 2: // key
			return [teamByNumber(r) keyEquivalent];
			break;
	}
	
	return nil;
}

- (void) tableView: (NSTableView *) view setObjectValue: (id) value forTableColumn: (NSTableColumn *) column row: (NSInteger) r {
	int c = [[column identifier] intValue];
	
	switch (c) {
		case 1:	// name
			[self renameTeam: r to: value];
			break;
		case 2: // key
			[teamByNumber(r) setKeyEquivalent: value];
			break;
	}
}
@end
