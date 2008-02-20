//
//  SetPrefsWindowController.m
//  Set
//
//  Created by mokus on Wed Mar 30 2005.
//  Copyright (c) 2007 James Cook. All rights reserved.
//

#import "SetPrefsWindowController.h"
#import "SetDefaults.h"
#import "SetWindowController.h"
#import "SetScoreboard.h"

@implementation SetPrefsWindowController

- (void) awakeFromNib {
	[[self window] setFrameUsingName: SetPrefs_prefsWindowFrame];
	
	NSLog(@"windowController: %@", windowController);
	[scoreboardTable setDataSource: [windowController scoreboard]];
}

- (void) windowDidMove: (NSNotification *) thing {
	[[self window] saveFrameUsingName: SetPrefs_prefsWindowFrame];
}

- (void) windowDidResize: (NSNotification *) thing {
	[[self window] saveFrameUsingName: SetPrefs_prefsWindowFrame];
}

- (IBAction) addTeam: sender {
	SetScoreboard *scoreboard = [windowController scoreboard];
	NSString *name = [teamEntryField stringValue];
	
	[scoreboard addTeam: name];
	[scoreboardTable reloadData];
}

- (IBAction) dropTeam: sender {
	int selected = [scoreboardTable selectedRow];
	SetScoreboard *scoreboard = [windowController scoreboard];
	
	if (selected == -1)
		return;
	
	[scoreboard dropTeamNum: selected];
	[scoreboardTable reloadData];
}

- (IBAction)setPref:(id)sender {
	
	
	NSLog(@"setPref: (tag = %d) %@", [sender tag], sender);
}




@end
