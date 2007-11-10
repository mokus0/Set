//
//  SetCardWindowController.m
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2007 James Cook. All rights reserved.
//

	/* .-====== Primary headers =======-. */
#import "SetWindowController.h"

	/* .-===== Secondary headers ======-. */
#import "SetConstants.h"
#import "SetMatrix.h"
#import "SetDeck.h"
#import "SetScoreboard.h"
#import "SetDefaults.h"
#import "SetPrefsWindowController.h"



	/* .-==== Class Implementation ====-. */
@implementation SetWindowController

- (void) awakeFromNib {
	if (prefsWindowController) {	/* loading SetPrefsWindow.nib */
		return;
	}
	
	deck = [[SetDeck alloc] init];
	[deck attachToPlayingField: field];
	
	cardsDealt = 0;
	
	[field initCells];
	[self deal: self];
	
	decksFinished = 0;
	decksNotFinished = 0;
	
	[[self window] setFrameUsingName: SetPrefs_setWindowFrame];
}

- (void) loadPrefs {
	[self loadGamePrefs];
	[self loadLivePrefs];
}

- (void) loadGamePrefs {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSNumber *strictNoSetNS = [defaults objectForKey: SetPrefs_strictNoSet];
	NSNumber *deselectOnBadSetNS = [defaults objectForKey: SetPrefs_badSetDeselects];
	
	ifClass (strictNoSetNS, NSNumber)
		strictNoSet = [strictNoSetNS boolValue];
	
	ifClass (deselectOnBadSetNS, NSNumber)
		deselectOnBadSet = [deselectOnBadSetNS boolValue];
}

- (void) loadLivePrefs {
	
}

- (IBAction) deal: (id) sender {
	int colsToDeal, rowsToDeal;
	
	[self loadPrefs];
	
	if ([deck cardsLeft])
		decksNotFinished++;
	else
		decksFinished++;
	
	[deck reset];
	[deck shuffle];
	
	[field resetCells];
	
	colsToDeal = [field colsToDeal];
	rowsToDeal = [field maxRows];
	
	[self dealN: colsToDeal * rowsToDeal];
}

- (void) dealN: (unsigned int) n {
	unsigned int i;
	
	for (i = 0; i < n; i++) {
		if ([field hasRoomForCards]) {
			[field deal: [deck next]];
			cardsDealt++;
		}
	}
}

- (void) normalizeField {
	if ([field shouldCompact])
		[field compact];
	
	[self dealN: [field cardsNeeded]];
}

- (IBAction) evaluate: (id) sender {
	if ([field fullSelection]) {
		NSString *teamName = [sender title];
		
		if ([field selectionIsSet]) {
			[scoreboard event: @"Set.Good" forTeam: teamName];
			
			[field removeSelection];
			[self normalizeField];
		} else {
			[scoreboard event: @"Set.Bad" forTeam: teamName];
			
			if (deselectOnBadSet)
				[field deselectAllSetCardCells];
		}
	}
}


- (IBAction) newgame: (id) sender {
	[self deal: sender];
	[scoreboard resetScores: sender];
}

- (IBAction) noSet: (id) sender {
	if ((! strictNoSet) || [field hasNoSets]) {
		[field deselectAllSetCardCells];
		[self dealN: SetCardsPerSet];
	}
}

- (IBAction) dealMoreAnyway: (id) sender {
	[field deselectAllSetCardCells];
	[self dealN: SetCardsPerSet];
}

- (IBAction) openPrefs: (id) sender {
	if (prefsWindowController == nil) {
		if (! [NSBundle loadNibNamed: @"SetPrefsWindow" owner: self]) {
			NSLog(@"Failed to load nib for Set Preferences");
		}	
	} 
	
	if (prefsWindowController) {
		if ([[prefsWindowController window] isKeyWindow])
			[prefsWindowController close];
		else
			[prefsWindowController showWindow: sender];
	}
}

- (SetScoreboard *) scoreboard {
	return scoreboard;
}

- (void) windowWillClose: (NSNotification *) thing {
	[[self window] saveFrameUsingName: SetPrefs_setWindowFrame];
	[[NSApplication sharedApplication] terminate: self];
}

- (void) windowDidMove: (NSNotification *) thing {
	[[self window] saveFrameUsingName: SetPrefs_setWindowFrame];
}

- (void) windowDidResize: (NSNotification *) thing {
	[[self window] saveFrameUsingName: SetPrefs_setWindowFrame];
}

- (IBAction) debug: (id) sender {
	NSLog(@"------------------------");
	NSLog(@"decksFinished: %qu", decksFinished);
	NSLog(@"decksNotFinished: %qu", decksNotFinished);
	NSLog(@"cardsDealt: %qu", cardsDealt);
	NSLog(@"Deck: %@", deck);
}

- (IBAction) debugPretendSet: (id) sender {
	if ([field fullSelection]) {
		NSString *teamName = [sender title];
		
		if (TRUE /* [field selectionIsSet] */) {
			[scoreboard event: @"Set.Good" forTeam: teamName];
			
			[field removeSelection];
			[self normalizeField];
		} else {
			[scoreboard event: @"Set.Bad" forTeam: teamName];
		}
	}
}

- (IBAction) debugAutoplay: (id) sender {
	unsigned int maxCards = 10000;
	
	until((maxCards-- == 0) || (([field colsDealt] >= 5) && [field hasNoSets])) {
		if ([field hasNoSets]) {
			if ([deck cardsLeft]) 
				[self dealN: SetCardsPerSet];
			else
				[self deal:sender];
		}
		
		unless ([field hasNoSets]) {
			[field debugFindSet: sender];
			[scoreboard event: @"Set.Good" forTeam: @"Car Ramrod"];
			
			[field removeSelection];
			[self normalizeField];
		}
	}
}

@end
