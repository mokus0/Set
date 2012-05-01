#import <Cocoa/Cocoa.h>
#import "SetCard.h"
#import "SetDefaults.h"
#import "SetFunctions.h"



	/* .-======== Global Data =========-. */
NSString *ShapeDescriptions[SetCardsPerSet] = {
	@"Diamond", @"Oval", @"Squiggle"
};
NSString *ColorDescriptions[SetCardsPerSet] = {
	@"Red", @"Green", @"Blue"
};
NSString *NumberDescriptions[SetCardsPerSet] = {
	@"1", @"2", @"3"
};
NSString *FillDescriptions[SetCardsPerSet] = {
	@"Solid", @"Shaded", @"Open"
};



	/* .-========= Local Data =========-. */
static NSColor *cardBackColor = nil;
static NSImage *cardBack = nil;
static NSSize cardBackSize = {0.0, 0.0};

static NSBezierPath *path = nil;

static NSColor *_color[SetCardsPerSet][SetCardsPerSet] = {{nil}};
static NSColor **_solid = _color[0];
static NSColor **_shaded = _color[1];
static NSColor **_open = _color[2];

static NSColor *failsafeColor[SetCardsPerSet] = {nil};

static float shapeStroke = 0.04;

#define SetPathStroke(c)	(_solid[c])
#define SetPathFill(f,c)	(_color[f][c])



	/* .-====== Local Prototypes ======-. */
static NSRect refitShapeArea(NSRect frame);

static inline NSPoint		_SetPoint(float x, float y, NSRect frame);
static inline NSPoint		_SetRelPoint(float x, float y, NSRect frame);
static inline float			_SetScale(float x, NSRect frame);
	// WARNING: these steal the "frame" binding wherever they are used
#define SetPoint(x,y)		_SetPoint(x,y,frame)
#define SetRelPoint(x,y)	_SetRelPoint(x,y,frame)
#define SetScale(x)			_SetScale(x,frame)

static inline NSColor *strokeColor(SetColor c);
static inline NSColor *fillColor(SetColor c, SetFill f);

static void drawShape(NSRect frame, SetShape shape, NSColor *stroke, NSColor *fill);

static void drawDiamond(NSRect rect);
static void drawOval(NSRect rect);
static void drawSquiggle(NSRect rect);



	/* .-==== Class Implementation ====-. */
@implementation SetCard

+ (void)initialize {
	NSBundle *mainBundle = [NSBundle bundleForClass: self];
	NSString *cardBackPath = [mainBundle pathForResource: @"cardBack" ofType: @"tiff"];
	
	if (cardBackPath)
		cardBack = [[NSImage alloc] initWithContentsOfFile: cardBackPath];
	else
		NSLog(@"SetCardCell: Failed to locate card back image");
	
	[cardBack setScalesWhenResized: TRUE];
	[cardBack setFlipped: TRUE];
	
	cardBackSize = [cardBack size];
	
	cardBackColor = [NSColor colorWithCalibratedHue: (280.0 / 360) saturation: 1.0 brightness: (60.0/100) alpha: 1.0];
	[cardBackColor retain];
	
	/* the bezier-path worker bee */
	path = [[NSBezierPath alloc] init];
	
		// in case somebody stuffs something stupid in the defaults
	failsafeColor[0] = [[NSColor colorWithCalibratedRed: 0.7 green: 0.0 blue: 0.0 alpha: 1.0] retain];
	failsafeColor[1] = [[NSColor colorWithCalibratedRed: 0.0 green: 0.7 blue: 0.0 alpha: 1.0] retain];
	failsafeColor[2] = [[NSColor colorWithCalibratedRed: 0.0 green: 0.0 blue: 0.7 alpha: 1.0] retain];
	
	[self setCardColors];
}

+ (void) setCardColors {
	unsigned int i, j;
	
	NSColor *white = [NSColor whiteColor];
	NSColor *gray = [NSColor shadowColor];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSArray *colors = [defaults objectForKey: SetPrefs_cardColors];
	NSNumber *shadeBlendNS = [defaults objectForKey: SetPrefs_cardShadeBlend];
	NSNumber *shadeAlphaNS = [defaults objectForKey: SetPrefs_cardShadeAlpha];
	NSNumber *openBlendNS = [defaults objectForKey: SetPrefs_cardOpenBlend];
	NSNumber *openAlphaNS = [defaults objectForKey: SetPrefs_cardOpenAlpha];

	NSNumber *shapeStrokeNS = [defaults objectForKey: SetPrefs_cardStroke];
	
	float shadeBlend = isClass(shadeBlendNS, NSNumber) ? [shadeBlendNS floatValue] : 1.0;
	float shadeAlpha = isClass(shadeAlphaNS, NSNumber) ? [shadeAlphaNS floatValue] : 0.3;
	float openBlend = isClass(openBlendNS, NSNumber) ? [openBlendNS floatValue] : 0.0;
	float openAlpha = isClass(openAlphaNS, NSNumber) ? [openAlphaNS floatValue] : 0.8;
	
	shapeStroke = isClass(shapeStrokeNS, NSNumber) ? [shapeStrokeNS floatValue] : shapeStroke;
	
	if(isClass(colors, NSArray) && ([colors count] >= SetCardsPerSet)) {
		for (i = 0; i < SetCardsPerSet; i++) {
			id item = [colors objectAtIndex: i];
			
			if (_solid[i])
				[_solid[i] release];
			
			ifClass(item, NSData) {
				item = colorFromData(item);
			}
			
			ifClass(item, NSColor) {
				_solid[i] = item;
			} else {
				NSLog(@"prefs color #%u (%@) no good - using failsafe", i, item);
				_solid[i] = failsafeColor[i];
			}
		}
	} else {
		[self setFailsafeColors];
	}
	
	for (i = 0; i < SetCardsPerSet; i++) {
		_shaded[i] = [_solid[i] blendedColorWithFraction: (1.0 - shadeBlend) ofColor: gray];
		_shaded[i] = [_shaded[i] colorWithAlphaComponent: shadeAlpha];
		
		_open[i] = [_solid[i] blendedColorWithFraction: (1.0 - openBlend) ofColor: white];
		_open[i] = [_open[i] colorWithAlphaComponent: openAlpha];
	}
	
	for (i = 0; i < SetCardsPerSet; i++) {
		for (j = 0; j < SetCardsPerSet; j++) {
			[_color[i][j] retain];
		}
	}
}

+ (void) setFailsafeColors {
	unsigned int i;
	
	for (i = 0; i < SetCardsPerSet; i++) {
		_solid[i] = failsafeColor[i];
	}
}

+ (void) drawCardBackWithFrame: (NSRect) frame {
	NSRect imgSrc = NSMakeRect(0, 0, cardBackSize.width, cardBackSize.height);
	NSRect imgDst = NSInsetRect(frame, 2.0, 2.0);
	
	imgSrc = proportionalRectToRect(imgSrc, imgDst);
	[cardBackColor set];
	[NSBezierPath fillRect: imgDst];
	
	[cardBack drawInRect:	imgDst
			fromRect:   imgSrc
			operation:  NSCompositeCopy
			fraction:   1.0
		];
}

+ (SetCard *) deckFirstCard {
	return [[self alloc] init];
}

+ (SetCard *) deckCardAfter: (SetCard *) card {
	SetCard *nextCard;
	
	SetShape  s = [card shape]  + 1;
	SetColor  c = [card color]  + ((s >= 3) ? 1 : 0);
	SetNumber n = [card number] + ((c >= 3) ? 1 : 0);
	SetFill   f = [card fill]   + ((n >= 3) ? 1 : 0);
	
	s %= SetCardsPerSet;
	c %= SetCardsPerSet;
	n %= SetCardsPerSet;
	if (f >= SetCardsPerSet) return nil;
	
	nextCard = [[self alloc] 
		initWithShape:  s
				color:  c
			   number:  n
				 fill:  f
		];
	
	return nextCard;
}

- (id) init {
	self = [super init];
	if (self) {
		shape = color = number = fill = 0;
	}
	return self;
}

- (id) initWithShape: (SetShape) s color: (SetColor) c number: (SetNumber) n fill: (SetFill) f {
	self = [self init];
	if (self) {
		shape = s;
		color = c;
		number = n;
		fill = f;
		
		if (
				((unsigned int) shape >= SetCardsPerSet)
			 || ((unsigned int) color >= SetCardsPerSet)
			 || ((unsigned int) number >= SetCardsPerSet)
			 || ((unsigned int) fill >= SetCardsPerSet)
			) {
				[self release];
				self = nil;
			}
	}
	return self;
}

- (id) copyWithZone: (NSZone *) zone {
	return self;
}


- (BOOL) isEqual: (id) other {
	ifClass (other, SetCard) {
		return ([self hash] == [other hash]);
	}
	
	return FALSE;
}

- (unsigned int) hash {
	return (
			   shape
			+ (color  << 8)
			+ (number << 16)
			+ (fill   << 24)
		);
}

- (NSString *) description {
	return [NSString stringWithFormat: @"<%@ %@ %@ (x%@)>", 
		FillDescriptions[fill],
		ColorDescriptions[color],
		ShapeDescriptions[shape],
		NumberDescriptions[number]
	];
}

- (SetShape) shape   {	return shape;   }
- (SetColor) color   {	return color;   }
- (SetNumber) number {	return number;  }
- (SetFill) fill     {	return fill;	}

- (void) drawInRect: (NSRect) frame {
	NSColor *st = strokeColor(color);
	NSColor *fi = fillColor(color, fill);
	
	frame = refitShapeArea(frame);
	
	switch (number) {
		case One:
			drawShape(frame, shape, st, fi);
			break;
		case Two:
			frame.origin.y += frame.size.width * (SetShapeHeight + Set2ShapeSpacing) / 2;
			drawShape(frame, shape, st, fi);
			frame.origin.y -= frame.size.width * (SetShapeHeight + Set2ShapeSpacing);
			drawShape(frame, shape, st, fi);
			break;
		case Three:
			drawShape(frame, shape, st, fi);
			frame.origin.y += frame.size.width * (SetShapeHeight + Set3ShapeSpacing);
			drawShape(frame, shape, st, fi);
			frame.origin.y -= frame.size.width * (SetShapeHeight + Set3ShapeSpacing) * 2;
			drawShape(frame, shape, st, fi);
			break;
		default:
			NSLog(@"This can't be happening!");
	}
}

@end



	/* .-====== Local Functions =======-. */
static NSRect refitShapeArea(NSRect frame) {
	return proportionalRectToRect(frame, NSMakeRect(0,0,1, SetShapeAreaHeight));
}

	/* remap -1..1 to frame X coords, make Y match, etc. */
static inline NSPoint _SetPoint(float x, float y, NSRect frame) {
	float scalingFactor = NSWidth(frame) / 2;
	
	return NSMakePoint(
			NSMidX(frame) + x * scalingFactor,
			NSMidY(frame) + y * scalingFactor
		);
}

static inline NSPoint _SetRelPoint(float x, float y, NSRect frame) {
	float scalingFactor = NSWidth(frame) / 2;
	
	return NSMakePoint(
			x * scalingFactor,
			y * scalingFactor
		);
}

static inline float _SetScale(float x, NSRect frame) {
	return NSWidth(frame) * x;
}

static inline NSColor *strokeColor(SetColor c) {
	if ((unsigned) c >= SetCardsPerSet)
		return [NSColor blackColor];
	
	return SetPathStroke(c);
}

static inline NSColor *fillColor(SetColor c, SetFill f) {
	if (((unsigned) c >= SetCardsPerSet) || ((unsigned) f >= SetCardsPerSet))
		return [NSColor grayColor];
	
	return SetPathFill(f,c);
}

static void drawShape(NSRect frame, SetShape shape, NSColor *stroke, NSColor *fill) {
	switch(shape) {
		case Diamond:
			drawDiamond(frame);
			break;
		case Oval:
			drawOval(frame);
			break;
		case Squiggle:
			drawSquiggle(frame);
			break;
		default:
			NSLog(@"This can't be happening!");
			return;
	}
	
	[fill set];
	[path fill];
	
	[stroke set];
	[path stroke];
}

#define diamondScale		1.0
#define diamondPoint(x,y)   SetPoint((float)x/diamondScale,(float)y/diamondScale)

void drawDiamond(NSRect frame) {
	NSPoint points[] = {
			diamondPoint(-1, 0),
			diamondPoint(0, SetShapeHeight),
			diamondPoint(1, 0),
			diamondPoint(0, -SetShapeHeight)
		};
	unsigned int numPoints = sizeof(points) / sizeof(points[0]);
	
	[path removeAllPoints];
	
	[path setLineWidth: NSWidth(frame) * shapeStroke];
	[path appendBezierPathWithPoints: points count: numPoints];
	[path closePath];
}

#define ovalScale			1.0
#define ovalPoint(x,y)		SetPoint((float)x/ovalScale,(float)y/ovalScale)
#define ovalRadius(r)		SetScale((float)r/ovalScale)

void drawOval(NSRect frame) {
	[path removeAllPoints];
	
	[path setLineWidth: NSWidth(frame) * shapeStroke];
	
	[path appendBezierPathWithArcWithCenter:
				ovalPoint(1 - SetShapeHeight, 0)
			radius: ovalRadius(SetShapeHeight / 2)
			startAngle: 270.0
			endAngle: 90.0
		];
	[path appendBezierPathWithArcWithCenter:
				ovalPoint(-1 + SetShapeHeight, 0)
			radius: ovalRadius(SetShapeHeight / 2)
			startAngle: 90.0
			endAngle: -90.0
		];
	[path closePath];
}

#define squiggleScale			500.0
#define squiggleStart			squigglePoint(-375.0, 150.0)
#define squigglePoint(x,y)		SetPoint((float)x/squiggleScale,(float)y/squiggleScale)
#define squiggleRelPoint(x,y)   SetRelPoint((float)x/squiggleScale,(float)y/squiggleScale)

void drawSquiggle(NSRect frame) {
	[path removeAllPoints];
	
	[path setLineWidth: NSWidth(frame) * shapeStroke];
	
	[path moveToPoint: squiggleStart];
	[path relativeCurveToPoint: squiggleRelPoint(373.18, 45.96)
			controlPoint1:squiggleRelPoint(99.34, 91.56)
			controlPoint2:squiggleRelPoint(294.74, 87.01)
		];
	[path relativeCurveToPoint: squiggleRelPoint(303.16, 14.45)
			controlPoint1:squiggleRelPoint(103.55, -54.21)
			controlPoint2:squiggleRelPoint(210.3, -54.26)
		];
	[path relativeCurveToPoint: squiggleRelPoint(203.95, -80.91)
			controlPoint1:squiggleRelPoint(72.83, 53.88)
			controlPoint2:squiggleRelPoint(168.25, 87.96)
		];
	[path relativeCurveToPoint: squiggleRelPoint(-95.42, -298.67)
			controlPoint1:squiggleRelPoint(19.95, -94.26)
			controlPoint2:squiggleRelPoint(-6.16, -214.36)
		];
	[path relativeCurveToPoint: squiggleRelPoint(-356.62, -0.62)
			controlPoint1:squiggleRelPoint(-81.93, -77.38)
			controlPoint2:squiggleRelPoint(-231.11, -68.69)
		];
	[path relativeCurveToPoint: squiggleRelPoint(-357.19, -13.52)
			controlPoint1:squiggleRelPoint(-116.52, 63.18)
			controlPoint2:squiggleRelPoint(-297.36, 43.28)
		];
	[path relativeCurveToPoint: squiggleRelPoint(-164.86, 1.99)
			controlPoint1:squiggleRelPoint(-69.45, -65.92)
			controlPoint2:squiggleRelPoint(-120, -81.68)
		];
	[path relativeCurveToPoint: squiggleRelPoint(93.8, 331.32)
			controlPoint1:squiggleRelPoint(-31.82, 59.34)
			controlPoint2:squiggleRelPoint(-39.75, 208.22)
		];
	
	[path closePath];
}

