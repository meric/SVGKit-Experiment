// autogenerated
#import <Foundation/Foundation.h>

// All literals in SVG specification.
typedef enum SKLiteral { 
  SK100,
  SK200,
  SK300,
  SK400,
  SK500,
  SK600,
  SK700,
  SK800,
  SK900,
  SKBlink,
  SKBold,
  SKBolder,
  SKCM,
  SKCaption,
  SKCondensed,
  SKCurrentColor,
  SKDEG,
  SKDefer,
  SKDisable,
  SKEM,
  SKEX,
  SKExpanded,
  SKExtraCondensed,
  SKExtraExpanded,
  SKGRAD,
  SKHASH,
  SKHZ,
  SKIN,
  SKIcon,
  SKInherit,
  SKItalic,
  SKKHZ,
  SKKerning,
  SKLighter,
  SKLineThrough,
  SKMM,
  SKMagnify,
  SKMatrix,
  SKMeet,
  SKMenu,
  SKMessageBox,
  SKNarrower,
  SKNone,
  SKNormal,
  SKOblique,
  SKOverline,
  SKPC,
  SKPT,
  SKPX,
  SKPercent,
  SKRAD,
  SKRGB,
  SKRGBA,
  SKRotate,
  SKScale,
  SKSemiCondensed,
  SKSemiExpanded,
  SKSkewX,
  SKSkewY,
  SKSlice,
  SKSmallCaps,
  SKSmallCaption,
  SKStatusBar,
  SKTranslate,
  SKUltraCondensed,
  SKUltraExpanded,
  SKUnderline,
  SKWider,
  SKXMaxYMax,
  SKXMaxYMid,
  SKXMaxYMin,
  SKXMidYMax,
  SKXMidYMid,
  SKXMidYMin,
  SKXMinYMax,
  SKXMinYMid,
  SKXMinYMin,
  SKUndefined
} SKLiteral;

BOOL SKScanArray(NSScanner* scanner, NSArray** ptr, 
                 BOOL (*SKScanFN)(NSScanner*,id*), NSArray* valid);
BOOL SKScanLiteral(NSScanner* scanner, SKLiteral* ptr, SKLiteral* valid);

BOOL SKScanWhitespaces(NSScanner*, NSString**);
BOOL SKScanSeparator(NSScanner *scanner, NSString**);
BOOL SKScanNumber(NSScanner *scanner, NSNumber**);
BOOL SKScanDouble(NSScanner *scanner, double*);
BOOL SKScanString(NSScanner *scanner, NSString**);

BOOL SKScanNumberArray(NSScanner* scanner, NSArray** ptr);
BOOL SKScanStringArray(NSScanner* scanner, NSArray** ptr);

// All literal strings. (Must map to enum SKLiteral)
NSString* SKLiteralString[SKUndefined];

BOOL SKScanNone(NSScanner*, SKLiteral*);
BOOL SKScanTypeForColor(NSScanner*, SKLiteral*);
BOOL SKScanStyleForFont(NSScanner*, SKLiteral*);
BOOL SKScanAlignForPreserveAspectRatio(NSScanner*, SKLiteral*);
BOOL SKScanNormal(NSScanner*, SKLiteral*);
BOOL SKScanDeferForPreserveAspectRatio(NSScanner*, SKLiteral*);
BOOL SKScanUnitForLength(NSScanner*, SKLiteral*);
BOOL SKScanMeetOrSliceForPreserveAspectRatio(NSScanner*, SKLiteral*);
BOOL SKScanInherit(NSScanner*, SKLiteral*);
BOOL SKScanVariantForFont(NSScanner*, SKLiteral*);
BOOL SKScanKerning(NSScanner*, SKLiteral*);
BOOL SKScanUnitForFrequency(NSScanner*, SKLiteral*);
BOOL SKScanWeightForFont(NSScanner*, SKLiteral*);
BOOL SKScanStretchForFont(NSScanner*, SKLiteral*);
BOOL SKScanMethodForTransform(NSScanner*, SKLiteral*);
BOOL SKScanLiteralForFont(NSScanner*, SKLiteral*);
BOOL SKScanUnitForAngle(NSScanner*, SKLiteral*);
BOOL SKScanDecorationForTextDecoration(NSScanner*, SKLiteral*);


@interface SKColor : NSObject { 
  NSArray* array;
  SKLiteral type;
  NSString* value;
};

@property (nonatomic,retain)NSArray* array;
@property SKLiteral type;
@property (nonatomic,retain)NSString* value;
@end

BOOL SKScanColor(NSScanner*, SKColor** ptr);
BOOL SKScanColorArray(NSScanner*, NSArray** ptr);

@interface SKInnerColor : NSObject { 
  NSArray* array;
  SKLiteral type;
  NSString* value;
};

@property (nonatomic,retain)NSArray* array;
@property SKLiteral type;
@property (nonatomic,retain)NSString* value;
@end

BOOL SKScanInnerColor(NSScanner*, SKInnerColor** ptr);
BOOL SKScanInnerColorArray(NSScanner*, NSArray** ptr);

@interface SKLength : NSObject { 
  SKLiteral unit;
  double value;
};

@property SKLiteral unit;
@property double value;
@end

BOOL SKScanLength(NSScanner*, SKLength** ptr);
BOOL SKScanLengthArray(NSScanner*, NSArray** ptr);

@interface SKPreserveAspectRatio : NSObject { 
  SKLiteral defer;
  SKLiteral align;
  SKLiteral meetOrSlice;
};

@property SKLiteral defer;
@property SKLiteral align;
@property SKLiteral meetOrSlice;
@end

BOOL SKScanPreserveAspectRatio(NSScanner*, SKPreserveAspectRatio** ptr);
BOOL SKScanPreserveAspectRatioArray(NSScanner*, NSArray** ptr);

@interface SKTransform : NSObject { 
  NSArray* values;
  SKLiteral method;
};

@property (nonatomic,retain)NSArray* values;
@property SKLiteral method;
@end

BOOL SKScanTransform(NSScanner*, SKTransform** ptr);
BOOL SKScanTransformArray(NSScanner*, NSArray** ptr);
