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
	
	[userDefaults registerDefaults: defaults];
}
