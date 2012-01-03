/*
 *  SetEnums.h
 *  Set
 *
 *  Created by mokus on Sun Mar 27 2005.
 *  Copyright (c) 2005 James Cook. All rights reserved.
 *
 */

#import "SetConstants.h"

/* implemented in SetCard.h */
extern NSString *ShapeDescriptions[];
extern NSString *ColorDescriptions[];
extern NSString *NumberDescriptions[];
extern NSString *FillDescriptions[];

typedef enum {
		Shape,
		Color,
		Number,
		Fill
	} SetAttribute;

typedef enum {
		Diamond,
		Oval,
		Squiggle
	} SetShape;

typedef enum {
		Red,
		Green,
		Blue
	} SetColor;

typedef enum {
		One,
		Two,
		Three
	} SetNumber;

typedef enum {
		Solid,
		Shaded,
		Open
	} SetFill;


