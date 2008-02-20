/*
 *  SetConstants.h
 *  Set
 *
 *  Created by mokus on Tue Mar 29 2005.
 *  Copyright (c) 2005 James Cook. All rights reserved.
 *
 */
 
	/* Basic physics of the Set universe */
	/* Note that changing SetCardsPerSet requires changes elsewhere */
#define SetCardsPerSet			3
#define SetAttributeCount		4

	/* Dimensions of various parts of the set card artwork */
	/* these are ratios, basically: width is 1.0 */
#define SetShapeInsetW			0.12
#define SetShapeInsetH			0.12
#define SetShapeHeight			0.52
#define Set3ShapeSpacing		0.18
#define Set2ShapeSpacing		0.18

#define SetShapeSpacing(n)		((n == 3) ? Set3ShapeSpacing : ((n == 2) ? Set2ShapeSpacing : 0))

#define SetShapeAreaHeight		(3 * SetShapeHeight + 2 * Set3ShapeSpacing)
#define SetDrawingHeight(n)		(n * SetShapeHeight + SetShapeSpacing(n))

