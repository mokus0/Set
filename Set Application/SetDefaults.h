//
//  SetDefaults.h
//  Set
//
//  Created by mokus on Wed Mar 30 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

#define SetAppDefaultsKey			@"net.deepbondi.set"

	/* Playing field layout */
#define SetPrefs_colsToDeal			@"colsToDeal"			/* SetMatrix */
#define SetPrefs_colsToShow			@"colsToShow"			/* SetMatrix */
#define SetPrefs_setWindowFrame		@"SetWindow Frame"		/* SetWindowController*/
#define SetPrefs_prefsWindowFrame   @"PrefsWindow Frame"	/* SetPrefsWindowController*/

	/* Card appearance */
#define SetPrefs_cardColors			@"cardColors"			/* SetCard */
#define SetPrefs_cardShadeAlpha		@"cardShadeAlpha"		/* SetCard */
#define SetPrefs_cardShadeBlend		@"cardShadeBlend"		/* SetCard */
#define SetPrefs_cardOpenAlpha		@"cardOpenAlpha"		/* SetCard */
#define SetPrefs_cardOpenBlend		@"cardOpenBlend"		/* SetCard */
#define SetPrefs_cardStroke			@"cardStroke"			/* SetCard */

	/* keymap */
#define SetPrefs_keymap				@"keymap"				/* SetMatrix */
#define SetPrefs_keymap_dv			@"dvorak"				/* SetMatrix */
#define SetPrefs_keymap_qw			@"qwerty"				/* SetMatrix */

	/* Gameplay */
#define SetPrefs_strictNoSet		@"strictNoSet"			/* SetWindowController */
#define SetPrefs_limitSelection		@"limitSelection"		/* SetMatrix */
#define SetPrefs_badSetDeselects	@"badSetDeselects"		/* SetWindowController */
#define SetPrefs_quickSetCall		@"quickSetCall"			/* SetDeck */
#define SetPrefs_dealContinuous		@"dealContinuous"		/* SetDeck */
#define SetPrefs_dealRandom			@"dealRandom"			/* SetDeck */

	/* Teams */
#define SetPrefs_teams				@"teams"
#define SetPrefs_teams_name			@"teamName"
#define SetPrefs_teams_key			@"teamKey"
#define SetPrefs_teams_handicap		@"teamHandicap"
#define SetPrefs_teams_score		@"teamScore"

	/* Scoring */
#define SetPrefs_scoring			@"scoring"
#define SetPrefs_scoring_set		@"goodSet"
#define SetPrefs_scoring_notASet	@"badSet"
#define SetPrefs_scoring_noSet		@"goodNoSet"
#define SetPrefs_scoring_notANoSet	@"badNoSet"

	/* Deck contents */
#define SetPrefs_deckShapes			@"deckShapes"			/* SetDeck */
#define SetPrefs_deckColors			@"deckColors"			/* SetDeck */
#define SetPrefs_deckNumbers		@"deckNumbers"			/* SetDeck */
#define SetPrefs_deckFills			@"deckFills"			/* SetDeck */
#define SetPrefs_decks				@"decks"				/* SetDeck */

@class NSColor, NSData;
NSData  *dataFromColor(NSColor *color);
NSColor *colorFromData(NSData *data);

void setInitPrefs(void);

