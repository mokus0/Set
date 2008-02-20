//
//  main.m
//  Set
//
//  Created by mokus on Sun Mar 27 2005.
//  Copyright (c) 2005 James Cook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SetDefaults.h"

int main(int argc, const char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	setInitPrefs();
	
	[pool release];
	
    return NSApplicationMain(argc, argv);
}
