#import "TerminalWindow.h"

@implementation TerminalWindowController(scripting)

- (void) sendCommand:(NSString*) cmd {
  if ([cmd length]) {
    const char *c = [cmd cString];
    [tView ts_sendCString:c];
  }
}

- (void) dumpScrollBuffer:(NSString*) path {
  if (!path) return;

  [tView writeScrollBufferToFile:path];
}

@end
