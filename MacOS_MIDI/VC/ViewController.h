
//

#import <Cocoa/Cocoa.h>
#import "CustomProgress.h"
#import "MIDIManager.h"

@interface ViewController : NSViewController<MidiGetDataDelegate>
{
    
}
@property (weak) IBOutlet NSTextField *filePathTF;
@property (weak) IBOutlet NSButton *OpenBut;
@property (weak) IBOutlet NSButton *UpdateBut;
@property (weak) IBOutlet CustomProgress *processView;

@end

