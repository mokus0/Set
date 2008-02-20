/*
 *  SetFunctions.c
 *  Set
 *
 *  Created by mokus on Sun Mar 27 2005.
 *  Copyright (c) 2005 James Cook. All rights reserved.
 *
 */

	/* .-====== Primary headers =======-. */
#import <Cocoa/Cocoa.h>
#import "SetFunctions.h"

	/* shrinks src to make it the same aspect as dst */
NSRect proportionalRectToRect(NSRect src, NSRect dst) {
	float srcAspect = src.size.height / src.size.width;
	float dstAspect = dst.size.height / dst.size.width;
	
	if (srcAspect != dstAspect) {
		if (srcAspect < dstAspect) {
			// Keep height constant, make narrower
			
			float newWidth = src.size.height / dstAspect;
			float dW = src.size.width - newWidth;
			
			src.origin.x += dW / 2;
			src.size.width = newWidth;
		} else {
			float newHeight = src.size.width * dstAspect;
			float dH = src.size.height - newHeight;
			
			src.size.height = newHeight;
			src.origin.y += dH / 2;
		}
	}
	
	return src;
}
