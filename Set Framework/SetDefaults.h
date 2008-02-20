//
//  SetDefaults.h
//  Set
//
//  Created by mokus on Wed Mar 30 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

#define SetAppDefaultsKey			@"net.deepbondi.set"

	/* Card appearance */
#define SetPrefs_cardColors			@"cardColors"			/* SetCard */
#define SetPrefs_cardShadeAlpha		@"cardShadeAlpha"		/* SetCard */
#define SetPrefs_cardShadeBlend		@"cardShadeBlend"		/* SetCard */
#define SetPrefs_cardOpenAlpha		@"cardOpenAlpha"		/* SetCard */
#define SetPrefs_cardOpenBlend		@"cardOpenBlend"		/* SetCard */
#define SetPrefs_cardStroke			@"cardStroke"			/* SetCard */

@class NSColor, NSData;
NSData  *dataFromColor(NSColor *color);
NSColor *colorFromData(NSData *data);

void setInitPrefs(void);

