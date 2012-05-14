#import <Foundation/Foundation.h>

// All literals in SVG specification.
typedef enum SKLiteral { {% for lit in literals %}
  {{ lit.c_string() }},{% endfor %}
  SKUndefined
} SKLiteral;

BOOL SKScanArray(NSScanner* scanner, NSArray** ptr, 
                 BOOL (*SKScanFN)(NSScanner*,id*), NSArray* valid);
BOOL SKLiteralInGroup(SKLiteral literal, SKLiteral *valid);
BOOL SKScanLiteral(NSScanner* scanner, SKLiteral* ptr, SKLiteral* valid);
BOOL SKScanWhitespaces(NSScanner*, NSString**);
BOOL SKScanSeparator(NSScanner *scanner, NSString**);
BOOL SKScanNumber(NSScanner *scanner, NSNumber**);
BOOL SKScanDouble(NSScanner *scanner, double*);
BOOL SKScanString(NSScanner *scanner, NSString**);

BOOL SKScanNumberArray(NSScanner* scanner, NSArray** ptr);
BOOL SKScanSingleQuotedString(NSScanner *scanner, NSString **ptr);
BOOL SKScanDoubleQuotedString(NSScanner *scanner, NSString **ptr);
BOOL SKScanStringArray(NSScanner* scanner, NSArray** ptr);

// All literal strings. (Must map to enum SKLiteral)
NSString* SKLiteralString[SKUndefined];
{% for ltype in ltypes %}
BOOL {{ltype.c_scan_function_string()}}(NSScanner*, SKLiteral*);{% endfor %}

{% for ctype in ctypes %}
@interface {{ctype.c_type_string()}} : NSObject { {% for ivar in ctype.ivars() %}
  {{ivar.c_type_string()}} {{ivar.c_name_string()}};{% endfor %}
};

{% for ivar in ctype.ivars() %}@property {% if ivar.is_ptr() %}(nonatomic,retain){% endif %}{{ivar.c_type_string()}} {{ivar.c_name_string()}};
{% endfor %}@end

BOOL {{ctype.c_scan_function_string()}}(NSScanner*, {{ctype.c_type_string()}}** ptr);
BOOL {{ctype.c_scan_function_string()}}Array(NSScanner*, NSArray** ptr);
{% endfor %}
