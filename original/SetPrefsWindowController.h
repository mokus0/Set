//
//  SetPrefsWindowController.h
//  Set
//
//  Created by mokus on Wed Mar 30 2005.
//  Copyright (c) 2007 James Cook. All rights reserved.
//

#import <AppKit/AppKit.h>

@class SetWindowController;

@interface SetPrefsWindowController : NSWindowController {
	NSUserDefaults *defaults;
	
	IBOutlet NSTableView *scoreboardTable;
	IBOutlet SetWindowController *windowController;
	
	IBOutlet NSTextField *teamEntryField;
	IBOutlet NSButton *addTeamButton;
	IBOutlet NSButton *delTeamButton;
}

- (void) awakeFromNib;

- (void) windowDidMove: (NSNotification *) thing;
- (void) windowDidResize: (NSNotification *) thing;

- (IBAction) addTeam: sender;
- (IBAction) dropTeam: sender;

- (IBAction)addTeam:(id)sender;
- (IBAction)dropTeam:(id)sender;
- (IBAction)setPref:(id)sender;

@end
