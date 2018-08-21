
//

#import <Cocoa/Cocoa.h>

@interface CustomProgress : NSView

//@property(nonatomic, retain)Label *presentlab;

@property(nonatomic)float maxValue;

@property(nonatomic,strong)NSColor *bgimgColor;

@property(nonatomic,strong)NSColor *leftimgColor;

@property(nonatomic)float present;


@end
