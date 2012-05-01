//
//  SetCardWindowController.h
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2007 James Cook. All rights reserved.
//

#import <AppKit/AppKit.h>

@class SetDeck;
@class SetScoreboard;
@class SetMatrix;
@class SetPrefsWindowController;

@interface SetWindowController : NSWindowController {
	SetDeck *deck;
	unsigned long long decksFinished;
	unsigned long long decksNotFinished;
	unsigned long long cardsDealt;
	
	IBOutlet SetScoreboard *scoreboard;
	
	IBOutlet SetMatrix *field;
	IBOutlet NSButton *noSetButton;
	
	BOOL strictNoSet;
	BOOL deselectOnBadSet;
	
	IBOutlet SetPrefsWindowController *prefsWindowController;
}

- (void) awakeFromNib;

- (void) loadPrefs;
- (void) loadGamePrefs;
- (void) loadLivePrefs;

- (IBAction) deal: (id) sender;
- (void) dealN: (unsigned int) n;

- (void) normalizeField;

- (IBAction) evaluate: (id) sender;
- (IBAction) newgame: (id) sender;
- (IBAction) noSet: (id) sender;
- (IBAction) dealMoreAnyway: (id) sender;

- (IBAction) openPrefs: (id) sender;
- (SetScoreboard *) scoreboard;

- (void) windowWillClose: (NSNotification *) thing;
- (void) windowDidMove: (NSNotification *) thing;
- (void) windowDidResize: (NSNotification *) thing;

- (IBAction) debug: (id) sender;
- (IBAction) debugPretendSet: (id) sender;
- (IBAction) debugAutoplay: (id) sender;


@end
