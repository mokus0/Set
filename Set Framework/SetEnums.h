#import "SetConstants.h"

/* implemented in SetCard.m */
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


