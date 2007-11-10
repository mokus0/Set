/*
 *  SetConstants.h
 *  Set
 *
 *  Created by mokus on Tue Mar 29 2005.
 *  Copyright (c) 2005 James Cook. All rights reserved.
 *
 */
 

	/* Note that changing SetCardsPerSet requires changes elsewhere */
#define SetCardsPerSet			3
#define SetAttributeCount		4

#define SetMaxRows				SetCardsPerSet
#define SetMaxCols				7
#define SetMaxCards				(SetMaxCols * SetMaxRows)

#define SetStartingCols			4
#define SetVisibleCols			4

#define SetMaxSelected			SetCardsPerSet

#define SetStrictNoSetMode		TRUE
#define SetLimitSelectionMode   TRUE


#define SetEventScore_Set		3
#define SetEventScore_NotASet   -4
#define SetEventScore_NoSet		3
#define SetEventScore_NotANoSet 0


	/* these are ratios, basically: width is 1.0*/
#define SetShapeInsetW			0.12
#define SetShapeInsetH			0.12
#define SetShapeHeight			0.52
#define Set3ShapeSpacing		0.18
#define Set2ShapeSpacing		0.18

#define SetShapeSpacing(n)		((n == 3) ? Set3ShapeSpacing : ((n == 2) ? Set2ShapeSpacing : 0))

#define SetShapeAreaHeight		(3 * SetShapeHeight + 2 * Set3ShapeSpacing)
#define SetDrawingHeight(n)		(n * SetShapeHeight + SetShapeSpacing(n))

