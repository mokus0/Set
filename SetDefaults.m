//
//  SetDefaults.m
//  Set
//
//  Created by mokus on Wed Mar 30 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SetDefaults.h"
#import "SetConstants.h"

NSData  *dataFromColor(NSColor *color) {
	ifClass (color, NSColor)
		return [NSKeyedArchiver archivedDataWithRootObject: color];
	
	return nil;
}

NSColor *colorFromData(NSData *data) {
	NSColor *color = [NSKeyedUnarchiver unarchiveObjectWithData: data];
	
	ifClass(color, NSColor)
		return color;
	
	return nil;
}


void setInitPrefs(void) {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: [NSNumber numberWithUnsignedInt: SetStartingCols] forKey: SetPrefs_colsToDeal];
	[defaults setObject: [NSNumber numberWithUnsignedInt: SetVisibleCols] forKey: SetPrefs_colsToShow];
	[defaults setObject: [NSArray arrayWithObjects:
			dataFromColor([NSColor colorWithCalibratedRed: 0.7 green: 0.0 blue: 0.0 alpha: 1.0]),
			dataFromColor([NSColor colorWithCalibratedRed: 0.0 green: 0.7 blue: 0.0 alpha: 1.0]),
			dataFromColor([NSColor colorWithCalibratedRed: 0.0 green: 0.0 blue: 0.7 alpha: 1.0]),
			nil
		] forKey: SetPrefs_cardColors];
	[defaults setObject: [NSNumber numberWithFloat: 0.25] forKey: SetPrefs_cardShadeAlpha];
	[defaults setObject: [NSNumber numberWithFloat: 1.00] forKey: SetPrefs_cardShadeBlend];
	[defaults setObject: [NSNumber numberWithFloat: 1.00] forKey: SetPrefs_cardOpenAlpha];
	[defaults setObject: [NSNumber numberWithFloat: 0.00] forKey: SetPrefs_cardOpenBlend];
	[defaults setObject: [NSNumber numberWithFloat: 0.04] forKey: SetPrefs_cardStroke];
	
	[defaults setObject: SetPrefs_keymap_qw forKey: SetPrefs_keymap];
	[defaults setObject: [NSNumber numberWithBool: SetStrictNoSetMode] forKey: SetPrefs_strictNoSet];
	[defaults setObject: [NSNumber numberWithBool: SetLimitSelectionMode] forKey: SetPrefs_limitSelection];
	[defaults setObject: [NSNumber numberWithBool: FALSE] forKey: SetPrefs_badSetDeselects];
	[defaults setObject: [NSNumber numberWithBool: FALSE] forKey: SetPrefs_quickSetCall];
	[defaults setObject: [NSNumber numberWithBool: FALSE] forKey: SetPrefs_dealContinuous];
	[defaults setObject: [NSNumber numberWithBool: FALSE] forKey: SetPrefs_dealRandom];
	
	[defaults setObject: [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithInt: 3],
				SetPrefs_scoring_set,
			[NSNumber numberWithInt: -4],
				SetPrefs_scoring_notASet,
			[NSNumber numberWithInt: 3],
				SetPrefs_scoring_noSet,
			[NSNumber numberWithInt: 0],
				SetPrefs_scoring_notANoSet,
			nil
		] forKey: SetPrefs_scoring];
	
	[defaults setObject: [NSArray arrayWithObjects:
			[NSDictionary dictionaryWithObjectsAndKeys:
					@"Team Bondi",
						SetPrefs_teams_name,
					@"1",
						SetPrefs_teams_key,
					[NSNumber numberWithUnsignedInt: 0],
						SetPrefs_teams_score,
					nil
				],
			[NSDictionary dictionaryWithObjectsAndKeys:
					@"Car Ramrod",
						SetPrefs_teams_name,
					@"2",
						SetPrefs_teams_key,
					[NSNumber numberWithUnsignedInt: 0],
						SetPrefs_teams_score,
					nil
				],
			[NSDictionary dictionaryWithObjectsAndKeys:
					@"Wild Eep",
						SetPrefs_teams_name,
					@"3",
						SetPrefs_teams_key,
					[NSNumber numberWithUnsignedInt: 0],
						SetPrefs_teams_score,
					nil
				],
			nil
		] forKey: SetPrefs_teams];
	[defaults setObject: [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithUnsignedInt: SetEventScore_Set],
				SetPrefs_scoring_set,
			[NSNumber numberWithUnsignedInt: SetEventScore_NotASet],
				SetPrefs_scoring_notASet,
			[NSNumber numberWithUnsignedInt: SetEventScore_NoSet],
				SetPrefs_scoring_noSet,
			[NSNumber numberWithUnsignedInt: SetEventScore_NotANoSet],
				SetPrefs_scoring_notANoSet,
			nil
		] forKey: SetPrefs_scoring];
	
	[defaults setObject: [NSArray arrayWithObjects:
			[NSNumber numberWithBool: TRUE],
			[NSNumber numberWithBool: TRUE],
			[NSNumber numberWithBool: TRUE],
			nil
		] forKey: SetPrefs_deckShapes];
	[defaults setObject: [NSArray arrayWithObjects:
			[NSNumber numberWithBool: TRUE],
			[NSNumber numberWithBool: TRUE],
			[NSNumber numberWithBool: TRUE],
			nil
		] forKey: SetPrefs_deckColors];
	[defaults setObject: [NSArray arrayWithObjects:
			[NSNumber numberWithBool: TRUE],
			[NSNumber numberWithBool: TRUE],
			[NSNumber numberWithBool: TRUE],
			nil
		] forKey: SetPrefs_deckNumbers];
	[defaults setObject: [NSArray arrayWithObjects:
			[NSNumber numberWithBool: TRUE],
			[NSNumber numberWithBool: TRUE],
			[NSNumber numberWithBool: TRUE],
			nil
		] forKey: SetPrefs_deckFills];
	
	[defaults setObject: [NSNumber numberWithUnsignedInt: 1] forKey: SetPrefs_decks];
	
	[userDefaults registerDefaults: defaults];
}
